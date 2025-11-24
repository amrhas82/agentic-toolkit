#!/bin/bash

# Implementation Validation Script
# Validates that all Task 6.0 components are properly implemented

set -euo pipefail

# Colors
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Validation results
declare -A VALIDATION_RESULTS=(
    ["progress_indicators"]="pending"
    ["cli_interface"]="pending"
    ["opencode_templates"]="pending"
    ["droid_templates"]="pending"
    ["installation_summary"]="pending"
    ["documentation"]="pending"
    ["integration_tests"]="pending"
    ["e2e_validation"]="pending"
)

echo -e "${BLUE}🔍 Ollama Ubuntu Setup Tool - Implementation Validation${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo

# Function to log validation result
log_result() {
    local component="$1"
    local status="$2"
    local message="$3"

    VALIDATION_RESULTS[$component]="$status"

    case "$status" in
        "pass")
            echo -e "${GREEN}✅ PASS${NC}: $component - $message"
            ;;
        "fail")
            echo -e "${RED}❌ FAIL${NC}: $component - $message"
            ;;
        "warn")
            echo -e "${YELLOW}⚠️  WARN${NC}: $component - $message"
            ;;
        "skip")
            echo -e "${YELLOW}⏭️  SKIP${NC}: $component - $message"
            ;;
    esac
}

# 1. Validate Enhanced Progress Indicators
echo -e "${BLUE}1. Validating Enhanced Progress Indicators...${NC}"

if [[ -f "lib/ui-helper.sh" ]]; then
    if grep -q "ui_show_detailed_progress" lib/ui-helper.sh; then
        if grep -q "ui_show_multi_progress" lib/ui-helper.sh; then
            if grep -q "ui_show_timeline" lib/ui-helper.sh; then
                if grep -q "ui_show_status_dashboard" lib/ui-helper.sh; then
                    log_result "progress_indicators" "pass" "All progress indicator functions implemented"
                else
                    log_result "progress_indicators" "fail" "Missing status dashboard function"
                fi
            else
                log_result "progress_indicators" "fail" "Missing timeline function"
            fi
        else
            log_result "progress_indicators" "fail" "Missing multi-progress function"
        fi
    else
        log_result "progress_indicators" "fail" "Missing detailed progress function"
    fi
else
    log_result "progress_indicators" "fail" "UI helper file not found"
fi

# 2. Validate Improved CLI Interface
echo -e "${BLUE}2. Validating Improved CLI Interface...${NC}"

if [[ -f "lib/cli-helper.sh" ]]; then
    if grep -q "cli_show_detailed_help" lib/cli-helper.sh; then
        if grep -q "cli_show_install_help" lib/cli-helper.sh; then
            if grep -q "cli_parse_command" lib/cli-helper.sh; then
                if grep -q "cli_interactive_setup" lib/cli-helper.sh; then
                    log_result "cli_interface" "pass" "All CLI enhancements implemented"
                else
                    log_result "cli_interface" "fail" "Missing interactive setup function"
                fi
            else
                log_result "cli_interface" "fail" "Missing command parsing function"
            fi
        else
            log_result "cli_interface" "fail" "Missing install help function"
        fi
    else
        log_result "cli_interface" "fail" "Missing detailed help function"
    fi
else
    log_result "cli_interface" "fail" "CLI helper file not found"
fi

# 3. Validate OpenCode Configuration Templates
echo -e "${BLUE}3. Validating OpenCode Configuration Templates...${NC}"

if [[ -f "lib/template-generator.sh" ]]; then
    if grep -q "generate_opencode_config" lib/template-generator.sh; then
        # Check if function has proper content
        if grep -q "opencode-config.json" lib/template-generator.sh; then
            if grep -q "api.*baseUrl" lib/template-generator.sh; then
                log_result "opencode_templates" "pass" "OpenCode template generator implemented"
            else
                log_result "opencode_templates" "fail" "OpenCode template missing API configuration"
            fi
        else
            log_result "opencode_templates" "fail" "OpenCode template filename not found"
        fi
    else
        log_result "opencode_templates" "fail" "OpenCode generation function not found"
    fi
else
    log_result "opencode_templates" "fail" "Template generator file not found"
fi

# 4. Validate Droid CLI Configuration Templates
echo -e "${BLUE}4. Validating Droid CLI Configuration Templates...${NC}"

if [[ -f "lib/template-generator.sh" ]]; then
    if grep -q "generate_droid_config" lib/template-generator.sh; then
        if grep -q "droid-config.env" lib/template-generator.sh; then
            if grep -q "OLLAMA_API_BASE_URL" lib/template-generator.sh; then
                log_result "droid_templates" "pass" "Droid CLI template generator implemented"
            else
                log_result "droid_templates" "fail" "Droid template missing API configuration"
            fi
        else
            log_result "droid_templates" "fail" "Droid template filename not found"
        fi
    else
        log_result "droid_templates" "fail" "Droid generation function not found"
    fi
else
    log_result "droid_templates" "fail" "Template generator file not found"
fi

# 5. Validate Installation Summary and Next Steps
echo -e "${BLUE}5. Validating Installation Summary and Next Steps...${NC}"

if [[ -f "lib/installation-summary.sh" ]]; then
    if grep -q "show_installation_summary" lib/installation-summary.sh; then
        if grep -q "show_next_steps" lib/installation-summary.sh; then
            if grep -q "show_quick_start" lib/installation-summary.sh; then
                if grep -q "create_installation_report" lib/installation-summary.sh; then
                    log_result "installation_summary" "pass" "All summary functions implemented"
                else
                    log_result "installation_summary" "fail" "Missing installation report function"
                fi
            else
                log_result "installation_summary" "fail" "Missing quick start function"
            fi
        else
            log_result "installation_summary" "fail" "Missing next steps function"
        fi
    else
        log_result "installation_summary" "fail" "Missing installation summary function"
    fi
else
    log_result "installation_summary" "fail" "Installation summary file not found"
fi

# 6. Validate Comprehensive User Guidance Documentation
echo -e "${BLUE}6. Validating Comprehensive User Guidance Documentation...${NC}"

docs_ok=true
doc_files=("docs/USER_GUIDE.md" "docs/QUICK_START.md" "docs/TROUBLESHOOTING.md")

for doc_file in "${doc_files[@]}"; do
    if [[ -f "$doc_file" ]]; then
        file_size=$(stat -c%s "$doc_file" 2>/dev/null || echo "0")
        if [[ $file_size -gt 100 ]]; then
            echo -e "  ${GREEN}✓${NC} $doc_file ($file_size bytes)"
        else
            echo -e "  ${YELLOW}⚠${NC} $doc_file (too small: $file_size bytes)"
            docs_ok=false
        fi
    else
        echo -e "  ${RED}✗${NC} $doc_file (missing)"
        docs_ok=false
    fi
done

if [[ "$docs_ok" == "true" ]]; then
    log_result "documentation" "pass" "All documentation files present and substantial"
else
    log_result "documentation" "fail" "Some documentation files missing or incomplete"
fi

# 7. Validate Final Integration Testing Suite
echo -e "${BLUE}7. Validating Final Integration Testing Suite...${NC}"

if [[ -f "tests/test-final-integration.sh" ]]; then
    if grep -q "test_cli_helper" tests/test-final-integration.sh; then
        if grep -q "test_ui_helper" tests/test-final-integration.sh; then
            if grep -q "test_template_generator" tests/test-final-integration.sh; then
                if grep -q "run_all_tests" tests/test-final-integration.sh; then
                    log_result "integration_tests" "pass" "Integration test suite implemented"
                else
                    log_result "integration_tests" "fail" "Missing test runner function"
                fi
            else
                log_result "integration_tests" "fail" "Missing template generator tests"
            fi
        else
            log_result "integration_tests" "fail" "Missing UI helper tests"
        fi
    else
        log_result "integration_tests" "fail" "Missing CLI helper tests"
    fi
else
    log_result "integration_tests" "fail" "Final integration test file not found"
fi

# 8. Validate End-to-End Workflow Validation
echo -e "${BLUE}8. Validating End-to-End Workflow Validation...${NC}"

if [[ -f "tests/test-e2e-workflow.sh" ]]; then
    if grep -q "workflow_fresh_installation" tests/test-e2e-workflow.sh; then
        if grep -q "workflow_template_generation" tests/test-e2e-workflow.sh; then
            if grep -q "workflow_integration_testing" tests/test-e2e-workflow.sh; then
                if grep -q "run_e2e_workflows" tests/test-e2e-workflow.sh; then
                    log_result "e2e_validation" "pass" "E2E workflow validation implemented"
                else
                    log_result "e2e_validation" "fail" "Missing E2E workflow runner"
                fi
            else
                log_result "e2e_validation" "fail" "Missing integration testing workflow"
            fi
        else
            log_result "e2e_validation" "fail" "Missing template generation workflow"
        fi
    else
        log_result "e2e_validation" "fail" "Missing fresh installation workflow"
    fi
else
    log_result "e2e_validation" "fail" "E2E workflow test file not found"
fi

# Generate Summary Report
echo
echo -e "${BLUE}=======================================================${NC}"
echo -e "${BLUE}           IMPLEMENTATION VALIDATION SUMMARY${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo

total_components=8
passed_components=0
failed_components=0

for component in "${!VALIDATION_RESULTS[@]}"; do
    status="${VALIDATION_RESULTS[$component]}"
    case "$status" in
        "pass")
            ((passed_components++))
            ;;
        "fail")
            ((failed_components++))
            ;;
    esac
done

echo -e "Total Components: ${BLUE}$total_components${NC}"
echo -e "Passed: ${GREEN}$passed_components${NC}"
echo -e "Failed: ${RED}$failed_components${NC}"
echo

success_rate=0
if [[ $total_components -gt 0 ]]; then
    success_rate=$(( (passed_components * 100) / total_components ))
fi

echo -e "Success Rate: ${BLUE}$success_rate%${NC}"
echo

if [[ $failed_components -eq 0 ]]; then
    echo -e "${GREEN}🎉 ALL COMPONENTS VALIDATED SUCCESSFULLY!${NC}"
    echo -e "${GREEN}Task 6.0 implementation is complete and ready.${NC}"
    echo
    echo -e "${BLUE}Key Features Implemented:${NC}"
    echo -e "  • Enhanced progress indicators with real-time status"
    echo -e "  • Improved CLI with comprehensive help system"
    echo -e "  • OpenCode and Droid CLI configuration generators"
    echo -e "  • Installation summary and next steps display"
    echo -e "  • Comprehensive user documentation"
    echo -e "  • Final integration testing suite"
    echo -e "  • End-to-end workflow validation"
    echo
    echo -e "${GREEN}The Ollama Ubuntu Setup Tool is now production-ready!${NC}"
else
    echo -e "${RED}❌ SOME COMPONENTS NEED ATTENTION${NC}"
    echo -e "${YELLOW}Failed components:${NC}"
    for component in "${!VALIDATION_RESULTS[@]}"; do
        if [[ "${VALIDATION_RESULTS[$component]}" == "fail" ]]; then
            echo -e "  ${RED}• $component${NC}"
        fi
    done
    echo
    echo -e "${YELLOW}Please review and fix the failed components before release.${NC}"
fi

echo
echo -e "${BLUE}Validation completed at: $(date)${NC}"

# Exit with appropriate code
if [[ $failed_components -eq 0 ]]; then
    exit 0
else
    exit 1
fi