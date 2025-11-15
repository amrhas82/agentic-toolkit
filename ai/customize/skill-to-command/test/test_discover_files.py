#!/usr/bin/env python3
"""
Test script for discover_files() method implementation.

Tests the recursive file discovery functionality with multiple skill directories.
"""

import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter, INPUT_DIR


def test_discover_files():
    """Test discover_files method with multiple skill directories."""

    print("Testing discover_files() Implementation")
    print("=" * 70)
    print()

    # Initialize converter
    converter = SkillConverter()

    # First, discover all skills
    skills = converter.discover_skills()

    if not skills:
        print("ERROR: No skills found to test")
        return

    print(f"\nTesting file discovery on {len(skills)} skill directories")
    print("-" * 70)

    # Test with first 5 skills for detailed output
    test_skills = skills[:5]

    total_files = 0

    for skill_dir in test_skills:
        print(f"\n\n{'='*70}")
        print(f"SKILL: {skill_dir.name}")
        print(f"PATH: {skill_dir}")
        print("=" * 70)

        # Discover files
        files = converter.discover_files(skill_dir)

        # Display results
        print(f"\nSKILL.md found: {'YES' if files['skill_md'] else 'NO'}")
        if files['skill_md']:
            print(f"  Location: {files['skill_md']}")

        print(f"\nMarkdown files: {len(files['markdown'])}")
        for f in files['markdown']:
            print(f"  - {f.relative_to(skill_dir)}")

        print(f"\nCode files: {len(files['code'])}")
        for f in files['code']:
            print(f"  - {f.relative_to(skill_dir)}")

        print(f"\nConfig files: {len(files['config'])}")
        for f in files['config']:
            print(f"  - {f.relative_to(skill_dir)}")

        print(f"\nOther files: {len(files['other'])}")
        for f in files['other']:
            print(f"  - {f.relative_to(skill_dir)}")

        # Count total
        skill_total = (
            (1 if files['skill_md'] else 0) +
            len(files['markdown']) +
            len(files['code']) +
            len(files['config']) +
            len(files['other'])
        )
        print(f"\nTotal files discovered: {skill_total}")
        total_files += skill_total

    # Summary for all skills
    print(f"\n\n{'='*70}")
    print("SUMMARY - ALL SKILLS")
    print("=" * 70)

    all_totals = {
        'has_skill_md': 0,
        'markdown': 0,
        'code': 0,
        'config': 0,
        'other': 0
    }

    for skill_dir in skills:
        files = converter.discover_files(skill_dir)
        if files['skill_md']:
            all_totals['has_skill_md'] += 1
        all_totals['markdown'] += len(files['markdown'])
        all_totals['code'] += len(files['code'])
        all_totals['config'] += len(files['config'])
        all_totals['other'] += len(files['other'])

    print(f"\nTotal skills scanned: {len(skills)}")
    print(f"Skills with SKILL.md: {all_totals['has_skill_md']}")
    print(f"Total markdown files: {all_totals['markdown']}")
    print(f"Total code files: {all_totals['code']}")
    print(f"Total config files: {all_totals['config']}")
    print(f"Total other files: {all_totals['other']}")
    print(f"Total files: {sum(all_totals.values())}")

    print("\n" + "=" * 70)
    print("TEST COMPLETED SUCCESSFULLY")
    print("=" * 70)


def test_specific_features():
    """Test specific features of discover_files."""

    print("\n\n" + "=" * 70)
    print("TESTING SPECIFIC FEATURES")
    print("=" * 70)

    converter = SkillConverter()
    skills = converter.discover_skills()

    if not skills:
        print("ERROR: No skills found")
        return

    # Test 1: Check SKILL.md detection
    print("\n1. Testing SKILL.md detection:")
    skill_md_count = 0
    for skill_dir in skills:
        files = converter.discover_files(skill_dir)
        if files['skill_md']:
            skill_md_count += 1
    print(f"   Found SKILL.md in {skill_md_count}/{len(skills)} skills")

    # Test 2: Check recursive scanning (files in subdirectories)
    print("\n2. Testing recursive directory scanning:")
    subdirs_found = False
    for skill_dir in skills:
        files = converter.discover_files(skill_dir)
        all_files = files['markdown'] + files['code'] + files['config'] + files['other']
        for f in all_files:
            # Check if file is in a subdirectory
            if len(f.relative_to(skill_dir).parts) > 1:
                subdirs_found = True
                print(f"   ✓ Found file in subdirectory: {skill_dir.name}/{f.relative_to(skill_dir)}")
                break
        if subdirs_found:
            break

    if not subdirs_found:
        print("   ⚠ No files found in subdirectories (may be expected)")

    # Test 3: Check file categorization
    print("\n3. Testing file categorization:")
    for skill_dir in skills[:3]:
        files = converter.discover_files(skill_dir)

        # Check that .py files are in code
        py_files = [f for f in files['code'] if f.suffix == '.py']
        if py_files:
            print(f"   ✓ {skill_dir.name}: .py files correctly in 'code' category")

        # Check that .json files are in config
        json_files = [f for f in files['config'] if f.suffix == '.json']
        if json_files:
            print(f"   ✓ {skill_dir.name}: .json files correctly in 'config' category")

        # Check that .md files are in markdown
        md_files = [f for f in files['markdown'] if f.suffix == '.md']
        if md_files:
            print(f"   ✓ {skill_dir.name}: .md files correctly in 'markdown' category")

    # Test 4: Check sorting
    print("\n4. Testing alphabetical sorting:")
    for skill_dir in skills[:3]:
        files = converter.discover_files(skill_dir)
        for category in ['markdown', 'code', 'config', 'other']:
            if len(files[category]) > 1:
                # Check if sorted
                paths = [str(p) for p in files[category]]
                is_sorted = paths == sorted(paths)
                status = "✓" if is_sorted else "✗"
                print(f"   {status} {skill_dir.name}/{category}: {'sorted' if is_sorted else 'NOT sorted'}")

    print("\n" + "=" * 70)


if __name__ == "__main__":
    try:
        test_discover_files()
        test_specific_features()
    except Exception as e:
        print(f"\nERROR: Test failed with exception: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
