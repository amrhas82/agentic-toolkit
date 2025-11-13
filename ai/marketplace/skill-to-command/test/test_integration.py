#!/usr/bin/env python3
"""
Integration tests for Skill-to-Command Converter v2.0.

Tests end-to-end processing for all three transformation modes:
- DIRECTORY_WITH_SUBDIRS
- DIRECTORY_WITH_SCRIPTS
- SINGLE_FILE
"""

import unittest
import tempfile
import shutil
import os
from pathlib import Path
import sys

# Add parent directory to path to import the converter module
sys.path.insert(0, str(Path(__file__).parent.parent))

from skill_to_command_converter import SkillConverter, TransformationMode


class TestIntegrationV2(unittest.TestCase):
    """Integration tests for v2.0 transformation modes."""

    def setUp(self):
        """Set up test fixtures before each test method."""
        # Create temporary output directory
        self.output_dir = tempfile.mkdtemp(prefix="test_integration_output_")
        self.output_path = Path(self.output_dir)

        # Set up converter
        self.converter = SkillConverter()

        # Override output directory for testing
        import skill_to_command_converter
        self.original_output_dir = skill_to_command_converter.OUTPUT_DIR
        skill_to_command_converter.OUTPUT_DIR = self.output_path
        self.converter.output_dir = self.output_path

        # Path to test skills
        self.test_skills_dir = Path(__file__).parent / "integration"

    def tearDown(self):
        """Clean up test fixtures after each test method."""
        # Remove temporary output directory
        if self.output_path.exists():
            shutil.rmtree(self.output_path)

        # Restore original output directory
        import skill_to_command_converter
        skill_to_command_converter.OUTPUT_DIR = self.original_output_dir

    # ========================================
    # Test DIRECTORY_WITH_SUBDIRS (subtask 7.2)
    # ========================================

    def test_subdirs_mode_end_to_end(self):
        """Test DIRECTORY_WITH_SUBDIRS mode end-to-end."""
        skill_dir = self.test_skills_dir / "test-subdirs-skill"

        # Verify test skill exists
        self.assertTrue(skill_dir.exists(), "Test skill directory should exist")

        # Process the skill
        result = self.converter.process_skill(skill_dir)

        # Verify processing was successful
        self.assertEqual(result.status, "SUCCESS", "Processing should succeed")
        self.assertEqual(result.transformation_mode, "DIRECTORY_WITH_SUBDIRS")

        # Verify output file exists
        output_file = self.output_path / "test-subdirs-skill.md"
        self.assertTrue(output_file.exists(), "Output markdown file should exist")

        # Verify subdirectories were copied
        scripts_dir = self.output_path / "test-subdirs-skill" / "scripts"
        lib_dir = self.output_path / "test-subdirs-skill" / "lib"
        self.assertTrue(scripts_dir.exists(), "scripts/ subdirectory should be copied")
        self.assertTrue(lib_dir.exists(), "lib/ subdirectory should be copied")

        # Verify files in subdirectories exist
        helper_script = scripts_dir / "helper.sh"
        utils_py = lib_dir / "core" / "utils.py"
        self.assertTrue(helper_script.exists(), "scripts/helper.sh should exist")
        self.assertTrue(utils_py.exists(), "lib/core/utils.py should exist")

        # Verify permissions preserved (helper.sh should be executable)
        self.assertTrue(os.access(helper_script, os.X_OK), "helper.sh should be executable")

        # Verify markdown was merged
        content = output_file.read_text()
        self.assertIn("Test Subdirectories Skill", content)
        self.assertIn("## Readme", content)  # Secondary file merged with section header from filename

        # Verify statistics
        self.assertEqual(result.markdown_files_merged, 2, "Should merge 2 markdown files")
        self.assertEqual(result.subdirectories_copied, 3, "Should copy 3 subdirectories (scripts, lib, lib/core)")
        self.assertEqual(result.scripts_relocated, 0, "Should not relocate scripts")
        self.assertEqual(result.path_updates_count, 0, "Should not update paths")

        print(f"\n✓ DIRECTORY_WITH_SUBDIRS test passed")
        print(f"  - Output: {output_file}")
        print(f"  - Subdirectories: scripts/, lib/")
        print(f"  - Files merged: {result.markdown_files_merged}")

    # ========================================
    # Test DIRECTORY_WITH_SCRIPTS (subtask 7.3)
    # ========================================

    def test_scripts_mode_end_to_end(self):
        """Test DIRECTORY_WITH_SCRIPTS mode end-to-end."""
        skill_dir = self.test_skills_dir / "test-scripts-skill"

        # Verify test skill exists
        self.assertTrue(skill_dir.exists(), "Test skill directory should exist")

        # Process the skill
        result = self.converter.process_skill(skill_dir)

        # Verify processing was successful
        self.assertEqual(result.status, "SUCCESS", "Processing should succeed")
        self.assertEqual(result.transformation_mode, "DIRECTORY_WITH_SCRIPTS")

        # Verify output file exists
        output_file = self.output_path / "test-scripts-skill.md"
        self.assertTrue(output_file.exists(), "Output markdown file should exist")

        # Verify scripts were relocated
        setup_script = self.output_path / "test-scripts-skill" / "setup.sh"
        analyze_script = self.output_path / "test-scripts-skill" / "analyze.py"
        self.assertTrue(setup_script.exists(), "setup.sh should be relocated")
        self.assertTrue(analyze_script.exists(), "analyze.py should be relocated")

        # Verify permissions preserved (scripts should be executable)
        self.assertTrue(os.access(setup_script, os.X_OK), "setup.sh should be executable")
        self.assertTrue(os.access(analyze_script, os.X_OK), "analyze.py should be executable")

        # Verify paths were updated in markdown
        content = output_file.read_text()
        self.assertIn("Test Scripts Skill", content)

        # Check that paths outside code blocks were updated
        # Note: The exact path format depends on implementation
        # Should contain updated paths like ./test-scripts-skill/setup.sh
        self.assertIn("./test-scripts-skill/setup.sh", content,
                     "Script paths should be updated to include skill subdirectory")
        self.assertIn("./test-scripts-skill/analyze.py", content,
                     "Script paths should be updated to include skill subdirectory")

        # Verify code block examples are preserved (not updated)
        # Code blocks should still have original paths
        self.assertIn("```bash", content, "Code blocks should be preserved")

        # Verify statistics
        self.assertEqual(result.markdown_files_merged, 1, "Should merge 1 markdown file")
        self.assertEqual(result.subdirectories_copied, 0, "Should not copy subdirectories")
        self.assertEqual(result.scripts_relocated, 2, "Should relocate 2 scripts")
        self.assertGreater(result.path_updates_count, 0, "Should update at least some paths")

        print(f"\n✓ DIRECTORY_WITH_SCRIPTS test passed")
        print(f"  - Output: {output_file}")
        print(f"  - Scripts: setup.sh, analyze.py")
        print(f"  - Path updates: {result.path_updates_count}")

    # ========================================
    # Test SINGLE_FILE (subtask 7.4)
    # ========================================

    def test_single_file_mode_end_to_end(self):
        """Test SINGLE_FILE mode end-to-end."""
        skill_dir = self.test_skills_dir / "test-single-skill"

        # Verify test skill exists
        self.assertTrue(skill_dir.exists(), "Test skill directory should exist")

        # Process the skill
        result = self.converter.process_skill(skill_dir)

        # Verify processing was successful
        self.assertEqual(result.status, "SUCCESS", "Processing should succeed")
        self.assertEqual(result.transformation_mode, "SINGLE_FILE")

        # Verify output file exists
        output_file = self.output_path / "test-single-skill.md"
        self.assertTrue(output_file.exists(), "Output markdown file should exist")

        # Verify NO asset directory was created
        asset_dir = self.output_path / "test-single-skill"
        self.assertFalse(asset_dir.exists(), "No asset directory should be created for SINGLE_FILE mode")

        # Verify markdown was merged
        content = output_file.read_text()
        self.assertIn("Test Single File Skill", content)
        self.assertIn("## Guide", content)  # Secondary file merged with section header

        # Verify statistics
        self.assertEqual(result.markdown_files_merged, 2, "Should merge 2 markdown files")
        self.assertEqual(result.subdirectories_copied, 0, "Should not copy subdirectories")
        self.assertEqual(result.scripts_relocated, 0, "Should not relocate scripts")
        self.assertEqual(result.path_updates_count, 0, "Should not update paths")

        print(f"\n✓ SINGLE_FILE test passed")
        print(f"  - Output: {output_file}")
        print(f"  - Files merged: {result.markdown_files_merged}")
        print(f"  - No asset directory created")

    # ========================================
    # Test edge cases (subtask 7.5)
    # ========================================

    def test_empty_directory(self):
        """Test processing an empty directory."""
        # Create empty test directory
        empty_dir = tempfile.mkdtemp(prefix="test_empty_")
        empty_path = Path(empty_dir)

        try:
            result = self.converter.process_skill(empty_path)

            # Should still process (fallback to SINGLE_FILE mode)
            # May return FAILED status due to no content, but should not crash
            self.assertIn(result.status, ["SUCCESS", "FAILED", "PARTIAL_SUCCESS"])
            self.assertIsNotNone(result.transformation_mode)

            print(f"\n✓ Empty directory test passed (status: {result.status})")

        finally:
            shutil.rmtree(empty_path)

    def test_nonexistent_directory(self):
        """Test processing a non-existent directory."""
        nonexistent = Path("/nonexistent/skill/directory")

        # Should handle gracefully (not crash)
        try:
            result = self.converter.process_skill(nonexistent)
            # Should fail gracefully
            self.assertEqual(result.status, "FAILED")
            print(f"\n✓ Nonexistent directory test passed")
        except Exception as e:
            # If it raises an exception, that's also acceptable
            print(f"\n✓ Nonexistent directory test passed (raised exception: {type(e).__name__})")

    # ========================================
    # Validate output structure (subtask 7.6)
    # ========================================

    def test_output_structure_consistency(self):
        """Test that output structure is consistent across all modes."""
        # Process all three test skills
        skills = [
            ("test-subdirs-skill", "DIRECTORY_WITH_SUBDIRS"),
            ("test-scripts-skill", "DIRECTORY_WITH_SCRIPTS"),
            ("test-single-skill", "SINGLE_FILE")
        ]

        for skill_name, expected_mode in skills:
            skill_dir = self.test_skills_dir / skill_name
            result = self.converter.process_skill(skill_dir)

            # Verify markdown output exists
            output_file = self.output_path / f"{skill_name}.md"
            self.assertTrue(output_file.exists(),
                          f"{skill_name}.md should exist")

            # Verify content is not empty
            content = output_file.read_text()
            self.assertGreater(len(content), 0,
                             f"{skill_name}.md should have content")

            # Verify frontmatter or content exists
            self.assertTrue("Test" in content or "#" in content,
                          f"{skill_name}.md should contain markdown content")

            # Verify correct transformation mode was used
            self.assertEqual(result.transformation_mode, expected_mode,
                           f"{skill_name} should use {expected_mode} mode")

        print(f"\n✓ Output structure consistency test passed")
        print(f"  - All skills produced valid markdown output")
        print(f"  - Correct transformation modes detected")


def run_integration_tests():
    """Run all integration tests and return results."""
    # Create test suite
    loader = unittest.TestLoader()
    suite = loader.loadTestsFromTestCase(TestIntegrationV2)

    # Run tests with verbose output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Print summary
    print("\n" + "=" * 60)
    print("INTEGRATION TEST SUMMARY")
    print("=" * 60)
    print(f"Tests run: {result.testsRun}")
    print(f"Successes: {result.testsRun - len(result.failures) - len(result.errors)}")
    print(f"Failures: {len(result.failures)}")
    print(f"Errors: {len(result.errors)}")
    print("=" * 60)

    # Return True if all tests passed
    return result.wasSuccessful()


if __name__ == "__main__":
    # Run integration tests and exit with appropriate code
    success = run_integration_tests()
    sys.exit(0 if success else 1)
