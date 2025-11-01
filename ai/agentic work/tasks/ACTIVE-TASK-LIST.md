# Task List: Marketplace Launch - Technical Implementation

**Focus:** Package for Claude Code marketplace, ensure npx works, verify 3 variants, document for users

**Project Location:** `/home/hamr/Documents/PycharmProjects/agentic-toolkit/ai/agentic-kit`

---

## Tasks

### 1.0 Configure npm Package for npx Support
- [x] 1.1 Create npm package.json with proper metadata (name, version, description, author, repository)
- [x] 1.2 Add `bin` field to package.json pointing to CLI entrypoint for npx execution
- [x] 1.3 Create `cli.js` wrapper script that handles variant selection and initialization
- [x] 1.4 Add shebang to cli.js for direct execution (`#!/usr/bin/env node`)
- [x] 1.5 Add `prepublishOnly` script to package.json for validation
- [x] 1.6 Test npx execution locally: `npx ./ai/agentic-kit` (before publishing)

### 2.0 Validate All 3 Variants Load Correctly
- [ ] 2.1 Test Lite variant: Verify only 3 agents load (Master, Orchestrator, Scrum Master)
- [ ] 2.2 Test Lite variant: Confirm no skills are loaded
- [ ] 2.3 Test Standard variant: Verify all 13 agents load
- [ ] 2.4 Test Standard variant: Verify 8 core skills load (PDF, DOCX, XLSX, PPTX, Canvas, Theme Factory, Brand Guidelines, Internal Comms)
- [ ] 2.5 Test Pro variant: Verify all 13 agents load
- [ ] 2.6 Test Pro variant: Verify all 16 skills load (8 core + 8 advanced)
- [ ] 2.7 Verify variant isolation: Confirm Pro-only skills fail in Lite/Standard
- [ ] 2.8 Test `@Master: *help` command shows only available agents for each variant

### 3.0 Prepare Marketplace Submission Package
- [ ] 3.1 Verify plugin.json meets Claude marketplace schema requirements
- [ ] 3.2 Verify each variant manifest (plugin-lite.json, plugin-standard.json, plugin-pro.json) is valid
- [ ] 3.3 Create marketplace icon (SVG or PNG, per marketplace requirements)
- [ ] 3.4 Prepare 3-5 screenshots demonstrating agent invocation and workflow
- [ ] 3.5 Write marketplace description (300 char summary highlighting 3 variants)
- [ ] 3.6 Create detailed feature list for marketplace listing
- [ ] 3.7 Package all required files according to marketplace submission guidelines

### 4.0 Create User Documentation
- [ ] 4.1 Update README.md with clear installation instructions for marketplace and npx
- [ ] 4.2 Add variant selection guide to README (which variant to choose)
- [ ] 4.3 Update QUICK-START.md with 3-step example for each variant
- [ ] 4.4 Create VARIANT-FEATURES.md listing exactly which agents/skills are in each variant
- [ ] 4.5 Update TROUBLESHOOTING.md with common installation and variant issues
- [ ] 4.6 Verify all documentation cross-references are correct and consistent

### 5.0 Quality Assurance Testing
- [ ] 5.1 Test fresh marketplace installation of Lite variant in clean environment
- [ ] 5.2 Test fresh marketplace installation of Standard variant in clean environment
- [ ] 5.3 Test fresh marketplace installation of Pro variant in clean environment
- [ ] 5.4 Test npx execution: `npx agentic-kit@lite`, `npx agentic-kit`, `npx agentic-kit@pro`
- [ ] 5.5 Verify installation completes within documented time (<1 min Lite, <3 min Standard, <5 min Pro)
- [ ] 5.6 Run validate-references.sh script to check for broken references
- [ ] 5.7 Test agent invocation syntax works: `@Master:`, `@Orchestrator:`, etc.
- [ ] 5.8 Test skill execution for variant-appropriate skills

### 6.0 Submit to Marketplace
- [ ] 6.1 Review Claude marketplace submission checklist
- [ ] 6.2 Submit Lite variant for marketplace review
- [ ] 6.3 Submit Standard variant for marketplace review
- [ ] 6.4 Submit Pro variant for marketplace review
- [ ] 6.5 Address any feedback from marketplace reviewers
- [ ] 6.6 Obtain approval for all 3 variants
- [ ] 6.7 Coordinate simultaneous publication of all 3 variants

### 7.0 npm Registry Publication
- [ ] 7.1 Create npm account and configure authentication
- [ ] 7.2 Update package.json with correct repository URL and author info
- [ ] 7.3 Test `npm pack` to verify package contents are correct
- [ ] 7.4 Publish to npm registry: `npm publish --tag lite` for lite variant
- [ ] 7.5 Publish to npm registry: `npm publish` for standard variant (latest)
- [ ] 7.6 Publish to npm registry: `npm publish --tag pro` for pro variant
- [ ] 7.7 Verify npm package is installable: `npm install agentic-kit`, `npm install agentic-kit@lite`, `npm install agentic-kit@pro`
- [ ] 7.8 Verify npx works: `npx agentic-kit@latest`

---

## Relevant Files

- `/home/hamr/Documents/PycharmProjects/agentic-toolkit/ai/agentic-kit/package.json` - npm package configuration with metadata, bin field, and scripts
- `/home/hamr/Documents/PycharmProjects/agentic-toolkit/ai/agentic-kit/cli.js` - CLI wrapper script with variant selection and user-friendly output
- `/home/hamr/Documents/PycharmProjects/agentic-toolkit/ai/agentic-kit/validate-package.js` - Package validation script for prepublishOnly hook

---

## Success Criteria

1. **Marketplace**: All 3 variants approved and live in Claude marketplace
2. **npx**: Users can run `npx agentic-kit` and select variant
3. **Variants**: Each variant loads exactly the designated agents and skills
4. **Documentation**: Users can install and use toolkit within 15 minutes following docs
5. **Quality**: Installation success rate >98% across methods
6. **Support**: GitHub issues ready to handle user questions
