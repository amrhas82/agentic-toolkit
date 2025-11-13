#!/usr/bin/env python3
"""
Unit tests for PathUpdater class.

Tests the script relocation and path update functionality including:
- Script relocation with permission preservation
- Path detection in markdown (./script.sh, ../script.sh, script.sh)
- Path replacement (./ → ./{skill-name}/)
- Code block preservation (paths in examples not updated)
- Relative vs absolute path handling
"""

import unittest
import tempfile
import shutil
import os
from pathlib import Path
import sys

# Add parent directory to path to import the converter module
sys.path.insert(0, str(Path(__file__).parent.parent))

from skill_to_command_converter import PathUpdater


class TestPathUpdater(unittest.TestCase):
    """Test cases for PathUpdater class."""

    def setUp(self):
        """Set up test fixtures before each test method."""
        self.updater = PathUpdater()
        # Create a temporary directory for test fixtures
        self.test_dir = tempfile.mkdtemp(prefix="test_path_updater_")
        self.test_path = Path(self.test_dir)
        self.source_dir = self.test_path / "source"
        self.dest_dir = self.test_path / "dest"
        self.source_dir.mkdir()
        self.dest_dir.mkdir()

    def tearDown(self):
        """Clean up test fixtures after each test method."""
        # Remove temporary directory and all its contents
        if self.test_path.exists():
            shutil.rmtree(self.test_path)

    # ========================================
    # Test script relocation
    # ========================================

    def test_relocate_single_script(self):
        """Test relocating a single script file."""
        # Create test script
        script = self.source_dir / "setup.sh"
        script.write_text("#!/bin/bash\necho 'setup'")
        script.chmod(0o755)

        # Relocate
        stats = self.updater.relocate_scripts(
            self.source_dir, self.dest_dir, "test-skill", [script]
        )

        # Verify
        self.assertEqual(stats["relocated_count"], 1)
        self.assertEqual(len(stats["errors"]), 0)
        self.assertTrue((self.dest_dir / "test-skill" / "setup.sh").exists())

    def test_relocate_multiple_scripts(self):
        """Test relocating multiple script files."""
        # Create test scripts
        setup_sh = self.source_dir / "setup.sh"
        analyze_py = self.source_dir / "analyze.py"
        setup_sh.write_text("#!/bin/bash")
        analyze_py.write_text("#!/usr/bin/env python3")

        # Relocate
        stats = self.updater.relocate_scripts(
            self.source_dir, self.dest_dir, "my-skill", [setup_sh, analyze_py]
        )

        # Verify
        self.assertEqual(stats["relocated_count"], 2)
        self.assertTrue((self.dest_dir / "my-skill" / "setup.sh").exists())
        self.assertTrue((self.dest_dir / "my-skill" / "analyze.py").exists())

    def test_relocate_preserves_permissions(self):
        """Test that script relocation preserves executable permissions."""
        # Create executable script
        script = self.source_dir / "run.sh"
        script.write_text("#!/bin/bash")
        script.chmod(0o755)

        # Verify source is executable
        self.assertTrue(os.access(script, os.X_OK))

        # Relocate
        stats = self.updater.relocate_scripts(
            self.source_dir, self.dest_dir, "skill", [script]
        )

        # Verify destination is also executable
        dest_script = self.dest_dir / "skill" / "run.sh"
        self.assertTrue(dest_script.exists())
        self.assertTrue(os.access(dest_script, os.X_OK))

    def test_relocate_nonexistent_script(self):
        """Test handling of non-existent script file."""
        nonexistent = self.source_dir / "missing.sh"

        stats = self.updater.relocate_scripts(
            self.source_dir, self.dest_dir, "skill", [nonexistent]
        )

        # Should report error
        self.assertEqual(stats["relocated_count"], 0)
        self.assertEqual(len(stats["errors"]), 1)
        self.assertIn("missing.sh", stats["errors"][0])

    # ========================================
    # Test path detection (subtask 4.8)
    # ========================================

    def test_find_paths_with_dot_slash(self):
        """Test finding paths with ./ prefix."""
        content = """
        Run the script with:
        ./setup.sh

        And then:
        ./analyze.py
        """

        paths = self.updater._find_script_paths(content, ["setup.sh", "analyze.py"])

        # Should find both paths
        self.assertEqual(len(paths), 2)
        path_strings = [p[0] for p in paths]
        self.assertIn("./setup.sh", path_strings)
        self.assertIn("./analyze.py", path_strings)

    def test_find_paths_without_prefix(self):
        """Test finding bare filenames without ./ prefix."""
        content = """
        Execute setup.sh first
        Then run analyze.py
        """

        paths = self.updater._find_script_paths(content, ["setup.sh", "analyze.py"])

        # Should find both bare filenames
        self.assertEqual(len(paths), 2)
        path_strings = [p[0] for p in paths]
        self.assertIn("setup.sh", path_strings)
        self.assertIn("analyze.py", path_strings)

    def test_find_paths_mixed_formats(self):
        """Test finding paths in mixed formats."""
        content = """
        ./setup.sh
        ../helper.py
        script.sh
        """

        paths = self.updater._find_script_paths(content, ["setup.sh", "helper.py", "script.sh"])

        # Should find all three
        self.assertEqual(len(paths), 3)
        path_strings = [p[0] for p in paths]
        self.assertIn("./setup.sh", path_strings)
        self.assertIn("../helper.py", path_strings)
        self.assertIn("script.sh", path_strings)

    def test_find_no_paths(self):
        """Test finding no paths when scripts not referenced."""
        content = """
        This content has no script references.
        Just regular text.
        """

        paths = self.updater._find_script_paths(content, ["setup.sh"])

        # Should find nothing
        self.assertEqual(len(paths), 0)

    # ========================================
    # Test path replacement (subtask 4.8)
    # ========================================

    def test_replace_dot_slash_path(self):
        """Test replacing ./script.sh format."""
        result = self.updater._replace_path("./setup.sh", "my-skill")
        self.assertEqual(result, "./my-skill/setup.sh")

    def test_replace_dot_dot_slash_path(self):
        """Test replacing ../script.sh format."""
        result = self.updater._replace_path("../helper.py", "my-skill")
        self.assertEqual(result, "./my-skill/helper.py")

    def test_replace_bare_filename(self):
        """Test replacing bare filename."""
        result = self.updater._replace_path("script.sh", "my-skill")
        self.assertEqual(result, "my-skill/script.sh")

    # ========================================
    # Test code block preservation (subtask 4.7, 4.8)
    # ========================================

    def test_is_in_code_block_true(self):
        """Test detecting position inside code block."""
        content = """Some text

```bash
./setup.sh
```

More text"""

        # Find position of "./setup.sh" inside code block
        pos = content.index("./setup.sh")

        # Should detect it's in code block
        self.assertTrue(self.updater._is_in_code_block(content, pos))

    def test_is_in_code_block_false(self):
        """Test detecting position outside code block."""
        content = """Some text

./setup.sh

```bash
# code here
```"""

        # Find position of "./setup.sh" outside code block
        pos = content.index("./setup.sh")

        # Should detect it's NOT in code block
        self.assertFalse(self.updater._is_in_code_block(content, pos))

    def test_update_paths_preserves_code_blocks(self):
        """Test that paths in code blocks are not updated."""
        content = """Run the script:

./setup.sh

Example usage:
```bash
./setup.sh --help
```

The script is at ./setup.sh"""

        updated, count = self.updater.update_paths_in_markdown(
            content, "my-skill", ["setup.sh"]
        )

        # Should update 2 paths (not the one in code block)
        self.assertEqual(count, 2)

        # Code block should still have original path
        self.assertIn("```bash\n./setup.sh --help\n```", updated)

        # Other paths should be updated
        self.assertIn("./my-skill/setup.sh", updated)

    # ========================================
    # Test full path update workflow
    # ========================================

    def test_update_single_path(self):
        """Test updating a single path reference."""
        content = "Run ./setup.sh to begin"

        updated, count = self.updater.update_paths_in_markdown(
            content, "test-skill", ["setup.sh"]
        )

        self.assertEqual(count, 1)
        self.assertIn("./test-skill/setup.sh", updated)
        self.assertNotIn("./setup.sh", updated)

    def test_update_multiple_paths(self):
        """Test updating multiple path references."""
        content = """
        ./setup.sh
        ./analyze.py
        ./cleanup.sh
        """

        updated, count = self.updater.update_paths_in_markdown(
            content, "my-skill", ["setup.sh", "analyze.py", "cleanup.sh"]
        )

        self.assertEqual(count, 3)
        self.assertIn("./my-skill/setup.sh", updated)
        self.assertIn("./my-skill/analyze.py", updated)
        self.assertIn("./my-skill/cleanup.sh", updated)

    def test_update_paths_mixed_formats(self):
        """Test updating paths in mixed formats."""
        content = """
        ./setup.sh
        analyze.py
        ../helper.sh
        """

        updated, count = self.updater.update_paths_in_markdown(
            content, "skill", ["setup.sh", "analyze.py", "helper.sh"]
        )

        self.assertEqual(count, 3)
        self.assertIn("./skill/setup.sh", updated)
        self.assertIn("skill/analyze.py", updated)
        self.assertIn("./skill/helper.sh", updated)  # ../ normalized to ./

    def test_update_no_matching_scripts(self):
        """Test updating when no matching scripts found."""
        content = "Some text with no scripts"

        updated, count = self.updater.update_paths_in_markdown(
            content, "skill", ["setup.sh"]
        )

        # No updates
        self.assertEqual(count, 0)
        self.assertEqual(updated, content)

    # ========================================
    # Test relative vs absolute path handling (subtask 4.9)
    # ========================================

    def test_relocate_with_relative_paths(self):
        """Test relocation using relative paths."""
        script = self.source_dir / "test.sh"
        script.write_text("#!/bin/bash")

        # Use relative path (Path object, not absolute)
        stats = self.updater.relocate_scripts(
            self.source_dir, self.dest_dir, "skill", [Path("test.sh")]
        )

        # Should still work
        self.assertEqual(stats["relocated_count"], 1)
        self.assertTrue((self.dest_dir / "skill" / "test.sh").exists())

    def test_relocate_with_absolute_paths(self):
        """Test relocation using absolute paths."""
        script = self.source_dir / "test.sh"
        script.write_text("#!/bin/bash")

        # Use absolute path
        stats = self.updater.relocate_scripts(
            self.source_dir, self.dest_dir, "skill", [script.absolute()]
        )

        # Should work
        self.assertEqual(stats["relocated_count"], 1)
        self.assertTrue((self.dest_dir / "skill" / "test.sh").exists())

    def test_update_paths_handles_path_objects(self):
        """Test that update_paths_in_markdown handles Path objects."""
        content = "./setup.sh"

        # Pass Path object instead of string
        updated, count = self.updater.update_paths_in_markdown(
            content, "skill", [Path("setup.sh")]
        )

        self.assertEqual(count, 1)
        self.assertIn("./skill/setup.sh", updated)

    # ========================================
    # Test integration scenario
    # ========================================

    def test_full_relocation_and_update_workflow(self):
        """Test complete workflow: relocate scripts and update markdown paths."""
        # Create scripts
        setup = self.source_dir / "setup.sh"
        analyze = self.source_dir / "analyze.py"
        setup.write_text("#!/bin/bash")
        analyze.write_text("#!/usr/bin/env python3")

        # Create markdown content
        markdown = """# My Skill

## Setup

Run the setup script:

./setup.sh

## Analysis

Then analyze with:

./analyze.py

## Example

```bash
# Example usage
./setup.sh --verbose
./analyze.py --input data.csv
```
"""

        # Step 1: Relocate scripts
        stats = self.updater.relocate_scripts(
            self.source_dir, self.dest_dir, "my-skill", [setup, analyze]
        )

        self.assertEqual(stats["relocated_count"], 2)

        # Step 2: Update paths in markdown
        updated_md, count = self.updater.update_paths_in_markdown(
            markdown, "my-skill", ["setup.sh", "analyze.py"]
        )

        # Should update 2 paths (not the 2 in code block)
        self.assertEqual(count, 2)

        # Verify updates
        self.assertIn("./my-skill/setup.sh", updated_md)
        self.assertIn("./my-skill/analyze.py", updated_md)

        # Code block should be preserved
        self.assertIn("```bash\n# Example usage\n./setup.sh --verbose\n./analyze.py --input data.csv\n```", updated_md)


def run_tests():
    """Run all tests and return results."""
    # Create test suite
    loader = unittest.TestLoader()
    suite = loader.loadTestsFromTestCase(TestPathUpdater)

    # Run tests with verbose output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Return True if all tests passed
    return result.wasSuccessful()


if __name__ == "__main__":
    # Run tests and exit with appropriate code
    success = run_tests()
    sys.exit(0 if success else 1)
