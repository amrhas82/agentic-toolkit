# The Ultimate Git Guide

## Table of Contents
1. [Git Basics](#git-basics)
2. [Repository Management](#repository-management)
3. [Branching and Merging](#branching-and-merging)
4. [Committing Changes](#committing-changes)
5. [Remote Operations](#remote-operations)
6. [History and Logging](#history-and-logging)
7. [Undoing Changes](#undoing-changes)
8. [Stashing](#stashing)
9. [Tagging](#tagging)
10. [Advanced Operations](#advanced-operations)
11. [Git Configuration](#git-configuration)
12. [Git Hooks](#git-hooks)
13. [Git Workflows](#git-workflows)
14. [Troubleshooting](#troubleshooting)
15. [Best Practices](#best-practices)

## Git Basics

### Installation
```bash
# Ubuntu/Debian
sudo dnf install -y git

# macOS (with Homebrew)
brew install git

# Windows
# Download from https://git-scm.com/download/win
```

### Initial Setup
```bash
# Configure user information
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Set default editor
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "vim"          # Vim
git config --global core.editor "nano"         # Nano

# Check configuration
git config --list
git config --global --list
```

### Basic Commands
```bash
# Check Git version
git --version

# Get help
git help
git help <command>

# Check status
git status

# Initialize a repository
git init

# Clone a repository
git clone <repository-url>
git clone <repository-url> <directory-name>
```

## Repository Management

### Initialize Repository
```bash
# Initialize in current directory
git init

# Initialize in specific directory
git init <directory-name>

# Initialize with specific branch name
git init -b main
```

### Clone Repository
```bash
# Clone with default branch
git clone https://github.com/username/repository.git

# Clone specific branch
git clone -b branch-name https://github.com/username/repository.git

# Clone shallow (only recent history)
git clone --depth 1 https://github.com/username/repository.git

# Clone with specific directory name
git clone https://github.com/username/repository.git my-project
```

### Remote Management
```bash
# List remotes
git remote
git remote -v

# Add remote
git remote add origin https://github.com/username/repository.git
git remote add upstream https://github.com/original/repository.git

# Change remote URL
git remote set-url origin https://github.com/username/new-repository.git

# Remove remote
git remote remove origin

# Rename remote
git remote rename old-name new-name

# Show remote details
git remote show origin
```

## Branching and Merging

### Branch Operations
```bash
# List branches
git branch                    # Local branches
git branch -r                 # Remote branches
git branch -a                 # All branches

# Create branch
git branch branch-name
git branch -b branch-name     # Create and switch

# Switch branch
git checkout branch-name
git switch branch-name        # Modern alternative

# Create and switch to new branch
git checkout -b new-branch
git switch -c new-branch      # Modern alternative

# Delete branch
git branch -d branch-name     # Safe delete
git branch -D branch-name     # Force delete

# Delete remote branch
git push origin --delete branch-name

# Rename branch
git branch -m old-name new-name
git branch -m new-name        # Rename current branch
```

### Merging
```bash
# Merge branch into current branch
git merge branch-name

# Merge with no fast-forward
git merge --no-ff branch-name

# Merge with squash (combine commits)
git merge --squash branch-name

# Abort merge
git merge --abort

# Continue merge after resolving conflicts
git merge --continue
```

### Rebasing
```bash
# Rebase current branch onto another
git rebase main

# Interactive rebase
git rebase -i HEAD~3

# Rebase onto remote branch
git rebase origin/main

# Abort rebase
git rebase --abort

# Continue rebase after resolving conflicts
git rebase --continue

# Skip current commit during rebase
git rebase --skip
```

## Committing Changes

### Staging Changes
```bash
# Add specific file
git add filename.txt

# Add all files
git add .

# Add all files in directory
git add directory/

# Add all tracked files
git add -u

# Add all files (including untracked)
git add -A

# Interactive add
git add -i

# Patch mode (select parts of files)
git add -p

# Remove from staging
git reset filename.txt
git reset HEAD filename.txt
```

### Committing
```bash
# Commit with message
git commit -m "Your commit message"

# Commit all staged changes
git commit -am "Your commit message"

# Amend last commit
git commit --amend

# Amend with new message
git commit --amend -m "New commit message"

# Amend and add more changes
git add forgotten-file.txt
git commit --amend --no-edit

# Empty commit
git commit --allow-empty -m "Empty commit"
```

### Commit Messages
```bash
# Good commit message format:
# <type>(<scope>): <subject>
# 
# <body>
# 
# <footer>

# Examples:
git commit -m "feat(auth): add user authentication"
git commit -m "fix(api): resolve timeout issue in user endpoint"
git commit -m "docs(readme): update installation instructions"
git commit -m "refactor(utils): simplify date formatting function"
```

## Remote Operations

### Push Operations
```bash
# Push to remote
git push origin main

# Push and set upstream
git push -u origin main

# Push all branches
git push --all origin

# Push tags
git push --tags

# Force push (use with caution)
git push --force origin main
git push --force-with-lease origin main  # Safer force push

# Push specific branch
git push origin feature-branch
```

### Pull Operations
```bash
# Pull changes
git pull origin main

# Pull and rebase
git pull --rebase origin main

# Pull all branches
git pull --all

# Fetch without merging
git fetch origin

# Fetch specific branch
git fetch origin branch-name
```

### Fetch Operations
```bash
# Fetch all remotes
git fetch

# Fetch specific remote
git fetch origin

# Fetch specific branch
git fetch origin main

# Fetch all remotes and branches
git fetch --all

# Prune deleted remote branches
git fetch --prune
```

## History and Logging

### View History
```bash
# Basic log
git log

# One line per commit
git log --oneline

# Graph view
git log --graph --oneline --all

# Show changes
git log -p

# Show specific file history
git log -- filename.txt

# Show commits by author
git log --author="John Doe"

# Show commits by date
git log --since="2023-01-01"
git log --until="2023-12-31"
git log --since="2 weeks ago"

# Show commits with specific message
git log --grep="bug fix"

# Show merge commits only
git log --merges

# Show non-merge commits only
git log --no-merges
```

### Show Changes
```bash
# Show changes in working directory
git diff

# Show staged changes
git diff --staged
git diff --cached

# Show changes between commits
git diff commit1 commit2

# Show changes in specific file
git diff HEAD~1 filename.txt

# Show word-level diff
git diff --word-diff

# Show changes with context
git diff -U5
```

### Blame and Show
```bash
# Show who changed each line
git blame filename.txt

# Show specific commit
git show commit-hash

# Show last commit
git show HEAD

# Show changes in commit
git show --stat commit-hash
```

## Undoing Changes

### Reset Operations
```bash
# Reset working directory (keep staged changes)
git reset --mixed HEAD

# Reset staging area only
git reset HEAD filename.txt

# Reset to specific commit (keep changes)
git reset --soft commit-hash

# Reset to specific commit (discard changes)
git reset --hard commit-hash

# Reset to remote state
git reset --hard origin/main
```

### Revert Operations
```bash
# Revert specific commit
git revert commit-hash

# Revert without creating commit
git revert --no-commit commit-hash

# Revert merge commit
git revert -m 1 merge-commit-hash
```

### Checkout Operations
```bash
# Discard changes in working directory
git checkout -- filename.txt

# Discard all changes
git checkout -- .

# Switch to specific commit (detached HEAD)
git checkout commit-hash

# Create branch from specific commit
git checkout -b new-branch commit-hash
```

## Stashing

### Basic Stash Operations
```bash
# Stash changes
git stash

# Stash with message
git stash push -m "Work in progress"

# List stashes
git stash list

# Apply stash
git stash apply
git stash apply stash@{0}

# Pop stash (apply and remove)
git stash pop
git stash pop stash@{0}

# Show stash contents
git stash show
git stash show -p stash@{0}

# Drop stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

### Advanced Stash Operations
```bash
# Stash specific files
git stash push -m "Partial work" file1.txt file2.txt

# Stash including untracked files
git stash -u

# Stash including ignored files
git stash -a

# Create branch from stash
git stash branch new-branch stash@{0}
```

## Tagging

### Create Tags
```bash
# Create lightweight tag
git tag v1.0.0

# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag specific commit
git tag v1.0.0 commit-hash

# Create tag with message
git tag -a v1.0.0 -m "Version 1.0.0 release"
```

### Tag Operations
```bash
# List tags
git tag
git tag -l "v1.*"

# Show tag details
git show v1.0.0

# Delete tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0

# Push tags
git push origin v1.0.0
git push origin --tags
```

## Advanced Operations

### Submodules
```bash
# Add submodule
git submodule add https://github.com/user/repo.git path/to/submodule

# Initialize submodules
git submodule init

# Update submodules
git submodule update
git submodule update --init --recursive

# Clone with submodules
git clone --recursive https://github.com/user/repo.git
```

### Cherry-picking
```bash
# Cherry-pick specific commit
git cherry-pick commit-hash

# Cherry-pick range
git cherry-pick commit1..commit2

# Cherry-pick without committing
git cherry-pick --no-commit commit-hash
```

### Bisect
```bash
# Start bisect
git bisect start

# Mark commit as bad
git bisect bad commit-hash

# Mark commit as good
git bisect good commit-hash

# Mark current commit as good/bad
git bisect good
git bisect bad

# Reset bisect
git bisect reset
```

### Clean
```bash
# Show what would be cleaned
git clean -n

# Remove untracked files
git clean -f

# Remove untracked files and directories
git clean -fd

# Remove ignored files
git clean -X
```

## Git Configuration

### Global Configuration
```bash
# Set user name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch
git config --global init.defaultBranch main

# Set default editor
git config --global core.editor "code --wait"

# Set default merge tool
git config --global merge.tool vimdiff

# Set line ending handling
git config --global core.autocrlf true  # Windows
git config --global core.autocrlf input # macOS/Linux

# Set credential helper
git config --global credential.helper store
```

### Repository Configuration
```bash
# Set configuration for current repository
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Set remote URL
git config remote.origin.url https://github.com/user/repo.git

# Set push default
git config push.default simple
```

### Useful Configurations
```bash
# Colorize output
git config --global color.ui auto

# Set aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'

# Set pull strategy
git config --global pull.rebase false  # merge
git config --global pull.rebase true   # rebase

# Set push strategy
git config --global push.default simple

# Set diff tool
git config --global diff.tool vimdiff
git config --global difftool.prompt false

# Set merge tool
git config --global merge.tool vimdiff
git config --global mergetool.prompt false
```

## Git Hooks

### Pre-commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit
echo "Running pre-commit checks..."
npm test
if [ $? -ne 0 ]; then
    echo "Tests failed. Commit aborted."
    exit 1
fi
```

### Post-commit Hook
```bash
#!/bin/sh
# .git/hooks/post-commit
echo "Commit successful!"
# Add any post-commit actions here
```

### Pre-push Hook
```bash
#!/bin/sh
# .git/hooks/pre-push
echo "Running pre-push checks..."
npm run lint
if [ $? -ne 0 ]; then
    echo "Linting failed. Push aborted."
    exit 1
fi
```

## Git Workflows

### Feature Branch Workflow
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push feature branch
git push -u origin feature/new-feature

# Create pull request (via GitHub/GitLab UI)

# After approval, merge to main
git checkout main
git pull origin main
git merge feature/new-feature
git push origin main

# Delete feature branch
git branch -d feature/new-feature
git push origin --delete feature/new-feature
```

### Git Flow Workflow
```bash
# Initialize git flow
git flow init

# Start feature
git flow feature start new-feature

# Finish feature
git flow feature finish new-feature

# Start release
git flow release start 1.0.0

# Finish release
git flow release finish 1.0.0

# Start hotfix
git flow hotfix start hotfix-1.0.1

# Finish hotfix
git flow hotfix finish hotfix-1.0.1
```

## Troubleshooting

### Common Issues

#### Merge Conflicts
```bash
# Check status
git status

# Edit conflicted files
# Look for <<<<<<< ======= >>>>>>> markers

# After resolving conflicts
git add resolved-file.txt
git commit -m "Resolve merge conflict"
```

#### Detached HEAD
```bash
# Check current state
git log --oneline -5

# Create branch from current position
git checkout -b new-branch

# Or return to main branch
git checkout main
```

#### Lost Commits
```bash
# Find lost commits
git reflog

# Recover lost commit
git checkout commit-hash
git checkout -b recovery-branch
```

#### Large Files
```bash
# Remove large file from history
git filter-branch --tree-filter 'rm -f large-file.txt' HEAD

# Use BFG Repo-Cleaner (recommended)
# Download from https://rtyley.github.io/bfg-repo-cleaner/
java -jar bfg.jar --delete-files large-file.txt your-repo.git
```

### Useful Commands
```bash
# Check repository health
git fsck

# Verify repository integrity
git fsck --full

# Clean up repository
git gc
git gc --aggressive

# Show repository size
du -sh .git

# Show largest files
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort --numeric-sort --key=2 | tail -10
```

## Best Practices

### Commit Best Practices
1. **Write clear, descriptive commit messages**
2. **Make small, focused commits**
3. **Use conventional commit format**
4. **Test before committing**
5. **Don't commit sensitive information**

### Branch Best Practices
1. **Use meaningful branch names**
2. **Keep branches up to date**
3. **Delete merged branches**
4. **Use feature branches for new work**
5. **Protect main branch**

### Repository Best Practices
1. **Use .gitignore effectively**
2. **Keep repository size reasonable**
3. **Use meaningful README files**
4. **Document your code**
5. **Use semantic versioning for tags**

### Security Best Practices
1. **Never commit passwords or API keys**
2. **Use SSH keys for authentication**
3. **Sign your commits**
4. **Review changes before merging**
5. **Use branch protection rules**

### Performance Best Practices
1. **Use shallow clones when possible**
2. **Clean up old branches**
3. **Use .gitignore to exclude unnecessary files**
4. **Compress repository regularly**
5. **Use sparse checkout for large repositories**

---

## Quick Reference

### Most Used Commands
```bash
git status                    # Check status
git add .                     # Stage all changes
git commit -m "message"       # Commit changes
git push                      # Push to remote
git pull                      # Pull from remote
git log --oneline            # View commit history
git branch                   # List branches
git checkout branch-name     # Switch branch
git merge branch-name        # Merge branch
git stash                    # Stash changes
git stash pop               # Apply stash
```

### Emergency Commands
```bash
git reset --hard HEAD        # Discard all changes
git checkout -- filename     # Discard file changes
git clean -fd               # Remove untracked files
git revert HEAD             # Undo last commit
git reset --soft HEAD~1     # Undo last commit, keep changes
```

This guide covers the essential Git commands and workflows you'll need for effective version control. Remember to practice these commands in a safe environment and always backup important work before experimenting with advanced Git operations.