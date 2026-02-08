alias tarion := tarion-menu

# Open the Tarion main menu
tarion-menu:
    tarion-menu

# Tarion system scripts - Essential utilities for Tarion
# All scripts are installed to ~/.local/bin on first boot via tarion-install-scripts

# Show all available Tarion commands
list:
    #!/usr/bin/env bash
    echo "Tarion System Scripts"
    echo "====================="
    echo ""
    echo "Menu & Navigation:"
    echo "  tarion-menu              - Main menu system"
    echo ""
    echo "Window Management:"
    echo "  tarion-hyprland-window-close-all  - Close all windows"
    echo "  tarion-hyprland-window-pop         - Pop window to top"
    echo ""
    echo "Theme & Appearance:"
    echo "  tarion-theme-set-browser     - Set browser theme"
    echo "  tarion-show-logo            - Show Tarion logo"
    echo ""
    echo "System & Utilities:"
    echo "  tarion-battery-monitor     - Battery monitor"
    echo "  tarion-battery-remaining    - Battery remaining"
    echo "  tarion-audio-switch        - Audio output switch"
    echo "  tarion-screenshot          - Take screenshots"
    echo "  tarion-pkg-remove         - Remove packages"
    echo "  tarion-pkg-present         - Check package presence"
    echo ""
    echo "Update & Maintenance:"
    echo "  tarion-update-scripts      - Update all Tarion scripts"
    echo "  tarion-install-scripts     - Install Tarion scripts"
    echo ""

# Update Tarion scripts from system
update-scripts:
    tarion-update-scripts

# Tarion First Boot Setup
setup:
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Check if setup has been run before
    if [ -f "$HOME/.config/tarion/setup-done" ]; then
        if ! ugum confirm "Setup has already been completed. Re-run setup?" --default=false; then
            exit 0
        fi
    fi

    ugum style --foreground 212 --border double --align center --margin "1 2" "Welcome to Tarion Setup"

    # Step 1: Developer tools (delegate to ujust dev-tools if available)
    if ugum confirm "Install developer tools?" --default=true; then
        if ujust --list | grep -q "dev-tools"; then
            ujust dev-tools
            ujust dev-setup
        else
            echo "dev-tools recipe not found. Skipping."
        fi
    fi

    # Step 2: Git configuration
    if ugum confirm "Configure Git?" --default=true; then
        git_user=$(ugum input --placeholder "Your Git username" --value "$USER")
        git_email=$(ugum input --placeholder "Your Git email" --prompt "Email: ")
        git config --global user.name "$git_user"
        git config --global user.email "$git_email"
        ugum style --foreground 46 "✓ Git configured"
    fi

    # Step 3: SSH keys
    if ugum confirm "Generate SSH keys?" --default=false; then
        git_email=$(git config --global user.email)
        [ -z "$git_email" ] && git_email=$(ugum input --placeholder "Email for SSH keys")
        ssh-keygen -t ed25519 -C "$git_email"
        ugum style --foreground 46 "✓ SSH keys generated"
    fi

    # Step 4: Default Theme
    if ugum confirm "Set default theme (Catppuccin Mocha)?" --default=true; then
        ujust theme select catppuccin-mocha
    fi

    # Mark setup as complete
    mkdir -p "$HOME/.config/tarion"
    touch "$HOME/.config/tarion/setup-done"
    ugum style --foreground 46 "✓ Tarion Setup Complete!"



# Theme Management
theme action="":
    #!/usr/bin/env bash
    if [ -z "{{action}}" ]; then
        # If no action, show menu
        ACTION=$(ugum choose "select" "gui")
    else
        ACTION="{{action}}"
    fi

    if [ "$ACTION" == "select" ]; then
        # Logic to select theme
        current=$(readlink -f $HOME/.config/tarion/current/theme | xargs basename)
        themes_dir="/usr/share/tarion/themes"
        user_themes_dir="$HOME/.config/tarion/themes"
        
        # Combine themes
        themes=$(ls "$themes_dir" 2>/dev/null)
        if [ -d "$user_themes_dir" ]; then
            themes="$themes\n$(ls "$user_themes_dir")"
        fi
        
        # Deduplicate and sort
        selected=$(echo -e "$themes" | sort -u | ugum filter --placeholder "Select theme..." --header "Current: $current")
        
        if [ -n "$selected" ]; then
            # Call tarion-theme-set (or implement logic here directly if we delete script)
            # Since we plan to delete the script, I'll inline the logic later or assume script exists for now.
            # BUT user wanted to migrate scripts. So I should probably inline the KEY logic or call a helper.
            # For now, let's assume I'm porting the logic INTO this recipe completely in next step if checking fails.
            # Actually, let's try to run tarion-theme-set if it exists, else use inline logic.
            # But wait, I'm supposed to DELETE tarion-theme-set. So I must inline it.
            
            # Inline Theme Set Logic
            THEME_NAME="$selected"
            if [ -d "$user_themes_dir/$THEME_NAME" ]; then
                THEME_PATH="$user_themes_dir/$THEME_NAME"
            elif [ -d "$themes_dir/$THEME_NAME" ]; then
                THEME_PATH="$themes_dir/$THEME_NAME"
            else
                echo "Theme not found"
                exit 1
            fi
            
            NEXT="$HOME/.config/tarion/current/next-theme"
            CURRENT="$HOME/.config/tarion/current/theme"
            rm -rf "$NEXT" && mkdir -p "$NEXT"
            cp -r "$THEME_PATH/"* "$NEXT/"
            rm -rf "$CURRENT" && mv "$NEXT" "$CURRENT"
            echo "$THEME_NAME" > "$HOME/.config/tarion/current/theme.name"
            
            # Reload components
            if pgrep -x waybar >/dev/null; then systemctl --user restart waybar; fi
            
            # App themes
            for setter in tarion-theme-set-*; do
                if command -v "$setter" &>/dev/null; then "$setter"; fi
            done
            
            gum style --foreground 46 "Theme applied: $THEME_NAME"
        fi
        
    elif [ "$ACTION" == "gui" ]; then
        ujust theme select
    fi
