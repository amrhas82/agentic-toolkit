#!/usr/bin/env python3
"""
Unit tests for MarkdownMerger class.

Tests the markdown merging functionality including:
- Merging 1, 2, and 5+ markdown files
- YAML frontmatter preservation and stripping
- Section header creation
- Alphabetical sorting
- Edge cases (no primary file, empty files, no frontmatter)
"""

import unittest
import tempfile
import shutil
from pathlib import Path
import sys

# Add parent directory to path to import the converter module
sys.path.insert(0, str(Path(__file__).parent.parent))

from skill_to_command_converter import MarkdownMerger


class TestMarkdownMerger(unittest.TestCase):
    """Test cases for MarkdownMerger class."""

    def setUp(self):
        """Set up test fixtures before each test method."""
        self.merger = MarkdownMerger()
        # Create a temporary directory for test fixtures
        self.test_dir = tempfile.mkdtemp(prefix="test_markdown_merger_")
        self.test_path = Path(self.test_dir)

    def tearDown(self):
        """Clean up test fixtures after each test method."""
        # Remove temporary directory and all its contents
        if self.test_path.exists():
            shutil.rmtree(self.test_path)

    # ========================================
    # Test merging 1 file (primary only)
    # ========================================

    def test_merge_single_file_with_frontmatter(self):
        """Test merging a single file (primary only) with frontmatter."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("""---
title: Test Skill
description: A simple skill
---

# Test Skill

This is the main content.
""")

        result = self.merger.merge_markdown_files(skill_md, [])

        # Should preserve frontmatter and content
        self.assertIn("---", result)
        self.assertIn("title: Test Skill", result)
        self.assertIn("# Test Skill", result)
        self.assertIn("This is the main content", result)

    def test_merge_single_file_without_frontmatter(self):
        """Test merging a single file without frontmatter."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("""# Test Skill

This is the main content without frontmatter.
""")

        result = self.merger.merge_markdown_files(skill_md, [])

        # Should contain content but no frontmatter
        self.assertNotIn("---", result)
        self.assertIn("# Test Skill", result)
        self.assertIn("This is the main content", result)

    # ========================================
    # Test merging 2 files (primary + 1 secondary)
    # ========================================

    def test_merge_two_files(self):
        """Test merging primary file with one secondary file."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("""---
title: Main Skill
---

# Main Content

Primary file content.
""")

        readme = self.test_path / "README.md"
        readme.write_text("""---
title: Readme
---

# Installation

Install instructions here.
""")

        result = self.merger.merge_markdown_files(skill_md, [readme])

        # Should have primary frontmatter
        self.assertIn("title: Main Skill", result)
        self.assertNotIn("title: Readme", result)  # Secondary frontmatter stripped

        # Should have both contents
        self.assertIn("Primary file content", result)
        self.assertIn("Install instructions here", result)

        # Should have section header for secondary file
        self.assertIn("## Readme", result)

    def test_merge_preserves_alphabetical_order(self):
        """Test that secondary files are merged in alphabetical order."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("# Main\n\nPrimary content.")

        zebra = self.test_path / "zebra.md"
        zebra.write_text("# Zebra\n\nZ content.")

        apple = self.test_path / "apple.md"
        apple.write_text("# Apple\n\nA content.")

        result = self.merger.merge_markdown_files(skill_md, [zebra, apple])

        # Apple should come before Zebra (alphabetical)
        apple_index = result.index("## Apple")
        zebra_index = result.index("## Zebra")

        self.assertLess(apple_index, zebra_index,
                       "Secondary files should be in alphabetical order")

    # ========================================
    # Test merging 5+ files
    # ========================================

    def test_merge_multiple_files(self):
        """Test merging primary with 5+ secondary files."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("""---
title: Multi-file Skill
---

# Main Skill

Primary content.
""")

        # Create 6 secondary files
        secondary_files = []
        for i, name in enumerate(["api.md", "install.md", "guide.md", "faq.md", "examples.md", "troubleshooting.md"]):
            file_path = self.test_path / name
            file_path.write_text(f"# {name}\n\nContent {i}")
            secondary_files.append(file_path)

        result = self.merger.merge_markdown_files(skill_md, secondary_files)

        # Should have primary frontmatter
        self.assertIn("title: Multi-file Skill", result)

        # Should have all section headers (in alphabetical order)
        self.assertIn("## API", result)
        self.assertIn("## Examples", result)
        self.assertIn("## Faq", result)
        self.assertIn("## Guide", result)
        self.assertIn("## Install", result)
        self.assertIn("## Troubleshooting", result)

        # Check alphabetical order
        indices = [
            result.index("## API"),
            result.index("## Examples"),
            result.index("## Faq"),
            result.index("## Guide"),
            result.index("## Install"),
            result.index("## Troubleshooting"),
        ]

        self.assertEqual(indices, sorted(indices),
                        "Sections should be in alphabetical order")

    # ========================================
    # Test edge cases (subtask 2.8)
    # ========================================

    def test_merge_no_primary_file(self):
        """Test merging when primary file (SKILL.md) doesn't exist."""
        readme = self.test_path / "README.md"
        readme.write_text("# Readme\n\nSome content.")

        guide = self.test_path / "guide.md"
        guide.write_text("# Guide\n\nGuide content.")

        # Primary file is None
        result = self.merger.merge_markdown_files(None, [readme, guide])

        # Should still merge secondary files
        self.assertIn("## Guide", result)
        self.assertIn("## Readme", result)
        self.assertIn("Guide content", result)

        # Should not have frontmatter (no primary file)
        self.assertNotIn("---", result)

    def test_merge_nonexistent_primary_file(self):
        """Test merging when primary file path doesn't exist."""
        nonexistent = self.test_path / "nonexistent.md"

        readme = self.test_path / "README.md"
        readme.write_text("# Readme\n\nSome content.")

        result = self.merger.merge_markdown_files(nonexistent, [readme])

        # Should still merge secondary files
        self.assertIn("## Readme", result)
        self.assertIn("Some content", result)

    def test_merge_empty_primary_file(self):
        """Test merging when primary file is empty."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("")

        readme = self.test_path / "README.md"
        readme.write_text("# Readme\n\nSome content.")

        result = self.merger.merge_markdown_files(skill_md, [readme])

        # Should still have secondary content
        self.assertIn("## Readme", result)
        self.assertIn("Some content", result)

    def test_merge_empty_secondary_file(self):
        """Test that empty secondary files are skipped."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("# Main\n\nPrimary content.")

        empty = self.test_path / "empty.md"
        empty.write_text("")

        readme = self.test_path / "README.md"
        readme.write_text("# Readme\n\nSome content.")

        result = self.merger.merge_markdown_files(skill_md, [empty, readme])

        # Should skip empty file
        self.assertNotIn("## Empty", result)

        # Should have readme
        self.assertIn("## Readme", result)

    def test_merge_secondary_file_only_frontmatter(self):
        """Test secondary file with only frontmatter (no content)."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("# Main\n\nPrimary content.")

        frontmatter_only = self.test_path / "meta.md"
        frontmatter_only.write_text("""---
title: Metadata
---
""")

        result = self.merger.merge_markdown_files(skill_md, [frontmatter_only])

        # Should skip file with no content after frontmatter strip
        self.assertNotIn("## Meta", result)

    def test_merge_files_without_frontmatter(self):
        """Test merging files that have no frontmatter."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("# Main\n\nNo frontmatter here.")

        readme = self.test_path / "README.md"
        readme.write_text("# Readme\n\nAlso no frontmatter.")

        result = self.merger.merge_markdown_files(skill_md, [readme])

        # Should not have any frontmatter in result
        self.assertNotIn("---", result)

        # Should have both contents
        self.assertIn("No frontmatter here", result)
        self.assertIn("Also no frontmatter", result)
        self.assertIn("## Readme", result)

    def test_merge_no_files(self):
        """Test merging with no files at all."""
        result = self.merger.merge_markdown_files(None, [])

        # Should return empty string
        self.assertEqual(result, "")

    # ========================================
    # Test frontmatter handling
    # ========================================

    def test_frontmatter_with_colon_in_value(self):
        """Test that frontmatter values with colons are properly quoted."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("""---
title: "API: Reference Guide"
description: Shows API usage
---

# API Reference

Content here.
""")

        result = self.merger.merge_markdown_files(skill_md, [])

        # Should preserve frontmatter with quoted value
        self.assertIn("---", result)
        self.assertIn('title: "API: Reference Guide"', result)

    def test_duplicate_frontmatter_prevention(self):
        """Test that secondary file frontmatter is stripped (no duplicates)."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("""---
title: Main Skill
author: Alice
---

# Main

Primary content.
""")

        readme = self.test_path / "README.md"
        readme.write_text("""---
title: Readme
author: Bob
---

# Readme

Secondary content.
""")

        result = self.merger.merge_markdown_files(skill_md, [readme])

        # Should only have ONE frontmatter block (from primary)
        frontmatter_count = result.count("---")
        self.assertEqual(frontmatter_count, 2,  # Opening and closing ---
                        "Should only have one frontmatter block")

        # Should have primary author, not secondary
        self.assertIn("author: Alice", result)
        self.assertNotIn("author: Bob", result)

    # ========================================
    # Test section header creation
    # ========================================

    def test_section_header_formatting(self):
        """Test that section headers are properly formatted."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("# Main\n\nPrimary.")

        api_ref = self.test_path / "api-reference.md"
        api_ref.write_text("# API\n\nAPI content.")

        install_guide = self.test_path / "install_guide.md"
        install_guide.write_text("# Install\n\nInstall content.")

        result = self.merger.merge_markdown_files(skill_md, [api_ref, install_guide])

        # Should have properly formatted headers
        self.assertIn("## API Reference", result)  # Hyphen -> space, titlecase
        self.assertIn("## Install Guide", result)  # Underscore -> space, titlecase

    # ========================================
    # Test content separation
    # ========================================

    def test_sections_separated_by_blank_lines(self):
        """Test that sections are separated by blank lines."""
        skill_md = self.test_path / "SKILL.md"
        skill_md.write_text("# Main\n\nPrimary content.")

        readme = self.test_path / "README.md"
        readme.write_text("# Readme\n\nReadme content.")

        result = self.merger.merge_markdown_files(skill_md, [readme])

        # Sections should be separated by double newlines
        self.assertIn("\n\n## Readme\n\n", result)


def run_tests():
    """Run all tests and return results."""
    # Create test suite
    loader = unittest.TestLoader()
    suite = loader.loadTestsFromTestCase(TestMarkdownMerger)

    # Run tests with verbose output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Return True if all tests passed
    return result.wasSuccessful()


if __name__ == "__main__":
    # Run tests and exit with appropriate code
    success = run_tests()
    sys.exit(0 if success else 1)
