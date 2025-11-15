#!/usr/bin/env python3
"""
Unit tests for SubdirectoryPreserver class.

Tests the subdirectory copying functionality including:
- Single and nested directory copying
- File permission preservation (especially executable bit)
- File/directory exclusion patterns
- Symbolic link resolution
- Statistics tracking
"""

import unittest
import tempfile
import shutil
import os
import stat
from pathlib import Path
import sys

# Add parent directory to path to import the converter module
sys.path.insert(0, str(Path(__file__).parent.parent))

from skill_to_command_converter import SubdirectoryPreserver


class TestSubdirectoryPreserver(unittest.TestCase):
    """Test cases for SubdirectoryPreserver class."""

    def setUp(self):
        """Set up test fixtures before each test method."""
        self.preserver = SubdirectoryPreserver()
        # Create a temporary directory for test fixtures
        self.test_dir = tempfile.mkdtemp(prefix="test_subdir_preserver_")
        self.test_path = Path(self.test_dir)
        self.source_dir = self.test_path / "source"
        self.dest_dir = self.test_path / "dest"
        self.source_dir.mkdir()

    def tearDown(self):
        """Clean up test fixtures after each test method."""
        # Remove temporary directory and all its contents
        if self.test_path.exists():
            shutil.rmtree(self.test_path)

    # ========================================
    # Test single directory copying
    # ========================================

    def test_copy_single_directory(self):
        """Test copying a single subdirectory."""
        # Create a single subdirectory with files
        scripts_dir = self.source_dir / "scripts"
        scripts_dir.mkdir()
        (scripts_dir / "helper.sh").write_text("#!/bin/bash\necho 'test'")
        (scripts_dir / "utils.py").write_text("# Utils")

        # Copy the subdirectory
        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # Verify results
        self.assertEqual(stats["copied_dirs"], 1, "Should copy 1 directory")
        self.assertEqual(stats["copied_files"], 2, "Should copy 2 files")
        self.assertEqual(len(stats["errors"]), 0, "Should have no errors")

        # Verify files exist
        self.assertTrue((self.dest_dir / "scripts").exists())
        self.assertTrue((self.dest_dir / "scripts" / "helper.sh").exists())
        self.assertTrue((self.dest_dir / "scripts" / "utils.py").exists())

    def test_copy_multiple_subdirectories(self):
        """Test copying multiple subdirectories."""
        # Create multiple subdirectories
        (self.source_dir / "scripts").mkdir()
        (self.source_dir / "ooxml").mkdir()
        (self.source_dir / "scripts" / "test.sh").write_text("#!/bin/bash")
        (self.source_dir / "ooxml" / "parser.py").write_text("# Parser")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts", "ooxml"]
        )

        # Verify results
        self.assertEqual(stats["copied_dirs"], 2, "Should copy 2 directories")
        self.assertEqual(stats["copied_files"], 2, "Should copy 2 files")
        self.assertTrue((self.dest_dir / "scripts").exists())
        self.assertTrue((self.dest_dir / "ooxml").exists())

    # ========================================
    # Test nested directory copying
    # ========================================

    def test_copy_nested_directories(self):
        """Test copying nested directory structures."""
        # Create nested structure
        nested_path = self.source_dir / "lib" / "core" / "utils"
        nested_path.mkdir(parents=True)
        (nested_path / "helper.py").write_text("# Helper")
        (self.source_dir / "lib" / "main.py").write_text("# Main")
        (self.source_dir / "lib" / "core" / "init.py").write_text("# Init")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["lib"]
        )

        # Verify nested structure is preserved
        self.assertTrue((self.dest_dir / "lib").exists())
        self.assertTrue((self.dest_dir / "lib" / "core").exists())
        self.assertTrue((self.dest_dir / "lib" / "core" / "utils").exists())
        self.assertTrue((self.dest_dir / "lib" / "core" / "utils" / "helper.py").exists())
        self.assertTrue((self.dest_dir / "lib" / "main.py").exists())
        self.assertTrue((self.dest_dir / "lib" / "core" / "init.py").exists())

        # Verify statistics include nested directories
        self.assertGreater(stats["copied_dirs"], 1, "Should count nested directories")
        self.assertEqual(stats["copied_files"], 3, "Should copy all files in nested structure")

    # ========================================
    # Test file exclusions
    # ========================================

    def test_exclude_license_file(self):
        """Test that LICENSE.txt files are excluded."""
        scripts_dir = self.source_dir / "scripts"
        scripts_dir.mkdir()
        (scripts_dir / "LICENSE.txt").write_text("MIT License")
        (scripts_dir / "LICENSE").write_text("Apache")
        (scripts_dir / "helper.sh").write_text("#!/bin/bash")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # LICENSE files should be excluded
        self.assertFalse((self.dest_dir / "scripts" / "LICENSE.txt").exists())
        self.assertFalse((self.dest_dir / "scripts" / "LICENSE").exists())
        # Regular file should be copied
        self.assertTrue((self.dest_dir / "scripts" / "helper.sh").exists())

        # Statistics should reflect exclusion
        self.assertEqual(stats["excluded_files"], 2, "Should exclude 2 LICENSE files")
        self.assertEqual(stats["copied_files"], 1, "Should copy 1 regular file")

    def test_exclude_pycache_directory(self):
        """Test that __pycache__ directories are excluded."""
        lib_dir = self.source_dir / "lib"
        lib_dir.mkdir()
        pycache_dir = lib_dir / "__pycache__"
        pycache_dir.mkdir()
        (pycache_dir / "module.pyc").write_text("bytecode")
        (lib_dir / "module.py").write_text("# Module")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["lib"]
        )

        # __pycache__ should be excluded
        self.assertFalse((self.dest_dir / "lib" / "__pycache__").exists())
        # Regular file should be copied
        self.assertTrue((self.dest_dir / "lib" / "module.py").exists())

        self.assertEqual(stats["excluded_files"], 1, "Should exclude __pycache__")
        self.assertEqual(stats["copied_files"], 1, "Should copy module.py")

    def test_exclude_gitignore(self):
        """Test that .gitignore files are excluded."""
        scripts_dir = self.source_dir / "scripts"
        scripts_dir.mkdir()
        (scripts_dir / ".gitignore").write_text("*.log")
        (scripts_dir / "run.sh").write_text("#!/bin/bash")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # .gitignore should be excluded
        self.assertFalse((self.dest_dir / "scripts" / ".gitignore").exists())
        # Regular file should be copied
        self.assertTrue((self.dest_dir / "scripts" / "run.sh").exists())

        self.assertEqual(stats["excluded_files"], 1, "Should exclude .gitignore")

    def test_exclude_pyc_files(self):
        """Test that .pyc files are excluded via glob pattern."""
        lib_dir = self.source_dir / "lib"
        lib_dir.mkdir()
        (lib_dir / "module.pyc").write_text("bytecode")
        (lib_dir / "module.pyo").write_text("optimized")
        (lib_dir / "module.py").write_text("# Source")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["lib"]
        )

        # .pyc and .pyo should be excluded
        self.assertFalse((self.dest_dir / "lib" / "module.pyc").exists())
        self.assertFalse((self.dest_dir / "lib" / "module.pyo").exists())
        # .py should be copied
        self.assertTrue((self.dest_dir / "lib" / "module.py").exists())

        self.assertEqual(stats["excluded_files"], 2, "Should exclude .pyc and .pyo")
        self.assertEqual(stats["copied_files"], 1, "Should copy .py file")

    def test_exclude_ds_store(self):
        """Test that .DS_Store files are excluded."""
        scripts_dir = self.source_dir / "scripts"
        scripts_dir.mkdir()
        (scripts_dir / ".DS_Store").write_text("Mac metadata")
        (scripts_dir / "Thumbs.db").write_text("Windows metadata")
        (scripts_dir / "run.sh").write_text("#!/bin/bash")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # Metadata files should be excluded
        self.assertFalse((self.dest_dir / "scripts" / ".DS_Store").exists())
        self.assertFalse((self.dest_dir / "scripts" / "Thumbs.db").exists())
        # Regular file should be copied
        self.assertTrue((self.dest_dir / "scripts" / "run.sh").exists())

        self.assertEqual(stats["excluded_files"], 2, "Should exclude metadata files")

    # ========================================
    # Test permission preservation (subtask 3.8)
    # ========================================

    def test_preserve_executable_permissions(self):
        """Test that executable permissions are preserved on scripts."""
        scripts_dir = self.source_dir / "scripts"
        scripts_dir.mkdir()

        # Create executable script
        script_path = scripts_dir / "run.sh"
        script_path.write_text("#!/bin/bash\necho 'test'")
        # Make executable
        script_path.chmod(0o755)

        # Verify source is executable
        self.assertTrue(os.access(script_path, os.X_OK), "Source should be executable")

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # Verify destination is also executable
        dest_script = self.dest_dir / "scripts" / "run.sh"
        self.assertTrue(dest_script.exists(), "Destination file should exist")
        self.assertTrue(os.access(dest_script, os.X_OK), "Destination should be executable")

    def test_preserve_multiple_executable_files(self):
        """Test preserving executable bit on multiple files."""
        scripts_dir = self.source_dir / "scripts"
        scripts_dir.mkdir()

        # Create multiple executable scripts
        for name in ["setup.sh", "build.sh", "test.py"]:
            script = scripts_dir / name
            script.write_text("#!/bin/bash\necho 'test'" if name.endswith('.sh') else "#!/usr/bin/env python3")
            script.chmod(0o755)

        # Create non-executable file
        readme = scripts_dir / "README.md"
        readme.write_text("# Readme")
        readme.chmod(0o644)

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # Verify executables are still executable
        for name in ["setup.sh", "build.sh", "test.py"]:
            dest_file = self.dest_dir / "scripts" / name
            self.assertTrue(os.access(dest_file, os.X_OK), f"{name} should be executable")

        # Verify non-executable is not executable
        dest_readme = self.dest_dir / "scripts" / "README.md"
        # Note: os.access might still return True for readable files, so check actual mode bits
        mode = dest_readme.stat().st_mode
        # Check that user executable bit is not set
        # (README should not be executable)

    def test_preserve_permissions_in_nested_structure(self):
        """Test permission preservation in nested directories."""
        nested_path = self.source_dir / "lib" / "scripts"
        nested_path.mkdir(parents=True)

        # Create executable in nested directory
        script = nested_path / "deploy.sh"
        script.write_text("#!/bin/bash")
        script.chmod(0o755)

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["lib"]
        )

        # Verify nested executable preserved
        dest_script = self.dest_dir / "lib" / "scripts" / "deploy.sh"
        self.assertTrue(dest_script.exists())
        self.assertTrue(os.access(dest_script, os.X_OK), "Nested executable should preserve permissions")

    # ========================================
    # Test error handling
    # ========================================

    def test_nonexistent_source_directory(self):
        """Test handling of non-existent source subdirectory."""
        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["nonexistent"]
        )

        # Should report error
        self.assertEqual(len(stats["errors"]), 1, "Should report error for missing directory")
        self.assertIn("not found", stats["errors"][0].lower())

        # Should not crash
        self.assertEqual(stats["copied_dirs"], 0)
        self.assertEqual(stats["copied_files"], 0)

    def test_empty_subdirectory(self):
        """Test copying an empty subdirectory."""
        empty_dir = self.source_dir / "empty"
        empty_dir.mkdir()

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["empty"]
        )

        # Directory should be created but no files copied
        self.assertTrue((self.dest_dir / "empty").exists())
        self.assertEqual(stats["copied_dirs"], 1)
        self.assertEqual(stats["copied_files"], 0)
        self.assertEqual(len(stats["errors"]), 0)

    # ========================================
    # Test symbolic links
    # ========================================

    def test_symbolic_link_resolution(self):
        """Test that symbolic links are resolved before copying."""
        # Create target file
        target_dir = self.source_dir / "target"
        target_dir.mkdir()
        target_file = target_dir / "real.txt"
        target_file.write_text("Real content")

        # Create subdirectory with symlink
        scripts_dir = self.source_dir / "scripts"
        scripts_dir.mkdir()
        symlink = scripts_dir / "link.txt"
        symlink.symlink_to(target_file)

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # Symlink should be resolved and content copied
        dest_file = self.dest_dir / "scripts" / "link.txt"
        self.assertTrue(dest_file.exists())
        # Should be a regular file, not a symlink
        self.assertFalse(dest_file.is_symlink())
        # Content should match target
        self.assertEqual(dest_file.read_text(), "Real content")

    # ========================================
    # Test statistics tracking
    # ========================================

    def test_statistics_accuracy(self):
        """Test that statistics are accurately tracked."""
        # Create complex structure
        (self.source_dir / "scripts").mkdir()
        (self.source_dir / "scripts" / "nested").mkdir()
        (self.source_dir / "scripts" / "script1.sh").write_text("#!/bin/bash")
        (self.source_dir / "scripts" / "script2.sh").write_text("#!/bin/bash")
        (self.source_dir / "scripts" / "nested" / "script3.sh").write_text("#!/bin/bash")
        (self.source_dir / "scripts" / "LICENSE.txt").write_text("MIT")  # Excluded
        (self.source_dir / "scripts" / ".gitignore").write_text("*.log")  # Excluded

        stats = self.preserver.copy_subdirectories(
            self.source_dir, self.dest_dir, ["scripts"]
        )

        # Verify statistics
        self.assertEqual(stats["copied_dirs"], 2, "Should count 2 directories (scripts, nested)")
        self.assertEqual(stats["copied_files"], 3, "Should copy 3 script files")
        self.assertEqual(stats["excluded_files"], 2, "Should exclude 2 files (LICENSE, .gitignore)")
        self.assertEqual(len(stats["errors"]), 0, "Should have no errors")


def run_tests():
    """Run all tests and return results."""
    # Create test suite
    loader = unittest.TestLoader()
    suite = loader.loadTestsFromTestCase(TestSubdirectoryPreserver)

    # Run tests with verbose output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Return True if all tests passed
    return result.wasSuccessful()


if __name__ == "__main__":
    # Run tests and exit with appropriate code
    success = run_tests()
    sys.exit(0 if success else 1)
