# Pass Password Manager - Installation and Usage Guide

## Table of Contents
1. [Installation](#installation)
2. [GPG Key Setup](#gpg-key-setup)
3. [Pass Store Initialization](#pass-store-initialization)
4. [Basic Pass Operations](#basic-pass-operations)
5. [Git Operations](#git-operations)
6. [Setting Up on New Machine](#setting-up-on-new-machine)
7. [Using Pass in Scripts](#using-pass-in-scripts)
8. [Directory Structure](#directory-structure)
9. [Best Practices](#best-practices)
10. [Troubleshooting](#troubleshooting)
11. [Security Notes](#security-notes)
12. [Youtube Tutorial](https://youtu.be/FhwsfH2TpFA?si=p0oIKE-UipAupgGA)

## Installation

### Install Pass
```bash
# Install password manager with git option
sudo apt install pass
```

## GPG Key Setup

### Generate GPG Key
```bash
# Generate a new GPG key
gpg --gen-key
```

### Display Keys
```bash
# Display all keys
gpg -K
```

### Set Key to Not Expire
```bash
# Edit key settings
gpg --edit-key xxxxxxx
gpg> expire
# Follow prompts to set no expiration
gpg> quit
```

### Create Backup Keys
```bash
# Create public key for recovery
gpg --output public.gpg --armor --export your-email@example.com

# Create private key for recovery
gpg --output private.gpg --armor --export-secret-key your-email@example.com
```

### Set Key Trust Level
```bash
# Edit key to set trust level
gpg --edit-key your-email@example.com
gpg> trust
# Select option 5 (ultimate trust)
gpg> quit
```

## Pass Store Initialization

### Initialize Pass Store
```bash
# Initialize pass store using your GPG key ID
pass init your-gpg-key-id
```

### Initialize Git Repository
```bash
# Initialize git repository for pass store
pass git init your-gpg-key-id
# Or simply
pass git init
```

## Basic Pass Operations

### Generate Passwords
```bash
# Generate a password under specific directory
pass generate for/provider
```

### Find Passwords
```bash
# Find passwords by name
pass find
```

### Edit Passwords
```bash
# Edit a password entry
pass edit for/provider
```

### Search Passwords
```bash
# Search for specific content
pass grep "info@email.com"
pass grep "email:"
```

### Display Passwords
```bash
# Display password on screen
pass show for/provider

# Copy password to clipboard
pass show -c for/provider
```

### Remove Passwords
```bash
# Remove a password entry
pass rm for/provider
```

### Locate GPG Keys
```bash
# Navigate to GPG directory
cd ~/.gnupg
ls
```

## Git Operations

### Check Git Status
```bash
# Check commit log
pass git log

# Check all branches
pass git branch -a

# Check git status
pass git status
```

### Revert Changes
```bash
# Revert last git change
pass git revert HEAD
```

### Create Initial Commit
```bash
# Locate pass directory
cd ~/.password-store

# Initialize repo
pass git init

# Add files (be careful with 'pass git add .' - might include GPG keys)
pass git add *.gpg
# OR be more specific:
find . -name "*.gpg" -type f | xargs pass git add

# Push to remote using https (need sudo apt install gh)
gh auth login
pass git remote set-url origin https://github.com/username/pwd.git

# Commit
pass git commit -m "Initial password store commit"

# Push (no need for 'gh auth login' if using HTTPS)
pass git push -u origin master
```

### Creating and Using a New Branch
```bash
# Create and switch to new branch
pass git checkout -b new-branch-name

# Or create branch then switch to it
pass git branch new-branch-name
pass git checkout new-branch-name

# Add, commit, and push to the new branch
pass git add *.gpg
pass git commit -m "Commit on new branch"
pass git push -u origin new-branch-name
```

### Complete Branch Workflow Example
```bash
cd ~/.password-store

# Create feature branch for new passwords
pass git checkout -b add-work-passwords

# Add new passwords
pass insert work/email
pass insert work/vpn

# Commit the new passwords
pass git add .
pass git commit -m "Add work-related passwords"

# Push to the new branch
pass git push -u origin add-work-passwords

# Later, merge to main if desired
pass git checkout master
pass git merge add-work-passwords
pass git push origin master
```

### Rename Branch to Main
```bash
cd ~/.password-store
git branch -M main
pass git push -u origin main
```

### Push to Remote Repository
```bash
# Add remote repository
pass git remote set-url origin https://github.com/username/store.git

# Push to remote
pass git push origin master
```

## Setting Up on New Machine

### Import Keys
```bash
# Navigate to exported keys directory
cd exported-keys

# Import private key
gpg --import private.gpg

# Import public key
gpg --import public.gpg
```

### Test Access
```bash
# Test password access
pass show for/provider
```

## Using Pass in Scripts

### Export Passwords to Environment Variables
```bash
# Use pass to set environment variables
export GITHUB_TOKEN=$(pass show for/provider)
echo $GITHUB_TOKEN
```

## Directory Structure

Pass organizes passwords in a hierarchical structure:
```
pass/
├── for/
│   ├── provider/
│   │   └── password.gpg
│   └── provider2/
│       └── password.gpg
└── for2/
    └── provider/
        └── password.gpg
```

## Best Practices

1. **Regular Backups**: Always keep your GPG keys backed up securely
2. **Git Integration**: Use git to track changes and sync across devices
3. **Strong Passwords**: Use `pass generate` for strong, unique passwords
4. **Organize Structure**: Use meaningful directory structures (e.g., `work/github`, `personal/email`)
5. **Environment Variables**: Use pass to securely manage API keys and tokens in scripts

## Troubleshooting

### Common Issues
- **GPG Key Issues**: Ensure your GPG key is properly imported and trusted
- **Git Sync Issues**: Check your git remote configuration and authentication
- **Permission Issues**: Ensure proper file permissions on the pass store directory

### Useful Commands
```bash
# Check pass store status
pass ls

# Check git status
pass git status

# List all entries recursively
pass ls -R
```

## Security Notes

- Never commit your private GPG key to version control
- Store backup keys in a secure location
- Use strong passphrases for your GPG keys
- Regularly update your GPG keys and pass installation
