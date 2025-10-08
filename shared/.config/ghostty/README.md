# Ghostty Terminal Configuration

Configuration for [Ghostty](https://ghostty.org) - a fast, native, GPU-accelerated terminal emulator for macOS.

## Features

- **GPU acceleration** for smooth rendering
- **Native macOS integration** with proper font rendering
- **Quick terminal** with global hotkey access
- **Split panes** with vim-like navigation
- **Shell integration** with Fish

## Key Settings

### Quick Terminal
Global overlay terminal accessible from anywhere:
- **Hotkey**: `Ctrl+\`` (backtick)
- **Position**: Right side of screen
- **Size**: 500px width, 100% height
- **Animation**: 0.15s slide-in

### Split Panes
Vim-style navigation with hjkl keys:

**Navigation** (`Cmd+Alt+[hjkl]`):
- `Cmd+Alt+H` - Move to left pane
- `Cmd+Alt+J` - Move to bottom pane
- `Cmd+Alt+K` - Move to top pane
- `Cmd+Alt+L` - Move to right pane

**Creating Splits** (`Ctrl+Cmd+[hjkl]`):
- `Ctrl+Cmd+H` - New split on left
- `Ctrl+Cmd+J` - New split below
- `Ctrl+Cmd+K` - New split above
- `Ctrl+Cmd+L` - New split on right

**Resizing** (`Ctrl+Alt+[hjkl]`):
- Resize splits by 10px in each direction

**Other**:
- `Cmd+Alt+Z` - Toggle zoom current pane

### Tabs
- `Cmd+Shift+H` - Previous tab
- `Cmd+Shift+L` - Next tab
- `Cmd+Shift+W` - Close tab

## Installation

Installed via main dotfiles setup:

```bash
stow shared
```

## Dependencies

- **Ghostty** - Terminal emulator (installed separately)
- **GeistMono Nerd Font Mono** - Font with icon support
