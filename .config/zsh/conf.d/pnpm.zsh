# https://pnpm.io/installation

# Export pnpm configuration directory.
export PNPM_HOME="$HOME/.local/share/pnpm"

# Set up shell integration (key bindings and fuzzy completion).
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
