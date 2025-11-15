#!/usr/bin/env python3
"""
Test script for parse_sample_format() method.

This script tests the sample format parser to ensure it correctly
extracts the structure from the algorithmic-art.md sample file.
"""

import sys
from pathlib import Path

# Add parent directory to path so we can import the converter
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter


def test_parse_sample_format():
    """Test the parse_sample_format() method."""
    print("=" * 70)
    print("Testing parse_sample_format()")
    print("=" * 70)

    # Create converter instance
    converter = SkillConverter()

    # Parse the sample format
    structure = converter.parse_sample_format()

    # Display results
    print("\n" + "=" * 70)
    print("RESULTS")
    print("=" * 70)

    print("\n1. YAML Front Matter Fields:")
    if structure["yaml_fields"]:
        for field in structure["yaml_fields"]:
            print(f"   - {field}")
    else:
        print("   (None found)")

    print(f"\n2. All Sections ({len(structure['sections'])}):")
    if structure["sections"]:
        for i, section in enumerate(structure["sections"], 1):
            print(f"   {i}. {section}")
    else:
        print("   (None found)")

    print(f"\n3. Step Sections ({len(structure['step_sections'])}):")
    if structure["step_sections"]:
        for step in structure["step_sections"]:
            print(f"   Step {step['number']}: {step['title']}")
    else:
        print("   (None found)")

    print(f"\n4. Structure Flags:")
    print(f"   - Has Steps: {structure['has_steps']}")
    print(f"   - Has Examples: {structure['has_examples']}")
    print(f"   - Has Usage: {structure['has_usage']}")
    print(f"   - Step Count: {structure['step_count']}")

    # Validation checks
    print("\n" + "=" * 70)
    print("VALIDATION")
    print("=" * 70)

    passed = 0
    failed = 0

    # Test 1: YAML fields should include 'description' and 'argument-hint'
    print("\nTest 1: YAML fields contains 'description' and 'argument-hint'")
    if 'description' in structure["yaml_fields"] and 'argument-hint' in structure["yaml_fields"]:
        print("   ✓ PASSED")
        passed += 1
    else:
        print(f"   ✗ FAILED - Expected 'description' and 'argument-hint', got: {structure['yaml_fields']}")
        failed += 1

    # Test 2: Should have at least one Step section
    print("\nTest 2: Has Step sections")
    if structure['has_steps'] and structure['step_count'] > 0:
        print(f"   ✓ PASSED - Found {structure['step_count']} steps")
        passed += 1
    else:
        print(f"   ✗ FAILED - Expected steps, got count: {structure['step_count']}")
        failed += 1

    # Test 3: Should have Examples section
    print("\nTest 3: Has Examples section")
    if structure['has_examples']:
        print("   ✓ PASSED")
        passed += 1
    else:
        print("   ✗ FAILED - Expected Examples section")
        failed += 1

    # Test 4: Should have Usage section
    print("\nTest 4: Has Usage section")
    if structure['has_usage']:
        print("   ✓ PASSED")
        passed += 1
    else:
        print("   ✗ FAILED - Expected Usage section")
        failed += 1

    # Test 5: Total sections should be reasonable (at least 6)
    print("\nTest 5: Has reasonable number of sections (>= 6)")
    if len(structure['sections']) >= 6:
        print(f"   ✓ PASSED - Found {len(structure['sections'])} sections")
        passed += 1
    else:
        print(f"   ✗ FAILED - Expected >= 6 sections, got {len(structure['sections'])}")
        failed += 1

    # Test 6: Step sections should be numbered 1, 2, 3, 4
    print("\nTest 6: Step sections are numbered sequentially (1-4)")
    expected_steps = [1, 2, 3, 4]
    actual_steps = [step['number'] for step in structure['step_sections']]
    if actual_steps == expected_steps:
        print(f"   ✓ PASSED - Found steps: {actual_steps}")
        passed += 1
    else:
        print(f"   ✗ FAILED - Expected {expected_steps}, got {actual_steps}")
        failed += 1

    # Summary
    print("\n" + "=" * 70)
    print("TEST SUMMARY")
    print("=" * 70)
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    print(f"Total:  {passed + failed}")

    if failed == 0:
        print("\n✓ All tests passed!")
        return 0
    else:
        print(f"\n✗ {failed} test(s) failed")
        return 1


if __name__ == "__main__":
    sys.exit(test_parse_sample_format())
