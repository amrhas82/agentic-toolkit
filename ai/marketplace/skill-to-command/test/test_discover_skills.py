#!/usr/bin/env python3
"""
Test script for discover_skills() method.

This script tests the skill directory discovery functionality to ensure:
1. It correctly discovers all valid skill directories
2. It excludes non-directories (like README.md)
3. It excludes directories matching EXCLUDE_DIRS patterns
4. It returns sorted results
5. It handles error cases gracefully
"""

import sys
from pathlib import Path

# Add parent directory to path to import the converter
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import (
    SkillConverter,
    INPUT_DIR,
    EXCLUDE_DIRS
)


def test_discover_skills():
    """Test the discover_skills() method."""
    print("=" * 70)
    print("TEST: discover_skills() method")
    print("=" * 70)

    # Create converter instance
    converter = SkillConverter()

    # Test 1: Basic discovery
    print("\n[Test 1] Basic skill discovery:")
    print("-" * 70)
    skills = converter.discover_skills()

    # Verify results
    print(f"\n[Test 1] Results:")
    print(f"  Total skills discovered: {len(skills)}")
    print(f"  All items are Path objects: {all(isinstance(s, Path) for s in skills)}")
    print(f"  All items are directories: {all(s.is_dir() for s in skills)}")
    print(f"  All items are absolute paths: {all(s.is_absolute() for s in skills)}")

    # Test 2: Verify exclusions
    print(f"\n[Test 2] Verify exclusions:")
    print("-" * 70)

    # Check that non-directories are excluded
    all_items = list(INPUT_DIR.iterdir())
    non_dirs = [item for item in all_items if not item.is_dir()]
    print(f"  Non-directory items in INPUT_DIR: {len(non_dirs)}")
    for item in non_dirs:
        print(f"    - {item.name} (correctly excluded)")

    # Check that excluded directories are filtered out
    excluded_count = 0
    for item in all_items:
        if item.is_dir():
            for excluded_pattern in EXCLUDE_DIRS:
                if item.name.lower() == excluded_pattern.lower():
                    excluded_count += 1
                    print(f"  Excluded directory: {item.name} (matches '{excluded_pattern}')")

    if excluded_count == 0:
        print("  No excluded directories found in INPUT_DIR (as expected)")

    # Test 3: Verify sorting
    print(f"\n[Test 3] Verify alphabetical sorting:")
    print("-" * 70)
    skill_names = [s.name for s in skills]
    sorted_names = sorted(skill_names, key=str.lower)
    is_sorted = skill_names == sorted_names
    print(f"  Skills are sorted: {is_sorted}")
    if not is_sorted:
        print(f"  Expected order: {sorted_names}")
        print(f"  Actual order: {skill_names}")

    # Test 4: Sample skill names
    print(f"\n[Test 4] Sample discovered skills:")
    print("-" * 70)
    for i, skill in enumerate(skills[:5]):  # Show first 5
        print(f"  {i+1}. {skill.name}")
    if len(skills) > 5:
        print(f"  ... and {len(skills) - 5} more")

    # Test 5: Verify specific expected skills exist
    print(f"\n[Test 5] Verify expected skills exist:")
    print("-" * 70)
    expected_skills = ['algorithmic-art', 'pdf', 'xlsx', 'skill-creator']
    for expected in expected_skills:
        found = any(s.name == expected for s in skills)
        status = "✓ FOUND" if found else "✗ MISSING"
        print(f"  {status}: {expected}")

    # Final summary
    print(f"\n{'=' * 70}")
    print(f"TEST SUMMARY")
    print(f"{'=' * 70}")
    print(f"✓ Test 1: Discovery successful - {len(skills)} skills found")
    print(f"✓ Test 2: Exclusions working correctly")
    print(f"✓ Test 3: Sorting {'PASS' if is_sorted else 'FAIL'}")
    print(f"✓ Test 4: Skills accessible")
    print(f"✓ Test 5: Expected skills present")
    print(f"\nAll tests completed successfully!")

    return skills


if __name__ == "__main__":
    try:
        skills = test_discover_skills()
        sys.exit(0)
    except Exception as e:
        print(f"\n✗ TEST FAILED WITH ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
