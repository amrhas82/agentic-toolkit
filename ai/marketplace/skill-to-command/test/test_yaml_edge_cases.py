#!/usr/bin/env python3
"""Test script for YAML edge cases and fallback modes."""

import sys
from pathlib import Path

# Add parent directory to path to import the converter module
sys.path.insert(0, str(Path(__file__).parent))

# Temporarily disable PyYAML to test regex fallback
import skill_to_command_converter
original_yaml_available = skill_to_command_converter.YAML_AVAILABLE

from skill_to_command_converter import SkillConverter

def test_regex_fallback():
    """Test YAML extraction using regex fallback (when PyYAML unavailable)."""

    print("=" * 70)
    print("Testing Regex Fallback Mode (PyYAML disabled)")
    print("=" * 70)
    print()

    # Temporarily disable PyYAML
    skill_to_command_converter.YAML_AVAILABLE = False

    converter = SkillConverter()

    # Test 1: Simple YAML
    print("Test 1: Simple YAML (regex fallback)")
    print("-" * 70)
    content1 = """---
name: test-skill
description: This is a test skill
license: MIT
---

Content."""
    result1 = converter.extract_yaml_frontmatter(content1)
    print(f"  Result: {result1}")
    has_name = result1.get('name') == 'test-skill'
    has_desc = 'description' in result1
    has_license = result1.get('license') == 'MIT'
    print(f"  Has name: {has_name}")
    print(f"  Has description: {has_desc}")
    print(f"  Has license: {has_license}")
    print(f"  Status: {'PASS' if has_name and has_desc and has_license else 'FAIL'}")
    print()

    # Test 2: YAML with quoted values
    print("Test 2: YAML with quoted values (regex fallback)")
    print("-" * 70)
    content2 = """---
name: "test-skill"
description: "This is a test: with colons"
argument-hint: "Optional: hint here"
---

Content."""
    result2 = converter.extract_yaml_frontmatter(content2)
    print(f"  Result: {result2}")
    has_desc = 'description' in result2 and ':' in result2.get('description', '')
    has_hint = 'argument-hint' in result2
    print(f"  Description with colon preserved: {has_desc}")
    print(f"  Has argument-hint: {has_hint}")
    print(f"  Status: {'PASS' if has_desc and has_hint else 'FAIL'}")
    print()

    # Test 3: YAML with varying whitespace
    print("Test 3: YAML with varying whitespace (regex fallback)")
    print("-" * 70)
    content3 = """---
name:test-skill
description:  This is a test
license :MIT
---

Content."""
    result3 = converter.extract_yaml_frontmatter(content3)
    print(f"  Result: {result3}")
    has_name = 'name' in result3
    has_desc = 'description' in result3
    has_license = 'license' in result3
    print(f"  Has name: {has_name}")
    print(f"  Has description: {has_desc}")
    print(f"  Has license: {has_license}")
    print(f"  Status: {'PASS' if has_name and has_desc and has_license else 'FAIL'}")
    print()

    # Restore original setting
    skill_to_command_converter.YAML_AVAILABLE = original_yaml_available
    print()


def test_yaml_fixing():
    """Test YAML fixing functionality."""

    print("=" * 70)
    print("Testing YAML Fixing Functionality")
    print("=" * 70)
    print()

    # Re-enable PyYAML for these tests
    skill_to_command_converter.YAML_AVAILABLE = original_yaml_available

    converter = SkillConverter()

    # Test the _fix_common_yaml_issues method directly
    print("Test 1: Fix values with colons (add quotes)")
    print("-" * 70)
    yaml_broken = """name: test-skill
description: This is a test: it has colons
license: MIT"""
    yaml_fixed = converter._fix_common_yaml_issues(yaml_broken)
    print("  Original:")
    for line in yaml_broken.split('\n'):
        print(f"    {line}")
    print("\n  Fixed:")
    for line in yaml_fixed.split('\n'):
        print(f"    {line}")

    # Try to parse the fixed YAML
    if skill_to_command_converter.YAML_AVAILABLE:
        try:
            import yaml
            parsed = yaml.safe_load(yaml_fixed)
            print(f"\n  Parsed: {parsed}")
            has_colon = ':' in parsed.get('description', '')
            print(f"  Colon preserved in description: {has_colon}")
            print(f"  Status: {'PASS' if has_colon else 'FAIL'}")
        except Exception as e:
            print(f"  Parse error: {e}")
            print(f"  Status: FAIL")
    print()

    # Test 2: Fix missing spaces after colons
    print("Test 2: Fix missing spaces after colons")
    print("-" * 70)
    yaml_broken2 = """name:test-skill
description:This is a test
license:MIT"""
    yaml_fixed2 = converter._fix_common_yaml_issues(yaml_broken2)
    print("  Original:")
    for line in yaml_broken2.split('\n'):
        print(f"    {line}")
    print("\n  Fixed:")
    for line in yaml_fixed2.split('\n'):
        print(f"    {line}")

    # Try to parse
    if skill_to_command_converter.YAML_AVAILABLE:
        try:
            import yaml
            parsed2 = yaml.safe_load(yaml_fixed2)
            print(f"\n  Parsed: {parsed2}")
            all_present = 'name' in parsed2 and 'description' in parsed2 and 'license' in parsed2
            print(f"  All fields present: {all_present}")
            print(f"  Status: {'PASS' if all_present else 'FAIL'}")
        except Exception as e:
            print(f"  Parse error: {e}")
            print(f"  Status: FAIL")
    print()


def test_multiline_values():
    """Test YAML with multiline values (real-world case)."""

    print("=" * 70)
    print("Testing Multiline YAML Values")
    print("=" * 70)
    print()

    converter = SkillConverter()

    # Test with a long description (real-world case from SKILL.md files)
    print("Test: Long description value")
    print("-" * 70)
    content = """---
name: algorithmic-art
description: Creating algorithmic art using p5.js with seeded randomness and interactive parameter exploration. Use this when users request creating art using code, generative art, algorithmic art, flow fields, or particle systems.
license: MIT
---

Content."""

    result = converter.extract_yaml_frontmatter(content)
    print(f"  Extracted {len(result)} fields")
    for key, value in result.items():
        display_value = value if len(value) <= 60 else f"{value[:57]}..."
        print(f"    {key}: {display_value}")

    has_long_desc = 'description' in result and len(result['description']) > 50
    print(f"\n  Long description preserved: {has_long_desc}")
    print(f"  Status: {'PASS' if has_long_desc else 'FAIL'}")
    print()


if __name__ == "__main__":
    test_regex_fallback()
    test_yaml_fixing()
    test_multiline_values()

    print("=" * 70)
    print("All Tests Complete")
    print("=" * 70)
