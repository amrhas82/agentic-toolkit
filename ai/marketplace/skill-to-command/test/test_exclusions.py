#!/usr/bin/env python3
"""
Test exclusion rules for files and directories.
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter

def test_exclusions():
    """Test that exclusion rules are working."""

    print("TESTING EXCLUSION RULES")
    print("=" * 70)

    converter = SkillConverter()
    skills = converter.discover_skills()

    # Check for excluded patterns
    print("\n1. Checking that excluded files are not included:")

    excluded_patterns = ['LICENSE.txt', 'LICENSE', '.bak', '.tmp']
    found_excluded = []

    for skill_dir in skills:
        files = converter.discover_files(skill_dir)
        all_files = files['markdown'] + files['code'] + files['config'] + files['other']

        for f in all_files:
            filename = f.name.lower()
            for pattern in excluded_patterns:
                if pattern.startswith('.') and filename.endswith(pattern):
                    found_excluded.append((skill_dir.name, f.name))
                elif filename == pattern.lower():
                    found_excluded.append((skill_dir.name, f.name))

    if found_excluded:
        print("   ✗ FAILED - Found excluded files:")
        for skill, fname in found_excluded:
            print(f"     - {skill}/{fname}")
    else:
        print("   ✓ PASSED - No excluded files found")

    # Check for excluded directories
    print("\n2. Checking that files in excluded directories are not included:")

    excluded_dirs = ['scripts', '__pycache__', '.git']
    found_in_excluded = []

    for skill_dir in skills:
        files = converter.discover_files(skill_dir)
        all_files = files['markdown'] + files['code'] + files['config'] + files['other']

        for f in all_files:
            rel_path = f.relative_to(skill_dir)
            for part in rel_path.parts:
                if part.lower() in [d.lower() for d in excluded_dirs]:
                    found_in_excluded.append((skill_dir.name, str(rel_path)))

    if found_in_excluded:
        print("   ✗ FAILED - Found files in excluded directories:")
        for skill, path in found_in_excluded:
            print(f"     - {skill}/{path}")
    else:
        print("   ✓ PASSED - No files from excluded directories found")

    # Check that binary files are excluded
    print("\n3. Checking that binary files are excluded:")

    binary_extensions = ['.pdf', '.jpg', '.jpeg', '.png', '.gif', '.zip', '.exe']
    found_binary = []

    for skill_dir in skills:
        files = converter.discover_files(skill_dir)
        all_files = files['markdown'] + files['code'] + files['config'] + files['other']

        for f in all_files:
            if f.suffix.lower() in binary_extensions:
                found_binary.append((skill_dir.name, f.name))

    if found_binary:
        print("   ✗ FAILED - Found binary files:")
        for skill, fname in found_binary:
            print(f"     - {skill}/{fname}")
    else:
        print("   ✓ PASSED - No binary files found")

    # Check for empty files
    print("\n4. Checking that empty files are excluded:")

    found_empty = []

    for skill_dir in skills:
        files = converter.discover_files(skill_dir)
        all_files = files['markdown'] + files['code'] + files['config'] + files['other']

        for f in all_files:
            if f.stat().st_size == 0:
                found_empty.append((skill_dir.name, f.name))

    if found_empty:
        print("   ⚠ WARNING - Found empty files (may be intentional):")
        for skill, fname in found_empty:
            print(f"     - {skill}/{fname}")
    else:
        print("   ✓ PASSED - No empty files found")

    print("\n" + "=" * 70)
    print("EXCLUSION TESTS COMPLETED")
    print("=" * 70)

if __name__ == "__main__":
    test_exclusions()
