export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# Added by Antigravity
export PATH="/Users/tylerkeyes/.antigravity/antigravity/bin:$PATH"

# Override MDM certificate settings that point to non-existent files
# This fixes warnings in Claude Code and other Node.js applications
unset NODE_EXTRA_CA_CERTS
unset AWS_CA_BUNDLE
