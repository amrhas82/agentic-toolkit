#!/usr/bin/env python3
"""
Test script for fallback metadata generation.

This script tests the generate_fallback_metadata method by:
1. Creating a test skill directory structure
2. Testing with various file combinations
3. Verifying the fallback logic works correctly
"""

import sys
import tempfile
from pathlib import Path
from skill_to_command_converter import SkillConverter

def test_fallback_with_code_files():
    """Test fallback metadata generation with code files."""
    print("\n" + "=" * 60)
    print("Test 1: Skill with code files (should suggest <file-path>)")
    print("=" * 60)

    converter = SkillConverter()

    # Simulate files_dict from discover_files()
    files_dict = {
        "skill_md": None,  # No SKILL.md
        "markdown": [],
        "code": [Path("/fake/skill/script.py"), Path("/fake/skill/helper.js")],
        "config": [],
        "other": []
    }

    metadata = converter.generate_fallback_metadata("mcp-builder", files_dict)

    print("\nResult:")
    print(f"  description: {metadata['description']}")
    print(f"  argument-hint: {metadata['argument-hint']}")

    # Verify results
    assert "MCP Builder" in metadata['description'], "Title conversion failed"
    assert metadata['argument-hint'] == "<file-path>", "Should suggest <file-path> for code files"
    print("\n✓ Test passed!")


def test_fallback_with_themes():
    """Test fallback metadata generation with themes."""
    print("\n" + "=" * 60)
    print("Test 2: Skill with themes (should suggest <theme-name>)")
    print("=" * 60)

    converter = SkillConverter()

    # Simulate files_dict with themes
    files_dict = {
        "skill_md": None,
        "markdown": [Path("/fake/skill/themes/dark.md"), Path("/fake/skill/themes/light.md")],
        "code": [],
        "config": [],
        "other": []
    }

    metadata = converter.generate_fallback_metadata("algorithmic-art", files_dict)

    print("\nResult:")
    print(f"  description: {metadata['description']}")
    print(f"  argument-hint: {metadata['argument-hint']}")

    # Verify results
    assert "Algorithmic Art" in metadata['description'], "Title conversion failed"
    assert metadata['argument-hint'] == "<theme-name>", "Should suggest <theme-name> for themes"
    print("\n✓ Test passed!")


def test_fallback_with_no_special_files():
    """Test fallback metadata generation with no special file indicators."""
    print("\n" + "=" * 60)
    print("Test 3: Skill with no special files (should use default)")
    print("=" * 60)

    converter = SkillConverter()

    # Simulate files_dict with only markdown files
    files_dict = {
        "skill_md": None,
        "markdown": [Path("/fake/skill/README.md")],
        "code": [],
        "config": [],
        "other": []
    }

    metadata = converter.generate_fallback_metadata("test-skill", files_dict)

    print("\nResult:")
    print(f"  description: {metadata['description']}")
    print(f"  argument-hint: {metadata['argument-hint']}")

    # Verify results
    assert "Test Skill" in metadata['description'], "Title conversion failed"
    assert metadata['argument-hint'] == "<arguments>", "Should use default <arguments>"
    print("\n✓ Test passed!")


def test_title_conversion():
    """Test skill name to title conversion."""
    print("\n" + "=" * 60)
    print("Test 4: Title conversion logic")
    print("=" * 60)

    converter = SkillConverter()

    test_cases = [
        ("mcp-builder", "MCP Builder"),
        ("algorithmic-art", "Algorithmic Art"),
        ("test_skill", "Test Skill"),
        ("simple", "Simple"),
    ]

    for skill_name, expected_title in test_cases:
        files_dict = {
            "skill_md": None,
            "markdown": [],
            "code": [],
            "config": [],
            "other": []
        }

        metadata = converter.generate_fallback_metadata(skill_name, files_dict)

        print(f"\n  {skill_name} -> {expected_title}")
        assert expected_title in metadata['description'], f"Expected '{expected_title}' in description"
        print(f"    ✓ Description: {metadata['description']}")

    print("\n✓ All title conversions passed!")


def main():
    """Run all tests."""
    print("\nTesting Fallback Metadata Generation")
    print("=" * 60)

    try:
        test_fallback_with_code_files()
        test_fallback_with_themes()
        test_fallback_with_no_special_files()
        test_title_conversion()

        print("\n" + "=" * 60)
        print("ALL TESTS PASSED!")
        print("=" * 60)

    except AssertionError as e:
        print(f"\n✗ Test failed: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
