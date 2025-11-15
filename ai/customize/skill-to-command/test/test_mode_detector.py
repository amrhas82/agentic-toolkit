#!/usr/bin/env python3
"""
Unit tests for ModeDetector class.

Tests the mode detection logic for all three transformation modes:
- DIRECTORY_WITH_SUBDIRS: Skills with subdirectories to preserve
- DIRECTORY_WITH_SCRIPTS: Skills with root-level executable scripts
- SINGLE_FILE: Simple skills with only markdown files
"""

import unittest
import tempfile
import shutil
from pathlib import Path
import sys
import os

# Add parent directory to path to import the converter module
sys.path.insert(0, str(Path(__file__).parent.parent))

from skill_to_command_converter import ModeDetector, TransformationMode, MODE_DETECTION_EXCLUDE_DIRS


class TestModeDetector(unittest.TestCase):
    """Test cases for ModeDetector class."""

    def setUp(self):
        """Set up test fixtures before each test method."""
        self.detector = ModeDetector()
        # Create a temporary directory for test fixtures
        self.test_dir = tempfile.mkdtemp(prefix="test_mode_detector_")
        self.test_path = Path(self.test_dir)

    def tearDown(self):
        """Clean up test fixtures after each test method."""
        # Remove temporary directory and all its contents
        if self.test_path.exists():
            shutil.rmtree(self.test_path)

    # ========================================
    # Test DIRECTORY_WITH_SUBDIRS mode
    # ========================================

    def test_mode_detection_with_subdirectories(self):
        """Test detection of DIRECTORY_WITH_SUBDIRS mode - skill with subdirectories."""
        # Create a skill directory with subdirectories
        skill_dir = self.test_path / "test_skill_subdirs"
        skill_dir.mkdir()

        # Create SKILL.md file
        (skill_dir / "SKILL.md").write_text("# Test Skill\n\nThis is a test skill.")

        # Create subdirectories (these should trigger DIRECTORY_WITH_SUBDIRS mode)
        (skill_dir / "scripts").mkdir()
        (skill_dir / "ooxml").mkdir()

        # Create some files in subdirectories
        (skill_dir / "scripts" / "helper.sh").write_text("#!/bin/bash\necho 'helper'")
        (skill_dir / "ooxml" / "parser.py").write_text("# Parser code")

        # Detect mode
        mode = self.detector.detect_mode(skill_dir)

        # Assert DIRECTORY_WITH_SUBDIRS mode was detected
        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SUBDIRS,
                        "Should detect DIRECTORY_WITH_SUBDIRS when subdirectories exist")

    def test_mode_detection_with_single_subdirectory(self):
        """Test detection with just one subdirectory."""
        skill_dir = self.test_path / "test_skill_one_subdir"
        skill_dir.mkdir()

        (skill_dir / "SKILL.md").write_text("# Test Skill")
        (skill_dir / "templates").mkdir()
        (skill_dir / "templates" / "example.txt").write_text("Example")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SUBDIRS,
                        "Should detect DIRECTORY_WITH_SUBDIRS with single subdirectory")

    def test_mode_detection_excludes_special_directories(self):
        """Test that special directories (__pycache__, .git, etc.) are excluded."""
        skill_dir = self.test_path / "test_skill_special_dirs"
        skill_dir.mkdir()

        (skill_dir / "SKILL.md").write_text("# Test Skill")

        # Create special directories that should be excluded
        (skill_dir / "__pycache__").mkdir()
        (skill_dir / ".git").mkdir()
        (skill_dir / "node_modules").mkdir()
        (skill_dir / ".venv").mkdir()

        # Add files to special directories
        (skill_dir / "__pycache__" / "cache.pyc").write_text("cache")

        # Create a markdown file
        (skill_dir / "README.md").write_text("# README")

        mode = self.detector.detect_mode(skill_dir)

        # Should be SINGLE_FILE because special dirs are excluded
        self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                        "Should exclude special directories and detect SINGLE_FILE mode")

    # ========================================
    # Test DIRECTORY_WITH_SCRIPTS mode
    # ========================================

    def test_mode_detection_with_root_scripts(self):
        """Test detection of DIRECTORY_WITH_SCRIPTS mode - skill with root-level scripts."""
        skill_dir = self.test_path / "test_skill_scripts"
        skill_dir.mkdir()

        # Create SKILL.md
        (skill_dir / "SKILL.md").write_text("# Test Skill\n\nThis skill has scripts.")

        # Create root-level script files (no subdirectories)
        (skill_dir / "setup.sh").write_text("#!/bin/bash\necho 'setup'")
        (skill_dir / "analyze.py").write_text("#!/usr/bin/env python3\nprint('analyze')")

        # Create additional markdown files
        (skill_dir / "README.md").write_text("# README")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SCRIPTS,
                        "Should detect DIRECTORY_WITH_SCRIPTS when root-level scripts exist")

    def test_mode_detection_with_various_script_extensions(self):
        """Test detection with various script file extensions."""
        skill_dir = self.test_path / "test_skill_script_extensions"
        skill_dir.mkdir()

        # Create scripts with different extensions
        (skill_dir / "script.sh").write_text("#!/bin/bash")
        (skill_dir / "script.py").write_text("#!/usr/bin/env python3")
        (skill_dir / "script.js").write_text("#!/usr/bin/env node")
        (skill_dir / "script.ts").write_text("// TypeScript")
        (skill_dir / "script.rb").write_text("#!/usr/bin/env ruby")
        (skill_dir / "script.pl").write_text("#!/usr/bin/env perl")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SCRIPTS,
                        "Should detect DIRECTORY_WITH_SCRIPTS with various script extensions")

    def test_mode_detection_scripts_with_single_script(self):
        """Test detection with just one root-level script."""
        skill_dir = self.test_path / "test_skill_one_script"
        skill_dir.mkdir()

        (skill_dir / "SKILL.md").write_text("# Test Skill")
        (skill_dir / "run.sh").write_text("#!/bin/bash\necho 'run'")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SCRIPTS,
                        "Should detect DIRECTORY_WITH_SCRIPTS with single script")

    # ========================================
    # Test SINGLE_FILE mode
    # ========================================

    def test_mode_detection_single_file(self):
        """Test detection of SINGLE_FILE mode - simple skill with only markdown."""
        skill_dir = self.test_path / "test_skill_single"
        skill_dir.mkdir()

        # Create only markdown files (no subdirectories, no scripts)
        (skill_dir / "SKILL.md").write_text("# Test Skill\n\nThis is a simple skill.")
        (skill_dir / "README.md").write_text("# README")
        (skill_dir / "GUIDE.md").write_text("# Guide")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                        "Should detect SINGLE_FILE when only markdown files exist")

    def test_mode_detection_single_file_with_json(self):
        """Test SINGLE_FILE mode with markdown and config files (no scripts)."""
        skill_dir = self.test_path / "test_skill_single_with_config"
        skill_dir.mkdir()

        (skill_dir / "SKILL.md").write_text("# Test Skill")
        (skill_dir / "config.json").write_text('{"key": "value"}')
        (skill_dir / "data.yaml").write_text("key: value")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                        "Should detect SINGLE_FILE with config files (not scripts)")

    def test_mode_detection_empty_directory(self):
        """Test detection with empty directory."""
        skill_dir = self.test_path / "test_skill_empty"
        skill_dir.mkdir()

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                        "Should default to SINGLE_FILE for empty directory")

    # ========================================
    # Test priority order
    # ========================================

    def test_mode_detection_priority_subdirs_over_scripts(self):
        """Test that subdirectories have priority over root-level scripts."""
        skill_dir = self.test_path / "test_skill_priority"
        skill_dir.mkdir()

        # Create both subdirectories AND root-level scripts
        (skill_dir / "SKILL.md").write_text("# Test Skill")
        (skill_dir / "templates").mkdir()  # Subdirectory
        (skill_dir / "setup.sh").write_text("#!/bin/bash")  # Root script

        mode = self.detector.detect_mode(skill_dir)

        # Subdirectories should take priority
        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SUBDIRS,
                        "DIRECTORY_WITH_SUBDIRS should have priority over DIRECTORY_WITH_SCRIPTS")

    # ========================================
    # Test edge cases and error handling
    # ========================================

    def test_mode_detection_nonexistent_directory(self):
        """Test detection with non-existent directory."""
        nonexistent_dir = self.test_path / "nonexistent"

        mode = self.detector.detect_mode(nonexistent_dir)

        self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                        "Should default to SINGLE_FILE for non-existent directory")

    def test_mode_detection_file_instead_of_directory(self):
        """Test detection when given a file path instead of directory."""
        file_path = self.test_path / "test_file.txt"
        file_path.write_text("Not a directory")

        mode = self.detector.detect_mode(file_path)

        self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                        "Should default to SINGLE_FILE when given a file instead of directory")

    def test_mode_detection_with_permission_error(self):
        """Test detection handles permission errors gracefully."""
        # Note: This test may not work on all systems due to permission handling
        # Skip on Windows or if running as root
        if os.name == 'nt' or os.geteuid() == 0:
            self.skipTest("Permission test not applicable on Windows or when running as root")

        skill_dir = self.test_path / "test_skill_no_perms"
        skill_dir.mkdir()

        # Create some content
        (skill_dir / "SKILL.md").write_text("# Test")

        # Remove read permissions
        os.chmod(skill_dir, 0o000)

        try:
            mode = self.detector.detect_mode(skill_dir)

            # Should fallback to SINGLE_FILE on permission error
            self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                            "Should default to SINGLE_FILE on permission error")
        finally:
            # Restore permissions for cleanup
            os.chmod(skill_dir, 0o755)

    # ========================================
    # Test with realistic skill structures
    # ========================================

    def test_mode_detection_docx_skill_structure(self):
        """Test with a realistic docx-like skill structure (subdirectories)."""
        skill_dir = self.test_path / "docx"
        skill_dir.mkdir()

        # Create structure similar to docx skill
        (skill_dir / "SKILL.md").write_text("# DOCX Skill")
        (skill_dir / "scripts").mkdir()
        (skill_dir / "ooxml").mkdir()
        (skill_dir / "scripts" / "extract.sh").write_text("#!/bin/bash")
        (skill_dir / "ooxml" / "parser.py").write_text("# Parser")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SUBDIRS,
                        "Should detect DIRECTORY_WITH_SUBDIRS for docx-like structure")

    def test_mode_detection_root_cause_tracing_structure(self):
        """Test with realistic root-cause-tracing skill structure (root scripts)."""
        skill_dir = self.test_path / "root-cause-tracing"
        skill_dir.mkdir()

        # Create structure with root-level scripts
        (skill_dir / "SKILL.md").write_text("# Root Cause Tracing")
        (skill_dir / "trace.sh").write_text("#!/bin/bash")
        (skill_dir / "analyze.py").write_text("#!/usr/bin/env python3")
        (skill_dir / "README.md").write_text("# README")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.DIRECTORY_WITH_SCRIPTS,
                        "Should detect DIRECTORY_WITH_SCRIPTS for root-cause-tracing-like structure")

    def test_mode_detection_algorithmic_art_structure(self):
        """Test with realistic algorithmic-art skill structure (single file)."""
        skill_dir = self.test_path / "algorithmic-art"
        skill_dir.mkdir()

        # Create structure with only markdown
        (skill_dir / "SKILL.md").write_text("# Algorithmic Art")
        (skill_dir / "README.md").write_text("# README")

        mode = self.detector.detect_mode(skill_dir)

        self.assertEqual(mode, TransformationMode.SINGLE_FILE,
                        "Should detect SINGLE_FILE for algorithmic-art-like structure")


def run_tests():
    """Run all tests and return results."""
    # Create test suite
    loader = unittest.TestLoader()
    suite = loader.loadTestsFromTestCase(TestModeDetector)

    # Run tests with verbose output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Return True if all tests passed
    return result.wasSuccessful()


if __name__ == "__main__":
    # Run tests and exit with appropriate code
    success = run_tests()
    sys.exit(0 if success else 1)
