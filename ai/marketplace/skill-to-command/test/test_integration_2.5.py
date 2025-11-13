#!/usr/bin/env python3
"""
Comprehensive Integration Test for Subtask 2.5

This test verifies that the complete file discovery system works end-to-end:
1. Integration of discover_skills() + discover_files()
2. Expected results for sample skills (mcp-builder, theme-factory, pdf)
3. Exclusion rules (LICENSE.txt, scripts/, binary files)
4. File categorization (markdown, code, config)
5. Edge cases (empty dirs, missing SKILL.md, nested subdirectories)

Author: Skill-to-Command Converter Development Team
Version: 1.0
"""

import sys
from pathlib import Path
from typing import Dict, List, Any

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

from skill_to_command_converter import SkillConverter


class IntegrationTestSuite:
    """Comprehensive integration test suite for file discovery system."""

    def __init__(self):
        """Initialize test suite."""
        self.converter = SkillConverter()
        self.test_results = {
            'passed': 0,
            'failed': 0,
            'warnings': 0
        }
        self.failures = []

    def log_pass(self, test_name: str, message: str = ""):
        """Log a passing test."""
        self.test_results['passed'] += 1
        status = "✓ PASS"
        print(f"  {status}: {test_name}")
        if message:
            print(f"         {message}")

    def log_fail(self, test_name: str, message: str):
        """Log a failing test."""
        self.test_results['failed'] += 1
        status = "✗ FAIL"
        print(f"  {status}: {test_name}")
        print(f"         {message}")
        self.failures.append(f"{test_name}: {message}")

    def log_warning(self, test_name: str, message: str):
        """Log a warning."""
        self.test_results['warnings'] += 1
        status = "⚠ WARN"
        print(f"  {status}: {test_name}")
        print(f"         {message}")

    def print_section(self, title: str):
        """Print a section header."""
        print(f"\n{'='*70}")
        print(f"{title}")
        print('='*70)

    def test_1_integration_workflow(self):
        """Test 1: Integration of discover_skills() + discover_files()"""
        self.print_section("TEST 1: Integration Workflow")

        # Test 1.1: discover_skills() returns valid list
        print("\n[1.1] Testing discover_skills() returns valid list of paths")
        skills = self.converter.discover_skills()

        if not isinstance(skills, list):
            self.log_fail("discover_skills() return type",
                         f"Expected list, got {type(skills)}")
            return
        else:
            self.log_pass("discover_skills() return type", "Returns list")

        if len(skills) == 0:
            self.log_fail("discover_skills() results",
                         "No skills found in skills/ directory")
            return
        else:
            self.log_pass("discover_skills() results",
                         f"Found {len(skills)} skills")

        if not all(isinstance(s, Path) for s in skills):
            self.log_fail("discover_skills() Path objects",
                         "Not all items are Path objects")
            return
        else:
            self.log_pass("discover_skills() Path objects",
                         "All items are Path objects")

        # Test 1.2: discover_files() can be called for each skill
        print("\n[1.2] Testing discover_files() integration")

        successful_discoveries = 0
        for skill_dir in skills[:5]:  # Test first 5 skills
            try:
                files = self.converter.discover_files(skill_dir)
                if isinstance(files, dict):
                    successful_discoveries += 1
            except Exception as e:
                self.log_fail(f"discover_files({skill_dir.name})", str(e))

        if successful_discoveries == min(5, len(skills)):
            self.log_pass("discover_files() integration",
                         f"Successfully processed {successful_discoveries} skills")
        else:
            self.log_fail("discover_files() integration",
                         f"Only {successful_discoveries}/{min(5, len(skills))} successful")

        # Test 1.3: Result structure validation
        print("\n[1.3] Testing discover_files() result structure")

        test_skill = skills[0]
        files = self.converter.discover_files(test_skill)

        expected_keys = ['skill_md', 'markdown', 'code', 'config', 'other']
        if set(files.keys()) == set(expected_keys):
            self.log_pass("Result structure",
                         "Contains all expected keys")
        else:
            self.log_fail("Result structure",
                         f"Missing keys: {set(expected_keys) - set(files.keys())}")

        # Verify types
        type_checks_passed = True
        if files['skill_md'] is not None and not isinstance(files['skill_md'], Path):
            type_checks_passed = False
        for key in ['markdown', 'code', 'config', 'other']:
            if not isinstance(files[key], list):
                type_checks_passed = False
                break
            if not all(isinstance(f, Path) for f in files[key]):
                type_checks_passed = False
                break

        if type_checks_passed:
            self.log_pass("Result types", "All values have correct types")
        else:
            self.log_fail("Result types", "Type mismatch in results")

    def test_2_sample_skills(self):
        """Test 2: Expected results for sample skills"""
        self.print_section("TEST 2: Sample Skills Verification")

        skills = self.converter.discover_skills()
        skills_by_name = {s.name: s for s in skills}

        # Test 2.1: mcp-builder skill
        print("\n[2.1] Testing mcp-builder skill")
        if 'mcp-builder' not in skills_by_name:
            self.log_fail("mcp-builder existence", "Skill not found")
        else:
            mcp_builder = skills_by_name['mcp-builder']
            files = self.converter.discover_files(mcp_builder)

            # Check SKILL.md
            if files['skill_md']:
                self.log_pass("mcp-builder SKILL.md", "Found in root")
            else:
                self.log_fail("mcp-builder SKILL.md", "Not found in root")

            # Check reference/ subdirectory files
            ref_files = [f for f in files['markdown']
                        if 'reference' in f.parts]
            if len(ref_files) > 0:
                self.log_pass("mcp-builder reference/ files",
                             f"Found {len(ref_files)} files in reference/")
            else:
                self.log_fail("mcp-builder reference/ files",
                             "No files found in reference/ subdirectory")

            # Verify scripts/ is excluded
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])
            scripts_files = [f for f in all_files if 'scripts' in f.parts]
            if len(scripts_files) == 0:
                self.log_pass("mcp-builder scripts/ exclusion",
                             "scripts/ directory correctly excluded")
            else:
                self.log_fail("mcp-builder scripts/ exclusion",
                             f"Found {len(scripts_files)} files in scripts/")

            # Verify LICENSE.txt is excluded
            license_files = [f for f in all_files
                           if f.name.lower() in ['license.txt', 'license']]
            if len(license_files) == 0:
                self.log_pass("mcp-builder LICENSE.txt exclusion",
                             "LICENSE.txt correctly excluded")
            else:
                self.log_fail("mcp-builder LICENSE.txt exclusion",
                             f"Found LICENSE file: {license_files[0].name}")

        # Test 2.2: theme-factory skill
        print("\n[2.2] Testing theme-factory skill")
        if 'theme-factory' not in skills_by_name:
            self.log_fail("theme-factory existence", "Skill not found")
        else:
            theme_factory = skills_by_name['theme-factory']
            files = self.converter.discover_files(theme_factory)

            # Check SKILL.md
            if files['skill_md']:
                self.log_pass("theme-factory SKILL.md", "Found in root")
            else:
                self.log_fail("theme-factory SKILL.md", "Not found in root")

            # Check themes/ subdirectory files
            theme_files = [f for f in files['markdown']
                          if 'themes' in f.parts]
            if len(theme_files) > 0:
                self.log_pass("theme-factory themes/ files",
                             f"Found {len(theme_files)} files in themes/")
            else:
                self.log_fail("theme-factory themes/ files",
                             "No files found in themes/ subdirectory")

            # Verify binary files (PDF) are excluded
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])
            pdf_files = [f for f in all_files if f.suffix.lower() == '.pdf']
            if len(pdf_files) == 0:
                self.log_pass("theme-factory PDF exclusion",
                             "Binary .pdf files correctly excluded")
            else:
                self.log_fail("theme-factory PDF exclusion",
                             f"Found PDF file: {pdf_files[0].name}")

        # Test 2.3: pdf skill
        print("\n[2.3] Testing pdf skill")
        if 'pdf' not in skills_by_name:
            self.log_fail("pdf existence", "Skill not found")
        else:
            pdf_skill = skills_by_name['pdf']
            files = self.converter.discover_files(pdf_skill)

            # Check SKILL.md
            if files['skill_md']:
                self.log_pass("pdf SKILL.md", "Found in root")
            else:
                self.log_fail("pdf SKILL.md", "Not found in root")

            # Check for forms.md in root
            forms_md = [f for f in files['markdown']
                       if f.name == 'forms.md' and len(f.relative_to(pdf_skill).parts) == 1]
            if len(forms_md) > 0:
                self.log_pass("pdf forms.md", "Found in root")
            else:
                self.log_fail("pdf forms.md", "Not found in root")

            # Check for reference.md in root
            ref_md = [f for f in files['markdown']
                     if f.name == 'reference.md' and len(f.relative_to(pdf_skill).parts) == 1]
            if len(ref_md) > 0:
                self.log_pass("pdf reference.md", "Found in root")
            else:
                self.log_fail("pdf reference.md", "Not found in root")

            # Verify scripts/ is excluded
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])
            scripts_files = [f for f in all_files if 'scripts' in f.parts]
            if len(scripts_files) == 0:
                self.log_pass("pdf scripts/ exclusion",
                             "scripts/ directory correctly excluded")
            else:
                self.log_fail("pdf scripts/ exclusion",
                             f"Found {len(scripts_files)} files in scripts/")

    def test_3_exclusion_validation(self):
        """Test 3: Validate exclusions work correctly"""
        self.print_section("TEST 3: Exclusion Rules Validation")

        skills = self.converter.discover_skills()

        # Test 3.1: LICENSE files excluded
        print("\n[3.1] Testing LICENSE.txt exclusion")
        license_count = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])
            license_files = [f for f in all_files
                           if f.name.lower() in ['license.txt', 'license']]
            license_count += len(license_files)

        if license_count == 0:
            self.log_pass("LICENSE.txt exclusion",
                         "No LICENSE files in any discovered files")
        else:
            self.log_fail("LICENSE.txt exclusion",
                         f"Found {license_count} LICENSE files")

        # Test 3.2: scripts/ directories excluded
        print("\n[3.2] Testing scripts/ directory exclusion")
        scripts_count = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])
            scripts_files = [f for f in all_files
                           if 'scripts' in [p.lower() for p in f.relative_to(skill_dir).parts]]
            scripts_count += len(scripts_files)

        if scripts_count == 0:
            self.log_pass("scripts/ exclusion",
                         "No files from scripts/ directories")
        else:
            self.log_fail("scripts/ exclusion",
                         f"Found {scripts_count} files in scripts/ directories")

        # Test 3.3: Binary files excluded
        print("\n[3.3] Testing binary file exclusion")
        binary_extensions = ['.pdf', '.jpg', '.jpeg', '.png', '.gif',
                            '.zip', '.exe', '.bin']
        binary_count = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])
            binary_files = [f for f in all_files
                          if f.suffix.lower() in binary_extensions]
            binary_count += len(binary_files)

        if binary_count == 0:
            self.log_pass("Binary file exclusion",
                         "No binary files discovered")
        else:
            self.log_fail("Binary file exclusion",
                         f"Found {binary_count} binary files")

        # Test 3.4: __pycache__ directories excluded
        print("\n[3.4] Testing __pycache__ directory exclusion")
        pycache_count = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])
            pycache_files = [f for f in all_files
                           if '__pycache__' in [p.lower() for p in f.relative_to(skill_dir).parts]]
            pycache_count += len(pycache_files)

        if pycache_count == 0:
            self.log_pass("__pycache__ exclusion",
                         "No files from __pycache__ directories")
        else:
            self.log_fail("__pycache__ exclusion",
                         f"Found {pycache_count} files in __pycache__")

    def test_4_file_categorization(self):
        """Test 4: Validate file categorization"""
        self.print_section("TEST 4: File Categorization Validation")

        skills = self.converter.discover_skills()

        # Test 4.1: Markdown files (.md) categorized correctly
        print("\n[4.1] Testing markdown file categorization")
        md_miscategorized = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)

            # Check that .md files are only in 'markdown' category
            for f in files['code'] + files['config'] + files['other']:
                if f.suffix.lower() in ['.md', '.markdown']:
                    md_miscategorized += 1
                    print(f"      Found .md in wrong category: {skill_dir.name}/{f.relative_to(skill_dir)}")

        if md_miscategorized == 0:
            self.log_pass("Markdown categorization",
                         "All .md files in correct category")
        else:
            self.log_fail("Markdown categorization",
                         f"Found {md_miscategorized} miscategorized .md files")

        # Test 4.2: Code files (.py, .js, .sh) categorized correctly
        print("\n[4.2] Testing code file categorization")
        code_extensions = ['.py', '.js', '.sh', '.ts', '.jsx', '.tsx']
        code_correctly_categorized = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)

            # Check that code files are in 'code' category
            for f in files['code']:
                if f.suffix.lower() in code_extensions:
                    code_correctly_categorized += 1

        if code_correctly_categorized > 0:
            self.log_pass("Code file categorization",
                         f"{code_correctly_categorized} code files correctly categorized")
        else:
            self.log_warning("Code file categorization",
                           "No code files found to test")

        # Test 4.3: Config files (.json, .yaml) categorized correctly
        print("\n[4.3] Testing config file categorization")
        config_extensions = ['.json', '.yaml', '.yml', '.xml']
        config_correctly_categorized = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)

            # Check that config files are in 'config' category
            for f in files['config']:
                if f.suffix.lower() in config_extensions:
                    config_correctly_categorized += 1

        if config_correctly_categorized > 0:
            self.log_pass("Config file categorization",
                         f"{config_correctly_categorized} config files correctly categorized")
        else:
            self.log_warning("Config file categorization",
                           "No config files found to test")

        # Test 4.4: Files are sorted alphabetically
        print("\n[4.4] Testing alphabetical sorting")
        unsorted_categories = 0
        for skill_dir in skills[:10]:  # Test first 10 skills
            files = self.converter.discover_files(skill_dir)

            for category in ['markdown', 'code', 'config', 'other']:
                if len(files[category]) > 1:
                    paths = [str(p) for p in files[category]]
                    if paths != sorted(paths):
                        unsorted_categories += 1

        if unsorted_categories == 0:
            self.log_pass("Alphabetical sorting",
                         "All categories properly sorted")
        else:
            self.log_fail("Alphabetical sorting",
                         f"Found {unsorted_categories} unsorted categories")

    def test_5_edge_cases(self):
        """Test 5: Edge cases"""
        self.print_section("TEST 5: Edge Cases")

        skills = self.converter.discover_skills()

        # Test 5.1: Skills without SKILL.md
        print("\n[5.1] Testing skills without SKILL.md")
        no_skill_md = []
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            if not files['skill_md']:
                no_skill_md.append(skill_dir.name)

        if len(no_skill_md) > 0:
            self.log_warning("Missing SKILL.md",
                           f"Found {len(no_skill_md)} skills without SKILL.md: {', '.join(no_skill_md[:3])}")
        else:
            self.log_pass("Missing SKILL.md",
                         "All skills have SKILL.md")

        # Test 5.2: Nested subdirectories (2+ levels deep)
        print("\n[5.2] Testing nested subdirectory handling")
        nested_files_count = 0
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            all_files = (files['markdown'] + files['code'] +
                        files['config'] + files['other'])

            # Count files that are 2+ levels deep
            for f in all_files:
                rel_path = f.relative_to(skill_dir)
                if len(rel_path.parts) > 2:  # More than 2 levels (e.g., subdir/subsubdir/file.md)
                    nested_files_count += 1

        if nested_files_count > 0:
            self.log_pass("Nested subdirectories",
                         f"Successfully handles {nested_files_count} deeply nested files")
        else:
            self.log_warning("Nested subdirectories",
                           "No deeply nested files found to test")

        # Test 5.3: Empty skill directories (no files)
        print("\n[5.3] Testing empty skill directory handling")
        empty_skills = []
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            total = (len(files['markdown']) + len(files['code']) +
                    len(files['config']) + len(files['other']))
            if total == 0 and not files['skill_md']:
                empty_skills.append(skill_dir.name)

        if len(empty_skills) == 0:
            self.log_pass("Empty directory handling",
                         "No completely empty skills (or handled gracefully)")
        else:
            self.log_warning("Empty directory handling",
                           f"Found {len(empty_skills)} empty skills: {', '.join(empty_skills)}")

        # Test 5.4: Skills with only SKILL.md (no other files)
        print("\n[5.4] Testing skills with only SKILL.md")
        only_skill_md = []
        for skill_dir in skills:
            files = self.converter.discover_files(skill_dir)
            total = (len(files['markdown']) + len(files['code']) +
                    len(files['config']) + len(files['other']))
            if total == 0 and files['skill_md']:
                only_skill_md.append(skill_dir.name)

        if len(only_skill_md) > 0:
            self.log_pass("SKILL.md-only handling",
                         f"Successfully handles {len(only_skill_md)} skills with only SKILL.md")
        else:
            self.log_warning("SKILL.md-only handling",
                           "No SKILL.md-only skills found to test")

    def run_all_tests(self):
        """Run all integration tests."""
        print("\n" + "="*70)
        print("COMPREHENSIVE INTEGRATION TEST SUITE - SUBTASK 2.5")
        print("="*70)
        print("\nTesting complete end-to-end file discovery system:")
        print("  - discover_skills() + discover_files() integration")
        print("  - Sample skill validation (mcp-builder, theme-factory, pdf)")
        print("  - Exclusion rules (LICENSE, scripts/, binaries)")
        print("  - File categorization (markdown, code, config)")
        print("  - Edge cases (empty dirs, missing files, nested subdirs)")
        print()

        # Run all test sections
        self.test_1_integration_workflow()
        self.test_2_sample_skills()
        self.test_3_exclusion_validation()
        self.test_4_file_categorization()
        self.test_5_edge_cases()

        # Print final summary
        self.print_section("FINAL TEST RESULTS")
        print(f"\nTests Passed:  {self.test_results['passed']}")
        print(f"Tests Failed:  {self.test_results['failed']}")
        print(f"Warnings:      {self.test_results['warnings']}")
        print(f"Total Tests:   {self.test_results['passed'] + self.test_results['failed']}")

        if self.test_results['failed'] > 0:
            print("\n" + "="*70)
            print("FAILURES SUMMARY")
            print("="*70)
            for i, failure in enumerate(self.failures, 1):
                print(f"{i}. {failure}")

        print("\n" + "="*70)
        if self.test_results['failed'] == 0:
            print("✓ ALL TESTS PASSED!")
            print("The file discovery system is working correctly end-to-end.")
        else:
            print("✗ SOME TESTS FAILED")
            print(f"Please review the {self.test_results['failed']} failed test(s) above.")
        print("="*70)

        return self.test_results['failed'] == 0


def main():
    """Main test entry point."""
    test_suite = IntegrationTestSuite()
    success = test_suite.run_all_tests()

    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())
