#!/usr/bin/env python3
"""
Test script for categorize_content_files() method.

Tests the file categorization logic with real skill directories
to ensure proper classification of files by purpose.
"""

import sys
from pathlib import Path

# Add parent directory to path so we can import the converter
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter, INPUT_DIR


def test_skill_categorization(skill_name: str):
    """Test categorization for a specific skill directory."""
    print("=" * 80)
    print(f"Testing: {skill_name}")
    print("=" * 80)

    converter = SkillConverter()
    skill_path = INPUT_DIR / skill_name

    if not skill_path.exists():
        print(f"ERROR: Skill directory not found: {skill_path}")
        return

    print(f"\nSkill directory: {skill_path}")
    print("\n" + "-" * 80)
    print("Step 1: Discovering files...")
    print("-" * 80)

    # Discover files
    discovered_files = converter.discover_files(skill_path)

    # Print discovery results
    print(f"\nDiscovery Results:")
    print(f"  SKILL.md: {discovered_files['skill_md'].name if discovered_files['skill_md'] else 'None'}")
    print(f"  Markdown files: {len(discovered_files['markdown'])}")
    print(f"  Code files: {len(discovered_files['code'])}")
    print(f"  Config files: {len(discovered_files['config'])}")
    print(f"  Other files: {len(discovered_files['other'])}")

    print("\n" + "-" * 80)
    print("Step 2: Categorizing files by purpose...")
    print("-" * 80)
    print()

    # Categorize files
    categorized = converter.categorize_content_files(discovered_files)

    print("\n" + "-" * 80)
    print("Final Categorization Results:")
    print("-" * 80)

    # Show detailed results
    for category, files in categorized.items():
        print(f"\n{category.upper()}: {len(files)} files")
        for file_path in files:
            # Show relative path from skill directory
            try:
                rel_path = file_path.relative_to(skill_path)
                print(f"  - {rel_path}")
            except ValueError:
                print(f"  - {file_path}")

    print("\n")


def main():
    """Run categorization tests on multiple skill directories."""
    print("\nContent Categorization Test")
    print("=" * 80)
    print("Testing categorize_content_files() with real skill directories")
    print("=" * 80)

    # Test with specific skills that have different structures
    test_skills = [
        "mcp-builder",      # Has reference/ subdirectory
        "theme-factory",    # Has themes/ subdirectory
        "pdf",              # Has mixed structure
        "algorithmic-art",  # Has templates/ subdirectory with code files
        "docx",             # Has ooxml/ subdirectory with XML files
    ]

    for skill_name in test_skills:
        test_skill_categorization(skill_name)
        print("\n")

    print("=" * 80)
    print("Test Complete!")
    print("=" * 80)


if __name__ == "__main__":
    main()
