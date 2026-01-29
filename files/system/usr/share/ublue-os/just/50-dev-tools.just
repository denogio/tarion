alias dev := dev-setup

# Install all developer tools via Homebrew
dev-tools: install-brew
    #!/usr/bin/env bash
    set -e

    # Check if brew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing..."
        just install-brew
    fi

    echo "Installing developer tools..."

    # Core tools
    brew install ripgrep fd-find bat eza starship lazygit zoxide

    echo "Developer tools installed!"
    echo "Run 'just dev-setup' to configure them."

# Set up developer environment (configure tools)
dev-setup:
    #!/usr/bin/env bash
    set -e

    # Configure zoxide
    if ! grep -q 'eval "$(zoxide init --cmd cd bash)"' ~/.bashrc 2>/dev/null; then
        echo '' >> ~/.bashrc
        echo '# zoxide' >> ~/.bashrc
        echo 'eval "$(zoxide init --cmd cd bash)"' >> ~/.bashrc
    fi

    # Configure starship
    if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc 2>/dev/null; then
        echo '' >> ~/.bashrc
        echo '# starship prompt' >> ~/.bashrc
        echo 'eval "$(starship init bash)"' >> ~/.bashrc
    fi

    # Create starship config
    mkdir -p ~/.config
    cat > ~/.config/starship.toml << 'EOF'
# Starship config for Tairon
add_newline = false
format = '$directory$git_branch$git_status$character'

[character]
success_symbol = '[➜](bold green)'
error_symbol = '[➜](bold red)'

[directory]
style = 'bold blue'

[git_branch]
style = 'bold purple'

[git_status]
style = 'bold yellow'
EOF

    # Configure bat
    mkdir -p ~/.config/bat
    cat > ~/.config/bat/config << 'EOF'
# Bat config
--theme=base16
--style=numbers,changes
--wrap=never
EOF

    # Configure ripgrep
    mkdir -p ~/.config
    cat > ~/.config/ripgreprc << 'EOF'
# Ripgrep config
--smart-case
--follow
--hidden
--glob=!.git/*
EOF

    echo "Developer environment configured!"
    echo "Open a new terminal for changes to take effect."

# Install Homebrew (alias)
install-brew:
    #!/usr/bin/env bash
    source /usr/lib/ujust/ujust.sh
    if [[ ! -f "/var/home/linuxbrew/.linuxbrew/bin" || ! -x "/var/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        echo "${b}Homebrew Installation${n}"
        echo "Please ${b}IGNORE${n} everything the installer tells you to do at the end"
        echo "We have already done it for you! You just need to close and re-open the terminal after installation"
        echo "Do you understand?"
        echo "Please type in \"YES I UNDERSTAND\" and press enter"
        read ACCEPT
        if [ "$ACCEPT" == "YES I UNDERSTAND" ]; then
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
          echo "Capitalization matters when you type \"YES I UNDERSTAND\""
        fi
    else
        echo "Homebrew is already installed at /var/home/linuxbrew/.linuxbrew"
    fi

# Remove Homebrew
remove-brew:
    echo "Removing homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# Show developer tool versions
dev-info:
    #!/usr/bin/env bash
    echo "Tairon Developer Tools"
    echo "======================"
    echo ""
    echo "Homebrew: $(brew --version 2>/dev/null | head -n1 || echo 'Not installed')"
    echo "ripgrep: $(rg --version 2>/dev/null | head -n1 || echo 'Not installed')"
    echo "fd: $(fd --version 2>/dev/null || echo 'Not installed')"
    echo "bat: $(bat --version 2>/dev/null || echo 'Not installed')"
    echo "eza: $(eza --version 2>/dev/null || echo 'Not installed')"
    echo "starship: $(starship --version 2>/dev/null || echo 'Not installed')"
    echo "lazygit: $(lazygit --version 2>/dev/null || echo 'Not installed')"
    echo "zoxide: $(zoxide --version 2>/dev/null || echo 'Not installed')"

# Update all developer tools
dev-update:
    brew upgrade

# Clean up old developer tool versions
dev-clean:
    brew cleanup

# Create developer-focused project template
dev-new project:
    #!/usr/bin/env bash
    if [ -z "{{project}}" ]; then
        echo "Usage: just dev-new <project-name>"
        exit 1
    fi
    mkdir -p "{{project}}"
    cd "{{project}}"
    # Initialize git
    git init
    # Create README
    echo "# {{project}}" > README.md
    # Create .gitignore
    echo ".git/" > .gitignore
    echo "node_modules/" >> .gitignore
    echo "target/" >> .gitignore
    echo "*.pyc" >> .gitignore
    echo "Project '{{project}}' created!"
