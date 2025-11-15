#!/usr/bin/env python3
"""
Verify that scripts directories are being excluded.
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter

def test_scripts_exclusion():
    """Test that scripts directories are excluded."""

    print("TESTING SCRIPTS DIRECTORY EXCLUSION")
    print("=" * 70)

    converter = SkillConverter()
    skills = converter.discover_skills()

    # Check skills that have scripts directories
    skills_with_scripts = ['skill-creator', 'pptx', 'artifacts-builder', 'docx', 'webapp-testing', 'mcp-builder', 'pdf']

    for skill_name in skills_with_scripts:
        skill_dir = next((s for s in skills if s.name == skill_name), None)
        if not skill_dir:
            continue

        print(f"\n{skill_name}:")

        # Check if scripts directory exists
        scripts_dir = skill_dir / "scripts"
        if scripts_dir.exists():
            print(f"  ✓ scripts/ directory exists at: {scripts_dir}")

            # List files in scripts directory
            scripts_files = list(scripts_dir.rglob('*'))
            scripts_files = [f for f in scripts_files if f.is_file()]
            print(f"  ✓ scripts/ contains {len(scripts_files)} files")

            # Now check if any were discovered
            files = converter.discover_files(skill_dir)
            all_files = files['markdown'] + files['code'] + files['config'] + files['other']

            # Check if any files are from scripts directory
            scripts_discovered = [f for f in all_files if 'scripts' in f.parts]

            if scripts_discovered:
                print(f"  ✗ FAILED - Found {len(scripts_discovered)} files from scripts/ directory:")
                for f in scripts_discovered[:5]:
                    print(f"      - {f.relative_to(skill_dir)}")
            else:
                print(f"  ✓ PASSED - No files from scripts/ directory discovered")

    print("\n" + "=" * 70)

if __name__ == "__main__":
    test_scripts_exclusion()
