# Tairon Troubleshooting

## Installation Issues

### Rebase Fails
```bash
# Check for conflicts
rpm-ostree status

# Force rebase (be careful!)
rpm-ostree rebase --force ostree-unverified-registry:ghcr.io/denogio/tairon:latest
```

### Image Not Found
- Check internet connection
- Verify registry URL: `ghcr.io/denogio/tairon`
- Check if image exists on GitHub packages

## Boot Issues

### Stuck on Boot
```bash
# Boot to previous deployment
# In GRUB menu, select previous version
```

### Black Screen
```bash
# Check logs
journalctl -b -1 -xe

# Try different display mode
# Add to kernel params: nomodeset
```

## Desktop Issues

### Hyprland Won't Start
```bash
# Check config
hyprctl check ~/.config/hypr/hyprland.conf

# Check logs
cat ~/.local/share/hyprland/hyprland.log
```

### Waybar Missing
```bash
# Restart Waybar
systemctl --user restart waybar

# Check logs
journalctl --user -xe -u waybar
```

### Vicinae Not Responding
```bash
# Restart Vicinae
systemctl --user restart vicinae

# Check logs
journalctl --user -xe -u vicinae
```

## Application Issues

### Ghostty Won't Start
```bash
# Check config
ghostty --config-dir

# Reset config
mv ~/.config/ghostty ~/.config/ghostty.backup
```

### Flatpak Apps Not Working
```bash
# Update Flatpaks
flatpak update

# Reinstall Flatpak
flatpak uninstall com.example.App
flatpak install flathub com.example.App
```

## Developer Tools

### Homebrew Issues
```bash
# Check brew status
brew doctor

# Reinstall brew
rm -rf /var/home/linuxbrew/.linuxbrew
just install-brew
```

### Neovim Plugins Not Loading
```bash
# Update plugins
nvim +:PackerSync +:qa

# Clean plugins
rm -rf ~/.local/share/nvim/site/pack/
nvim +:PackerInstall +:qa
```

### Starship Prompt Not Showing
```bash
# Verify installation
which starship

# Reconfigure
eval "$(starship init bash)"
```

## Network Issues

### WiFi Not Working
```bash
# Check connection
nmcli connection show

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Use iwd (if configured)
iwctl
```

### Bluetooth Not Working
```bash
# Check status
bluetoothctl show

# Restart Bluetooth
sudo systemctl restart bluetooth

# Check with Vicinae
# SUPER+SHIFT+R → Bluetooth Toggle
```

## Performance Issues

### High Memory Usage
```bash
# Check what's using memory
free -h
ps aux --sort=-%mem | head -10

# Restart heavy apps
```

### High CPU Usage
```bash
# Check what's using CPU
top

# Check Wayland compositor
systemctl --user status hyprland
```

### Slow Boot
```bash
# Check boot time
systemd-analyze

# Check services
systemd-analyze blame | head -20

# Disable slow services
systemctl --user disable slow-service
```

## Update Issues

### Update Fails
```bash
# Check status
rpm-ostree status

# Check for conflicts
rpm-ostree upgrade --check

# Try again
rpm-ostree upgrade --preview
```

### Rollback
```bash
# Rollback to previous deployment
rpm-ostree rollback
systemctl reboot
```

## Getting Help

### Check Logs
```bash
# System logs
journalctl -xe

# User session logs
journalctl --user -xe

# Hyprland logs
cat ~/.local/share/hyprland/hyprland.log

# Waybar logs
journalctl --user -xe -u waybar
```

### Get System Info
```bash
# OS info
rpm-ostree status

# Hardware info
inxi -Fazy
lspci
lsusb
```

### Report Issues

When reporting issues, include:
1. `rpm-ostree status` output
2. Relevant log files
3. Steps to reproduce
4. Hardware info (if relevant)

Report at: https://github.com/denogio/tairon/issues
