#!/usr/bin/env python3
"""Test script for YAML front matter extraction."""

import sys
from pathlib import Path

# Add parent directory to path to import the converter module
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter

def test_yaml_extraction():
    """Test YAML front matter extraction on real SKILL.md files."""

    converter = SkillConverter()

    # Test files
    test_files = [
        Path("/home/user/agentic-kit/skill-to-command/skills/algorithmic-art/SKILL.md"),
        Path("/home/user/agentic-kit/skill-to-command/skills/pdf/SKILL.md"),
        Path("/home/user/agentic-kit/skill-to-command/skills/code-review/SKILL.md"),
        Path("/home/user/agentic-kit/skill-to-command/skills/mcp-builder/SKILL.md"),
    ]

    print("=" * 70)
    print("YAML Front Matter Extraction Test")
    print("=" * 70)
    print()

    for test_file in test_files:
        if not test_file.exists():
            print(f"SKIP: {test_file.name} - File not found")
            print()
            continue

        print(f"Testing: {test_file.name}")
        print("-" * 70)

        # Read file
        content = converter.read_file_with_retry(test_file)

        if content is None:
            print(f"  ERROR: Failed to read file")
            print()
            continue

        # Extract YAML
        yaml_data = converter.extract_yaml_frontmatter(content)

        print(f"\n  Extracted fields ({len(yaml_data)}):")
        if yaml_data:
            for key, value in yaml_data.items():
                # Truncate long values for display
                display_value = value if len(value) <= 80 else f"{value[:77]}..."
                print(f"    {key}: {display_value}")
        else:
            print("    (No YAML front matter found)")

        print()

    # Test edge cases
    print("=" * 70)
    print("Edge Case Tests")
    print("=" * 70)
    print()

    # Test 1: No YAML front matter
    print("Test 1: No YAML front matter")
    print("-" * 70)
    content1 = "# Regular Markdown\n\nThis has no YAML front matter."
    result1 = converter.extract_yaml_frontmatter(content1)
    print(f"  Result: {result1}")
    print(f"  Expected: {{}}")
    print(f"  Status: {'PASS' if result1 == {} else 'FAIL'}")
    print()

    # Test 2: Valid YAML with description and argument-hint
    print("Test 2: Valid YAML with description and argument-hint")
    print("-" * 70)
    content2 = """---
description: Test description
argument-hint: Optional hint
---

Content here."""
    result2 = converter.extract_yaml_frontmatter(content2)
    print(f"  Result: {result2}")
    has_desc = 'description' in result2
    has_hint = 'argument-hint' in result2
    print(f"  Has 'description': {has_desc}")
    print(f"  Has 'argument-hint': {has_hint}")
    print(f"  Status: {'PASS' if has_desc and has_hint else 'FAIL'}")
    print()

    # Test 3: YAML with colons in values (needs quoting)
    print("Test 3: YAML with colons in values")
    print("-" * 70)
    content3 = """---
description: "This is a test: it has colons"
name: test-skill
---

Content."""
    result3 = converter.extract_yaml_frontmatter(content3)
    print(f"  Result: {result3}")
    has_desc = 'description' in result3 and ':' in result3.get('description', '')
    print(f"  Description preserved with colon: {has_desc}")
    print(f"  Status: {'PASS' if has_desc else 'FAIL'}")
    print()

    # Test 4: Empty YAML block
    print("Test 4: Empty YAML block")
    print("-" * 70)
    content4 = """---
---

Content."""
    result4 = converter.extract_yaml_frontmatter(content4)
    print(f"  Result: {result4}")
    print(f"  Expected: {{}}")
    print(f"  Status: {'PASS' if result4 == {} else 'FAIL'}")
    print()

    # Test 5: Missing closing delimiter
    print("Test 5: Missing closing delimiter")
    print("-" * 70)
    content5 = """---
description: Test
name: test

No closing delimiter"""
    result5 = converter.extract_yaml_frontmatter(content5)
    print(f"  Result: {result5}")
    print(f"  Expected: {{}}")
    print(f"  Status: {'PASS' if result5 == {} else 'FAIL'}")
    print()

    print("=" * 70)
    print("Test Complete")
    print("=" * 70)


if __name__ == "__main__":
    test_yaml_extraction()
