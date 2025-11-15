---
title: Test Scripts Skill
description: A test skill with root-level scripts to verify DIRECTORY_WITH_SCRIPTS mode
---

# Test Scripts Skill

This skill tests the DIRECTORY_WITH_SCRIPTS transformation mode.

## Features

- Root-level executable scripts
- Script paths in markdown that should be updated
- Multiple markdown files that should be merged

## Usage

Run the setup script first:

./setup.sh

Then analyze with:

./analyze.py

Example usage:
```bash
# Setup the environment
./setup.sh --verbose

# Run analysis
./analyze.py --input data.csv
```

The scripts will be relocated to ./test-scripts-skill/ directory.
