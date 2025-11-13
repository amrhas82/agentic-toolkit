#!/usr/bin/env python3
"""
Test script for Subtask 3.5 - Content Integration

Tests the generate_output_content() method with mcp-builder and theme-factory skills.
"""

import sys
from pathlib import Path

# Add script directory to path to import the converter
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter, INPUT_DIR, OUTPUT_DIR


def test_skill(skill_name: str, converter: SkillConverter):
    """Test content generation for a single skill."""
    print(f"\n{'='*70}")
    print(f"Testing: {skill_name}")
    print(f"{'='*70}")

    skill_dir = INPUT_DIR / skill_name

    if not skill_dir.exists():
        print(f"ERROR: Skill directory not found: {skill_dir}")
        return False

    # Discover files
    print(f"\n1. Discovering files in {skill_name}...")
    files_dict = converter.discover_files(skill_dir)

    print(f"\nFiles discovered:")
    print(f"  - SKILL.md: {files_dict['skill_md']}")
    print(f"  - Markdown files: {len(files_dict['markdown'])}")
    print(f"  - Code files: {len(files_dict['code'])}")
    print(f"  - Config files: {len(files_dict['config'])}")
    print(f"  - Other files: {len(files_dict['other'])}")

    # Categorize content
    print(f"\n2. Categorizing content files...")
    categorized = converter.categorize_content_files(files_dict)

    # Extract metadata from SKILL.md
    print(f"\n3. Extracting metadata from SKILL.md...")
    metadata = {}
    if files_dict.get("skill_md"):
        skill_md_content = converter.read_file_with_retry(files_dict["skill_md"])
        if skill_md_content:
            metadata = converter.extract_yaml_frontmatter(skill_md_content)
            print(f"  Metadata extracted: {list(metadata.keys())}")

    # Generate output content
    print(f"\n4. Generating output content...")
    try:
        output_content = converter.generate_output_content(
            skill_name=skill_name,
            files_dict=files_dict,
            categorized=categorized,
            metadata=metadata
        )

        print(f"\n5. Output generated successfully!")
        print(f"  - Length: {len(output_content)} characters")
        print(f"  - Lines: {len(output_content.split(chr(10)))}")

        # Write to test output file
        output_file = OUTPUT_DIR / f"{skill_name}.md"
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(output_content)

        print(f"\n6. Output written to: {output_file}")

        # Show preview of first 50 lines
        print(f"\n7. Preview (first 50 lines):")
        print("-" * 70)
        lines = output_content.split('\n')
        for i, line in enumerate(lines[:50], 1):
            print(f"{i:3d} | {line}")
        if len(lines) > 50:
            print(f"... ({len(lines) - 50} more lines)")
        print("-" * 70)

        return True

    except Exception as e:
        print(f"\nERROR: Failed to generate output content: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    """Main test function."""
    print("="*70)
    print("Subtask 3.5 - Content Integration Test")
    print("="*70)

    # Create converter instance
    converter = SkillConverter()

    # Test skills
    skills_to_test = ["mcp-builder", "theme-factory"]
    results = {}

    for skill_name in skills_to_test:
        results[skill_name] = test_skill(skill_name, converter)

    # Print summary
    print(f"\n\n{'='*70}")
    print("Test Summary")
    print(f"{'='*70}")

    for skill_name, success in results.items():
        status = "✓ PASSED" if success else "✗ FAILED"
        print(f"{status}: {skill_name}")

    all_passed = all(results.values())

    if all_passed:
        print(f"\n✓ All tests passed!")
        return 0
    else:
        print(f"\n✗ Some tests failed")
        return 1


if __name__ == "__main__":
    sys.exit(main())
