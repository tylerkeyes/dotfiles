-- Enhanced LSP error handling to prevent protocol issues
local M = {}

-- Filter out common LSP startup noise and protocol errors
local function filter_lsp_noise(err, result, ctx, config)
  if not result then return end

  local message = result.message or (result.params and result.params.message) or ""

  -- Filter out Node.js version messages and ANSI color codes
  if message:match("Resolved node") or
     message:match("Using Hermetic NodeJS") or
     message:match("Content%-Length not found") or
     message:match("^%[%d+;%d+m") or -- ANSI color codes
     message:match("%[%d+m") or      -- More ANSI patterns
     message:match("\\u001b%[") or   -- Unicode escape sequences
     message:match("\27%[") then     -- Escape character patterns
    return
  end

  return true -- Allow other messages through
end

-- Setup enhanced error handlers
function M.setup()
  -- CRITICAL: Direct override of vim.lsp.rpc.parse_chunk before any LSP starts
  local rpc_module = require('vim.lsp.rpc')
  if rpc_module.parse_chunk then
    local original_parse_chunk = rpc_module.parse_chunk
    rpc_module.parse_chunk = function(chunk)
      if type(chunk) == "string" and chunk ~= "" then
        local original_chunk = chunk

        -- Check if this chunk contains hnvm output
        if chunk:match("Resolved node") or chunk:match("Using Hermetic NodeJS") then
          -- Pre-process chunk to remove hnvm colored output
          local processed = chunk

          -- Remove ANSI escape sequences first
          processed = processed:gsub("\27%[[0-9;]*[mK]", "")
          processed = processed:gsub("\27%[[0-9;]*[A-Za-z]", "")

          -- Split into lines and filter out hnvm messages
          local lines = {}
          local found_content_length = false

          for line in processed:gmatch("[^\r\n]*") do
            if line:match("^Content%-Length:") then
              found_content_length = true
              table.insert(lines, line)
            elseif found_content_length then
              -- We're in LSP content, keep everything
              table.insert(lines, line)
            elseif not (
              line:match("Resolved node") or
              line:match("Using Hermetic NodeJS") or
              line:match("^%s*$")
            ) then
              -- Keep non-hnvm lines
              table.insert(lines, line)
            end
          end

          local cleaned_chunk = table.concat(lines, "\n")

          -- Debug: Log what we're doing
          vim.schedule(function()
            vim.notify("Filtered hnvm output from LSP stream", vim.log.levels.DEBUG)
          end)

          -- Only process if we have valid LSP content
          if cleaned_chunk == "" or (not found_content_length and cleaned_chunk:match("^%s*$")) then
            return nil
          end

          chunk = cleaned_chunk
        end
      end

      return original_parse_chunk(chunk)
    end

    -- Confirm override is applied
    vim.notify("LSP RPC parse_chunk override applied for hnvm compatibility", vim.log.levels.INFO)
  else
    vim.notify("Warning: Could not override vim.lsp.rpc.parse_chunk", vim.log.levels.WARN)
  end

  -- CRITICAL: Override at the vim._system level to intercept LSP process output
  local original_system = vim.system
  vim.system = function(cmd, opts, on_exit)
    -- Check if this is an LSP-related Node.js process
    if cmd and type(cmd) == "table" and cmd[1] then
      local cmd_str = table.concat(cmd, " ")
      if cmd_str:match("node") and (cmd_str:match("vtsls") or cmd_str:match("typescript")) then
        -- This is a TypeScript LSP process, wrap the stdout handler
        opts = opts or {}
        local original_stdout = opts.stdout

        opts.stdout = function(err, data)
          if data and type(data) == "string" then
            -- Clean hnvm colored output from the data stream
            local cleaned_data = data

            -- Remove ANSI escape sequences
            cleaned_data = cleaned_data:gsub("\27%[[0-9;]*[mK]", "")
            cleaned_data = cleaned_data:gsub("\27%[[0-9;]*[A-Za-z]", "")

            -- Remove hnvm version messages that appear before LSP content
            local lines = {}
            local in_lsp_content = false

            for line in cleaned_data:gmatch("[^\r\n]*") do
              if line:match("^Content%-Length:") then
                in_lsp_content = true
                table.insert(lines, line)
              elseif in_lsp_content then
                table.insert(lines, line)
              elseif not (
                line:match("Resolved node") or
                line:match("Using Hermetic NodeJS") or
                line:match("^%s*$")
              ) then
                -- Keep non-hnvm lines that might be LSP content
                table.insert(lines, line)
              end
            end

            local processed_data = table.concat(lines, "\n")

            -- Only pass data if it contains meaningful content
            if processed_data ~= "" and not processed_data:match("^%s*$") then
              if original_stdout then
                original_stdout(err, processed_data)
              end
            end
          else
            if original_stdout then
              original_stdout(err, data)
            end
          end
        end
      end
    end

    return original_system(cmd, opts, on_exit)
  end

  -- Add safety wrapper for vim.fs.joinpath to prevent table.concat errors
  local original_joinpath = vim.fs.joinpath
  vim.fs.joinpath = function(...)
    local args = {...}
    local safe_args = {}

    -- Process each argument safely
    for i, arg in ipairs(args) do
      if type(arg) == "string" then
        table.insert(safe_args, arg)
      elseif type(arg) == "table" then
        -- If it's a table, it might be a list of paths - skip this call
        -- This is likely a misuse of the API
        return nil
      else
        -- Convert other types to string
        local str_arg = tostring(arg)
        if str_arg and str_arg ~= "" then
          table.insert(safe_args, str_arg)
        end
      end
    end

    -- Only call original if we have valid string arguments
    if #safe_args > 0 then
      return original_joinpath(unpack(safe_args))
    else
      return nil
    end
  end

  -- Add safety wrapper for vim.fs.find to prevent invalid arguments
  local original_find = vim.fs.find
  vim.fs.find = function(names, opts)
    -- Handle function arguments (likely a mistake in the calling code)
    if type(names) == "function" then
      -- This is likely a bug in the calling code, return empty result
      return {}
    end

    -- Ensure names is a table or string
    if type(names) ~= "table" and type(names) ~= "string" then
      return {}
    end

    -- Ensure opts is a table if provided
    if opts and type(opts) ~= "table" then
      opts = {}
    end

    -- Wrap in pcall to prevent crashes
    local ok, result = pcall(original_find, names, opts or {})
    if ok then
      return result
    else
      return {}
    end
  end

  -- Add safety wrapper for vim.fs.root to prevent invalid arguments
  local original_root = vim.fs.root
  vim.fs.root = function(source, marker)
    -- Ensure source is a valid buffer number or string path
    if type(source) ~= "number" and type(source) ~= "string" then
      vim.notify("vim.fs.root received invalid source argument: " .. vim.inspect(source), vim.log.levels.WARN)
      return nil
    end
    -- Ensure marker is a string or table
    if marker and type(marker) ~= "string" and type(marker) ~= "table" then
      vim.notify("vim.fs.root received invalid marker argument: " .. vim.inspect(marker), vim.log.levels.WARN)
      return nil
    end
    return original_root(source, marker)
  end

  -- Override window/logMessage handler
  local original_log_handler = vim.lsp.handlers["window/logMessage"]
  vim.lsp.handlers["window/logMessage"] = function(err, result, ctx, config)
    if not filter_lsp_noise(err, result, ctx, config) then
      return
    end
    if original_log_handler then
      return original_log_handler(err, result, ctx, config)
    end
  end

  -- Override window/showMessage handler
  local original_show_handler = vim.lsp.handlers["window/showMessage"]
  vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config)
    if not filter_lsp_noise(err, result, ctx, config) then
      return
    end
    if original_show_handler then
      return original_show_handler(err, result, ctx, config)
    end
  end

  -- Override the actual RPC message processing at the lowest level
  -- This intercepts the data before it reaches parse_chunk
  if vim.lsp.rpc and vim.lsp.rpc.start then
    local original_rpc_start = vim.lsp.rpc.start
    vim.lsp.rpc.start = function(cmd, cmd_args, dispatchers, extra_spawn_params)
      if dispatchers and dispatchers.on_data then
        local original_on_data = dispatchers.on_data
        dispatchers.on_data = function(chunk)
          if type(chunk) == "string" and chunk ~= "" then
            -- Clean hnvm output before it reaches the RPC parser
            local cleaned = chunk

            -- Remove ANSI escape sequences
            cleaned = cleaned:gsub("\27%[[0-9;]*[mK]", "")
            cleaned = cleaned:gsub("\27%[[0-9;]*[A-Za-z]", "")

            -- Handle hnvm messages that appear before LSP content
            local lines = {}
            local has_lsp_content = false

            for line in cleaned:gmatch("[^\r\n]*") do
              if line:match("^Content%-Length:") or line:match("^{") then
                has_lsp_content = true
                table.insert(lines, line)
              elseif has_lsp_content then
                table.insert(lines, line)
              elseif not (
                line:match("Resolved node") or
                line:match("Using Hermetic NodeJS") or
                line:match("^%s*$")
              ) then
                table.insert(lines, line)
              end
            end

            local processed = table.concat(lines, "\n")

            -- Only pass data if it has meaningful LSP content
            if processed ~= "" and (processed:match("Content%-Length:") or has_lsp_content) then
              return original_on_data(processed)
            elseif processed ~= cleaned then
              -- We filtered out hnvm noise, don't pass empty data
              return
            else
              -- Pass through unchanged if no filtering occurred
              return original_on_data(chunk)
            end
          else
            return original_on_data(chunk)
          end
        end
      end

      return original_rpc_start(cmd, cmd_args, dispatchers, extra_spawn_params)
    end
  end

  -- Allow hnvm to work normally but ensure LSP can handle its output
  -- We don't override vim.system here since we want hnvm to function
  -- The RPC parser above handles the colored output properly

  -- Override vim.lsp.rpc.start to intercept and clean LSP communication
  if vim.lsp.rpc and vim.lsp.rpc.start then
    local original_rpc_start = vim.lsp.rpc.start
    vim.lsp.rpc.start = function(cmd, cmd_args, dispatchers, extra_spawn_params)
      -- Create a wrapper for the dispatchers to clean incoming data
      local wrapped_dispatchers = {}
      if dispatchers then
        for k, v in pairs(dispatchers) do
          if k == "on_data" and type(v) == "function" then
            wrapped_dispatchers[k] = function(chunk)
              if type(chunk) == "string" then
                -- Clean the chunk before processing
                local cleaned = chunk
                -- Remove ANSI escape sequences
                cleaned = cleaned:gsub("\27%[[0-9;]*[mK]", "")
                cleaned = cleaned:gsub("\27%[[0-9;]*[A-Za-z]", "")
                -- Remove Node.js startup messages
                cleaned = cleaned:gsub("^[^\r\n]*Resolved node[^\r\n]*[\r\n]*", "")
                cleaned = cleaned:gsub("^[^\r\n]*Using Hermetic NodeJS[^\r\n]*[\r\n]*", "")

                -- Only pass clean data to the original handler
                if cleaned ~= chunk then
                  -- Data was cleaned, check if it's still valid
                  if cleaned:match("Content%-Length:") then
                    return v(cleaned)
                  else
                    -- Skip this chunk if it doesn't contain valid LSP data
                    return
                  end
                else
                  return v(chunk)
                end
              else
                return v(chunk)
              end
            end
          else
            wrapped_dispatchers[k] = v
          end
        end
      end

      return original_rpc_start(cmd, cmd_args, wrapped_dispatchers, extra_spawn_params)
    end
  end

  -- Set LSP log level to reduce noise
  vim.lsp.set_log_level("WARN")
end

return M
