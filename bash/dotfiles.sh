# Aliases and functions
alias k='kubectl'

# Forward tofu output as is (env var instead of flag, so non-run commands like --version keep working)
tg() {
    TG_TF_FORWARD_STDOUT=true terragrunt "$@"
}

# Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
