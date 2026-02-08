# Contributing to Tarion

Thank you for your interest in contributing to Tarion!

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

When creating bug reports, include:
- Clear title and description
- Steps to reproduce
- Expected behavior
- Actual behavior
- System information (`rpm-ostree status`)
- Relevant logs

### Suggesting Enhancements

Enhancement suggestions are welcome! Please:
- Use clear and descriptive titles
- Provide detailed explanation of enhancement
- Explain why it would be useful to Tarion users

### Pull Requests

1. Fork the repository
2. Create a branch for your feature: `git checkout -b feature/your-feature`
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages
6. Push to your fork
7. Create a pull request

## Development Workflow

### Setting Up Development Environment

```bash
# Clone repository
git clone https://github.com/denogio/tarion.git
cd tarion

# Install blue-build
pip install blue-build

# Build image locally for testing
blue-build build recipes/recipe.yml
```

### Code Style

- YAML files: 2 spaces indentation
- Bash scripts: Use `set -euo pipefail` at top
- Follow existing conventions in the codebase

### Testing

Before submitting PR:
- Test local build: `blue-build build recipes/recipe.yml`
- Check syntax: `python3 -c "import yaml; yaml.safe_load(open('recipes/recipe.yml'))"`
- Check scripts: `shellcheck files/scripts/*.sh`

### Commit Messages

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

Example:
```
feat: add new Vicinae dmenu script for system controls

- Add power management controls
- Add display settings controls
- Add network controls
```

## Areas of Contribution

### Configuration
- Improve default configurations
- Add new themes
- Enhance desktop polish

### Documentation
- Improve existing docs
- Add tutorials
- Create examples

### Scripts
- Improve setup scripts
- Add utility scripts
- Fix bugs in scripts

### Packages
- Add useful packages
- Remove deprecated packages
- Optimize package selections

## Getting Help

- GitHub Discussions: https://github.com/denogio/tarion/discussions
- GitHub Issues: https://github.com/denogio/tarion/issues

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (Apache License 2.0).
