#!/usr/bin/env python3
"""
Quick verification tests for utility functions in skill_to_command_converter.py
"""

import sys
from pathlib import Path

# Import the module
sys.path.insert(0, str(Path(__file__).parent))
from skill_to_command_converter import (
    detect_encoding,
    safe_read_file,
    should_exclude_file,
    should_exclude_dir,
    get_language_hint
)


def test_detect_encoding():
    """Test encoding detection function."""
    print("Testing detect_encoding()...")

    # Test with actual script file (should be UTF-8)
    script_path = Path(__file__).parent / "skill_to_command_converter.py"
    encoding = detect_encoding(script_path)
    print(f"  ✓ Script file encoding: {encoding}")
    assert encoding in ['utf-8', 'latin-1', 'cp1252'], f"Unexpected encoding: {encoding}"


def test_safe_read_file():
    """Test safe file reading function."""
    print("\nTesting safe_read_file()...")

    # Test reading the script itself
    script_path = Path(__file__).parent / "skill_to_command_converter.py"
    content = safe_read_file(script_path, retry=False)
    assert content is not None, "Failed to read script file"
    assert "def main():" in content, "Script content not read correctly"
    print(f"  ✓ Read {len(content)} characters from script")

    # Test reading non-existent file
    fake_path = Path("/tmp/nonexistent_file_12345.txt")
    content = safe_read_file(fake_path, retry=False)
    assert content is None, "Should return None for non-existent file"
    print("  ✓ Correctly returns None for non-existent file")


def test_should_exclude_file():
    """Test file exclusion logic."""
    print("\nTesting should_exclude_file()...")

    # Test excluding LICENSE.txt
    license_file = Path("/tmp/LICENSE.txt")
    assert should_exclude_file(license_file) == True, "Should exclude LICENSE.txt"
    print("  ✓ Excludes LICENSE.txt")

    # Test excluding .bak file
    bak_file = Path("/tmp/test.bak")
    assert should_exclude_file(bak_file) == True, "Should exclude .bak files"
    print("  ✓ Excludes .bak files")

    # Test excluding binary files
    png_file = Path("/tmp/image.png")
    assert should_exclude_file(png_file) == True, "Should exclude .png files"
    print("  ✓ Excludes .png files")

    # Test including valid markdown files
    md_file = Path(__file__).parent / "skill_to_command_converter.py"
    assert should_exclude_file(md_file) == False, "Should not exclude .py files"
    print("  ✓ Includes .py files")


def test_should_exclude_dir():
    """Test directory exclusion logic."""
    print("\nTesting should_exclude_dir()...")

    # Test excluding scripts directory
    assert should_exclude_dir("scripts") == True, "Should exclude 'scripts'"
    assert should_exclude_dir("Scripts") == True, "Should exclude 'Scripts' (case-insensitive)"
    print("  ✓ Excludes 'scripts' directory")

    # Test excluding __pycache__
    assert should_exclude_dir("__pycache__") == True, "Should exclude '__pycache__'"
    print("  ✓ Excludes '__pycache__' directory")

    # Test excluding .git
    assert should_exclude_dir(".git") == True, "Should exclude '.git'"
    print("  ✓ Excludes '.git' directory")

    # Test including normal directories
    assert should_exclude_dir("examples") == False, "Should not exclude 'examples'"
    assert should_exclude_dir("docs") == False, "Should not exclude 'docs'"
    print("  ✓ Includes normal directories")


def test_get_language_hint():
    """Test language hint detection."""
    print("\nTesting get_language_hint()...")

    tests = [
        (Path("test.py"), "python"),
        (Path("test.js"), "javascript"),
        (Path("test.ts"), "typescript"),
        (Path("test.sh"), "bash"),
        (Path("test.json"), "json"),
        (Path("test.yaml"), "yaml"),
        (Path("test.md"), "markdown"),
        (Path("test.html"), "html"),
        (Path("test.css"), "css"),
        (Path("test.sql"), "sql"),
        (Path("test.unknown"), ""),  # Unknown extension
    ]

    for file_path, expected_lang in tests:
        result = get_language_hint(file_path)
        assert result == expected_lang, f"Expected '{expected_lang}' for {file_path.name}, got '{result}'"
        print(f"  ✓ {file_path.name} → '{result}'")


def main():
    """Run all tests."""
    print("=" * 60)
    print("UTILITY FUNCTIONS VERIFICATION")
    print("=" * 60)
    print()

    try:
        test_detect_encoding()
        test_safe_read_file()
        test_should_exclude_file()
        test_should_exclude_dir()
        test_get_language_hint()

        print()
        print("=" * 60)
        print("ALL TESTS PASSED!")
        print("=" * 60)
        return 0

    except AssertionError as e:
        print()
        print("=" * 60)
        print(f"TEST FAILED: {e}")
        print("=" * 60)
        return 1
    except Exception as e:
        print()
        print("=" * 60)
        print(f"ERROR: {e}")
        print("=" * 60)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
