# Pass Password Manager - Installation and Usage Guide

## Table of Contents
1. [Installation](#installation)
2. [GPG Key Setup](#gpg-key-setup)
3. [Pass Store Initialization](#pass-store-initialization)
4. [Basic Pass Operations](#basic-pass-operations)
5. [Git Operations](#git-operations)
6. [Reinitialize Pass on a New Machine](#reinitialize-pass-on-a-new-machine-full-walkthrough)
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
sudo dnf install -y pass
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

# Push to remote using https (need sudo dnf install -y gh)
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
# add everything to git
pass git add .

#commit everything with a message
pass git commit -m "your commit message"

# Add remote repository
pass git remote set-url origin https://github.com/username/store.git

# Push to remote
pass git push origin master
```

## Reinitialize Pass on a New Machine (Full Walkthrough)

Tested on Fedora 43. Assumes GPG keys are backed up and password store is on GitHub.

### Step 1: Install pass and GPG

```bash
sudo dnf install -y pass gnupg2 git
```

### Step 2: Set git identity

```bash
git config --global user.name "YOUR_GITHUB_USERNAME"
git config --global user.email "YOUR_EMAIL"
```

### Step 3: Copy GPG key backups to ~/.gnupg

Copy your `private.gpg` and `public.gpg` backup files to `~/.gnupg/`:

```bash
cp /path/to/your/backup/private.gpg ~/.gnupg/
cp /path/to/your/backup/public.gpg ~/.gnupg/
```

### Step 4: Import the private key

```bash
gpg --import ~/.gnupg/private.gpg
```

### Step 5: Get your KEY-ID

```bash
gpg --list-secret-keys --keyid-format long
```

Output example:
```
sec   rsa3072/DE58B476E256C606 2025-10-12 [SC] [expires: 2027-10-12]
      ^^^^^^^^^^^^^^^^^^^^
      This is your KEY-ID (the part after rsa3072/)
```

### Step 6: Trust the key

```bash
gpg --edit-key YOUR_KEY_ID
```

At the `gpg>` prompt:
```
gpg> trust
# Select 5 (ultimate trust)
# Confirm with y
gpg> quit
```

### Step 7: Set up SSH for GitHub (if not done)

```bash
ssh-keygen -t ed25519 -C "YOUR_EMAIL"
cat ~/.ssh/id_ed25519.pub
```

Copy the output, go to **https://github.com/settings/keys**, click **New SSH key**, paste it.

Test with:
```bash
ssh -T git@github.com
```

If SSH doesn't work, you can use HTTPS with a personal access token instead (see Step 8).

### Step 8: Clone password store from GitHub

```bash
# Remove empty/stale password store if it exists
rm -rf ~/.password-store

# Clone via SSH
git clone git@github.com:USERNAME/REPO.git ~/.password-store

# Or clone via HTTPS (will prompt for username + personal access token)
git clone https://github.com/USERNAME/REPO.git ~/.password-store
```

### Step 9: Move GPG backup files out of the store

If you stored your GPG key backups inside the pass repo, move them out **before** running `pass init`. Otherwise pass will try to decrypt them and fail with `decrypt_message failed: Unexpected error`.

```bash
# Check if GPG backups are in the store
ls ~/.password-store/*.gpg

# Move them out if they exist
mv ~/.password-store/public.gpg ~/public-key-backup.gpg
mv ~/.password-store/private.gpg ~/private-key-backup.gpg
```

### Step 10: Initialize pass

```bash
pass init YOUR_KEY_ID
```

### Step 11: Verify

```bash
pass
```

You should see your password tree. Test decryption:

```bash
pass show SOME_ENTRY
```

### Quick Reference (all commands)

```bash
sudo dnf install -y pass gnupg2 git
git config --global user.name "USERNAME"
git config --global user.email "EMAIL"
gpg --import ~/.gnupg/private.gpg
gpg --list-secret-keys --keyid-format long
gpg --edit-key KEY_ID          # trust → 5 → y → quit
rm -rf ~/.password-store
git clone https://github.com/USER/REPO.git ~/.password-store
mv ~/.password-store/public.gpg ~/public-key-backup.gpg 2>/dev/null
mv ~/.password-store/private.gpg ~/private-key-backup.gpg 2>/dev/null
pass init KEY_ID
pass
```

---

## Legacy: Import Keys (Simple)

```bash
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
