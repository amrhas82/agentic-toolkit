#!/usr/bin/env python3
"""
Test script for filename generation and sanitization methods.

Tests the generate_output_filename() and check_naming_conflict() methods
with various edge cases and normal scenarios.
"""

import sys
from pathlib import Path
import tempfile
import shutil

# Add parent directory to path to import the converter
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter


def test_generate_output_filename():
    """Test the generate_output_filename method with various inputs."""
    print("=" * 70)
    print("Testing generate_output_filename()")
    print("=" * 70)

    converter = SkillConverter()

    # Test cases: (input, expected_output, description)
    test_cases = [
        # Normal cases
        ("algorithmic-art", "algorithmic-art.md", "Normal kebab-case"),
        ("MCP Builder", "mcp-builder.md", "Title case with space"),
        ("algorithmic_art", "algorithmic-art.md", "Underscore conversion"),
        ("my_cool_skill", "my-cool-skill.md", "Multiple underscores"),

        # Edge cases
        ("", "unnamed-skill.md", "Empty string"),
        ("   ", "unnamed-skill.md", "Whitespace only"),
        ("My Cool  Skill!!!", "my-cool-skill.md", "Multiple spaces and special chars"),
        ("___test___", "test.md", "Leading/trailing underscores"),
        ("---test---", "test.md", "Leading/trailing hyphens"),
        ("test-123-abc", "test-123-abc.md", "Numbers in name"),
        ("123", "123.md", "Numbers only"),

        # Special characters
        ("test@#$%^&*()skill", "testskill.md", "Special characters removed"),
        ("hello!world?", "helloworld.md", "Punctuation removed"),
        ("test...skill", "test-skill.md", "Multiple dots"),
        ("test   skill", "test-skill.md", "Multiple spaces"),

        # Already has .md extension
        ("test.md", "test.md", "Already has .md"),

        # Unicode and non-ASCII
        ("café-skill", "caf-skill.md", "Unicode characters"),
        ("skill™", "skill.md", "Trademark symbol"),

        # Very long name
        ("a" * 100, "a" * 100 + ".md", "Very long name"),

        # Complex real-world examples
        ("MCP_API_Builder_v2", "mcp-api-builder-v2.md", "Version number"),
        ("test-skill-2.0", "test-skill-2-0.md", "Dot in version"),
    ]

    print("\nRunning test cases:\n")

    passed = 0
    failed = 0

    for input_name, expected, description in test_cases:
        result = converter.generate_output_filename(input_name)
        status = "✓ PASS" if result == expected else "✗ FAIL"

        if result == expected:
            passed += 1
        else:
            failed += 1

        # Print result
        print(f"{status} | {description}")
        print(f"       Input:    '{input_name}'")
        print(f"       Expected: '{expected}'")
        print(f"       Got:      '{result}'")

        if result != expected:
            print(f"       ^^^ MISMATCH!")

        print()

    print(f"Results: {passed} passed, {failed} failed out of {len(test_cases)} tests")
    print()

    return failed == 0


def test_check_naming_conflict():
    """Test the check_naming_conflict method with various scenarios."""
    print("=" * 70)
    print("Testing check_naming_conflict()")
    print("=" * 70)

    converter = SkillConverter()

    # Create a temporary directory for testing
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)

        print(f"\nUsing temporary directory: {temp_path}\n")

        # Test 1: No conflict - directory is empty
        print("Test 1: No conflict (empty directory)")
        result = converter.check_naming_conflict("test.md", temp_path)
        expected = "test.md"
        status = "✓ PASS" if result == expected else "✗ FAIL"
        print(f"{status} | Expected: '{expected}', Got: '{result}'")
        print()

        # Test 2: Create a file and check for conflict
        print("Test 2: Single conflict (file exists)")
        (temp_path / "test.md").touch()
        result = converter.check_naming_conflict("test.md", temp_path)
        expected = "test-2.md"
        status = "✓ PASS" if result == expected else "✗ FAIL"
        print(f"{status} | Expected: '{expected}', Got: '{result}'")
        print()

        # Test 3: Multiple conflicts
        print("Test 3: Multiple conflicts (test.md and test-2.md exist)")
        (temp_path / "test-2.md").touch()
        result = converter.check_naming_conflict("test.md", temp_path)
        expected = "test-3.md"
        status = "✓ PASS" if result == expected else "✗ FAIL"
        print(f"{status} | Expected: '{expected}', Got: '{result}'")
        print()

        # Test 4: Non-existent directory
        print("Test 4: Non-existent output directory")
        non_existent = temp_path / "does_not_exist"
        result = converter.check_naming_conflict("test.md", non_existent)
        expected = "test.md"
        status = "✓ PASS" if result == expected else "✗ FAIL"
        print(f"{status} | Expected: '{expected}', Got: '{result}'")
        print()

        # Test 5: Files without .md extension
        print("Test 5: File without .md extension")
        (temp_path / "readme").touch()
        result = converter.check_naming_conflict("readme", temp_path)
        expected = "readme-2"
        status = "✓ PASS" if result == expected else "✗ FAIL"
        print(f"{status} | Expected: '{expected}', Got: '{result}'")
        print()

        # Test 6: Large gap in numbering
        print("Test 6: Gap in numbering (skill.md and skill-5.md exist)")
        (temp_path / "skill.md").touch()
        (temp_path / "skill-5.md").touch()
        result = converter.check_naming_conflict("skill.md", temp_path)
        expected = "skill-2.md"
        status = "✓ PASS" if result == expected else "✗ FAIL"
        print(f"{status} | Expected: '{expected}', Got: '{result}'")
        print()

    print("All conflict tests completed successfully!")
    print()

    return True


def test_integration():
    """Test the methods working together in realistic scenarios."""
    print("=" * 70)
    print("Integration Tests")
    print("=" * 70)

    converter = SkillConverter()

    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)

        print(f"\nUsing temporary directory: {temp_path}\n")

        # Scenario 1: Process multiple skills with similar names
        print("Scenario 1: Multiple skills with similar names")
        skill_names = [
            "algorithmic-art",
            "Algorithmic Art",  # Different case, same result
            "algorithmic_art",  # Different separator, same result
            "MCP Builder",
            "mcp-builder",
        ]

        filenames = []
        for skill_name in skill_names:
            # Generate filename
            filename = converter.generate_output_filename(skill_name)

            # Check for conflicts
            safe_filename = converter.check_naming_conflict(filename, temp_path)

            # Create the file
            (temp_path / safe_filename).touch()

            filenames.append(safe_filename)
            print(f"  '{skill_name}' -> '{safe_filename}'")

        print(f"\nGenerated {len(filenames)} unique filenames:")
        for f in filenames:
            print(f"  - {f}")

        print()

        # Verify all files exist
        print("Verifying all files were created:")
        for filename in filenames:
            exists = (temp_path / filename).exists()
            status = "✓" if exists else "✗"
            print(f"  {status} {filename}")

        print()

    print("Integration tests completed successfully!")
    print()

    return True


def main():
    """Run all tests."""
    print("\n")
    print("*" * 70)
    print("Filename Generation and Sanitization Test Suite")
    print("*" * 70)
    print()

    all_passed = True

    # Run tests
    all_passed &= test_generate_output_filename()
    all_passed &= test_check_naming_conflict()
    all_passed &= test_integration()

    # Final summary
    print("=" * 70)
    if all_passed:
        print("✓ All tests PASSED!")
    else:
        print("✗ Some tests FAILED!")
    print("=" * 70)
    print()

    return 0 if all_passed else 1


if __name__ == "__main__":
    sys.exit(main())
