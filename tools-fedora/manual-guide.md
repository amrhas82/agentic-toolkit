# Manual Installation Guide

This guide contains manual installation instructions for tools that are available via the `dev_tools_menu.sh` script but may require additional context.

---

## PyCharm Community Edition

PyCharm is available through option **7** in the `dev_tools_menu.sh` menu.

### Manual Installation Steps

1. **Download PyCharm Community Edition**
   - Visit: https://www.jetbrains.com/pycharm/download/
   - Download the Linux `.tar.gz` file (e.g., `pycharm-2025.3.2.tar.gz`)
   - Save to `~/Downloads/`

2. **Extract the archive**
   ```bash
   cd ~/Downloads
   tar -xzf pycharm-2025.3.2.tar.gz
   ```

   **Important:** A new instance MUST NOT be extracted over an existing one. The target folder must be empty.

3. **Run PyCharm**
   ```bash
   ~/Downloads/pycharm-2025.3.2/bin/pycharm
   ```

### Using the Automated Script

Alternatively, run the `dev_tools_menu.sh` script:
```bash
cd /home/hamr/PycharmProjects/agentic-toolkit/tools-fedora
./dev_tools_menu.sh
```

Select option **7** to install PyCharm Community. The script will:
- Check if the tarball exists in `~/Downloads/`
- Extract PyCharm to `~/Downloads/pycharm-2025.3.2/`
- Create a desktop entry for easy launching
- Display instructions for running PyCharm

---
