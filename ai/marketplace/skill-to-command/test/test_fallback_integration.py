#!/usr/bin/env python3
"""
Integration test for fallback metadata generation with real skill directories.

This test creates temporary skill directories and verifies the full workflow.
"""

import sys
import tempfile
import shutil
from pathlib import Path
from skill_to_command_converter import SkillConverter


def test_skill_without_skillmd():
    """Test with a skill directory that has no SKILL.md."""
    print("\n" + "=" * 60)
    print("Integration Test 1: Skill with no SKILL.md")
    print("=" * 60)

    # Create temporary skill directory
    with tempfile.TemporaryDirectory() as tmpdir:
        skill_dir = Path(tmpdir) / "test-skill-no-metadata"
        skill_dir.mkdir()

        # Create some code files
        (skill_dir / "script.py").write_text("#!/usr/bin/env python3\nprint('Hello, World!')")
        (skill_dir / "helper.js").write_text("console.log('Helper script');")

        # Create a README
        (skill_dir / "README.md").write_text("""# Test Skill

This is a test skill for verifying fallback metadata generation.

It should generate proper metadata even without SKILL.md.
""")

        print(f"\nCreated test skill at: {skill_dir}")
        print("Contents:")
        for item in skill_dir.iterdir():
            print(f"  - {item.name}")

        # Test the converter
        converter = SkillConverter()

        # Discover files
        print("\nDiscovering files...")
        files_dict = converter.discover_files(skill_dir)

        print(f"  skill_md: {files_dict['skill_md']}")
        print(f"  markdown: {len(files_dict['markdown'])} files")
        print(f"  code: {len(files_dict['code'])} files")

        # Generate fallback metadata
        print("\nGenerating fallback metadata...")
        metadata = converter.generate_fallback_metadata("test-skill-no-metadata", files_dict)

        print("\nGenerated metadata:")
        print(f"  description: {metadata['description']}")
        print(f"  argument-hint: {metadata['argument-hint']}")

        # Verify results
        assert metadata['description'], "Description should not be empty"
        assert metadata['argument-hint'] == "<file-path>", "Should detect code files and suggest <file-path>"

        print("\n✓ Test passed!")


def test_skill_with_incomplete_metadata():
    """Test with a skill that has SKILL.md but missing argument-hint."""
    print("\n" + "=" * 60)
    print("Integration Test 2: Skill with incomplete YAML metadata")
    print("=" * 60)

    with tempfile.TemporaryDirectory() as tmpdir:
        skill_dir = Path(tmpdir) / "test-skill-partial"
        skill_dir.mkdir()

        # Create SKILL.md with only description (no argument-hint)
        (skill_dir / "SKILL.md").write_text("""---
description: A test skill with partial metadata
---

# Test Skill

This skill has a description but no argument-hint in its YAML front matter.
""")

        # Create some code files
        (skill_dir / "main.py").write_text("print('Main script')")

        print(f"\nCreated test skill at: {skill_dir}")

        # Test the converter
        converter = SkillConverter()

        # Discover files
        files_dict = converter.discover_files(skill_dir)

        # Extract existing metadata
        if files_dict.get('skill_md'):
            content = converter.read_file_with_retry(files_dict['skill_md'])
            existing_metadata = converter.extract_yaml_frontmatter(content)
        else:
            existing_metadata = {}

        print(f"\nExisting metadata: {existing_metadata}")

        # Test generate_output_content with incomplete metadata
        categorized = converter.categorize_content_files(files_dict)

        print("\nGenerating output content (should use fallback for argument-hint)...")
        output = converter.generate_output_content("test-skill-partial", files_dict, categorized, existing_metadata)

        # Verify the output contains both description and argument-hint
        assert "description: A test skill with partial metadata" in output, "Should preserve existing description"
        assert "argument-hint:" in output, "Should add missing argument-hint"

        print("\n✓ Test passed!")


def test_skill_with_themes():
    """Test with a skill that has themes."""
    print("\n" + "=" * 60)
    print("Integration Test 3: Skill with themes directory")
    print("=" * 60)

    with tempfile.TemporaryDirectory() as tmpdir:
        skill_dir = Path(tmpdir) / "theme-tester"
        skill_dir.mkdir()

        # Create themes directory
        themes_dir = skill_dir / "themes"
        themes_dir.mkdir()

        # Create some theme files
        (themes_dir / "dark.md").write_text("# Dark Theme\nA dark color scheme.")
        (themes_dir / "light.md").write_text("# Light Theme\nA light color scheme.")

        print(f"\nCreated test skill at: {skill_dir}")
        print("Structure:")
        for item in skill_dir.rglob('*'):
            if item.is_file():
                print(f"  - {item.relative_to(skill_dir)}")

        # Test the converter
        converter = SkillConverter()
        files_dict = converter.discover_files(skill_dir)

        print("\nGenerating fallback metadata...")
        metadata = converter.generate_fallback_metadata("theme-tester", files_dict)

        print("\nGenerated metadata:")
        print(f"  description: {metadata['description']}")
        print(f"  argument-hint: {metadata['argument-hint']}")

        # Verify results
        assert metadata['argument-hint'] == "<theme-name>", "Should detect themes and suggest <theme-name>"

        print("\n✓ Test passed!")


def main():
    """Run all integration tests."""
    print("\nFallback Metadata Integration Tests")
    print("=" * 60)

    try:
        test_skill_without_skillmd()
        test_skill_with_incomplete_metadata()
        test_skill_with_themes()

        print("\n" + "=" * 60)
        print("ALL INTEGRATION TESTS PASSED!")
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
