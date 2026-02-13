# 🤖 AI Agent Collaboration Guide

## Table of Contents
1. [Communication Protocol](#communication-protocol)
2. [Tool Selection Guidelines](#tool-selection-guidelines)
3. [Testing Strategy Framework](#testing-strategy-framework)
4. [Tech Stack Preferences](#tech-stack-preferences)
5. [Development Workflow](#development-workflow)
6. [Core Principles](#core-principles)
   - [Twelve-Factor App Methodology](#architecture-methodology-the-twelve-factor-app)
   - [Technology Choices](#technology-choices)
   - [Architecture Guidelines](#architecture-guidelines)
7. [Solution Guidelines](#solution-guidelines)
8. [Quick Reference](#quick-reference)

## Communication Protocol

### Core Communication Principles
- **Clarity First**: Always ask clarifying questions when requirements are ambiguous
- **Fact-Based Responses**: Base all recommendations on verified, current information
- **Simplicity Advocate**: Call out overcomplications and suggest simpler alternatives
- **Technical Translation**: Explain complex concepts in clear, actionable terms
- **Safety First**: Never modify critical systems without explicit understanding and approval

### User Profile
- **Technical Level**: Non-coder but technically savvy
- **Learning Style**: Understands concepts, needs executable instructions
- **Preference**: Step-by-step guidance with clear explanations
- **Tools**: Comfortable with command-line operations and scripts

### Required Safeguards
- **File Impact Analysis**: Always identify affected files before making changes
- **Authentication Protection**: Never modify authentication systems without explicit permission
- **Database Safety**: Never alter database schema without proper migration files
- **Change Documentation**: Explain what changes will be made and why

## Tool Selection Guidelines

| Tool | Best For | When to Use |
|------|----------|-------------|
| **DeepSeek** | Detailed code discussions, complex problem solving | Architecture decisions, code reviews, detailed technical analysis |
| **Replit** | UI development, rapid prototyping | Frontend work, visual components, interactive demos |
| **Claude** | Bug fixing, code simplification, refactoring | Debugging, code cleanup, optimization tasks |

## Testing Strategy Framework

### Core Philosophy

**Test behavior, not implementation.** A test suite should give you confidence to refactor freely. If changing internal code (without changing behavior) breaks tests, those tests are liabilities, not assets.

**The Testing Trophy** (preferred over the Testing Pyramid):
- Few unit tests — only for pure logic, algorithms, and complex calculations
- Many integration tests — the sweet spot; test real components working together
- Some E2E tests — cover critical user journeys end-to-end
- Static analysis — types and linters catch bugs cheaper than tests

### When to Write Tests

- **After the design stabilizes, not during exploration.** Don't TDD a prototype — you'll write 500 tests for code you delete tomorrow. First make it work (POC), then make it right (refactor + tests), then make it fast
- **Write tests when the code has users.** If a function is called by other modules or exposed to users, it needs tests. Internal helpers that only serve one caller don't need their own test file
- **Write tests for bugs.** Every bug fix should include a regression test that fails before the fix and passes after. This is the highest-value test you can write
- **Write tests before refactoring.** If you're about to change working code, write characterization tests first to lock in current behavior, then refactor with confidence
- **Don't write tests for glue code.** Code that just wires components together (calls A then B then C) is better tested at the integration level, not unit level

### TDD: When It Helps and When It Hurts

- **TDD works well for:** Pure functions, algorithms, parsers, validators, data transformations — anything with clear inputs and outputs
- **TDD hurts when:** You're exploring a design, building a POC, or the interface isn't settled yet. Writing tests for unstable APIs creates churn and false confidence
- **The real rule:** You must understand what you're building before you TDD it. TDD is a design tool for known problems, not a discovery tool for unknown ones
- **Red-green-refactor discipline:** If you do TDD, actually follow the cycle. Write a failing test, write minimal code to pass, refactor. Don't write 20 tests then implement — that's just front-loading waste

### What Makes a Good Test

- **Tests real behavior.** Call the public API, assert on observable output. Don't reach into internals
- **Fails for the right reason.** A good test fails when the feature is broken, not when the implementation changes
- **Reads like a spec.** Someone unfamiliar with the code should understand what the feature does by reading the test
- **Self-contained.** Each test sets up its own state, runs, and cleans up. No ordering dependencies between tests
- **Fast and deterministic.** Flaky tests erode trust. If a test depends on timing, network, or global state, fix that dependency

### What Makes a Bad Test (Anti-Patterns)

- **Mocking more than 60% of the test.** If most of the test is mock setup, you're testing mocks, not code. Use real implementations with `tmp_path`, `:memory:` SQLite, or test containers
- **Smoke tests.** `assert result is not None` proves nothing. Assert on specific values, structure, or side effects
- **Testing private methods.** If you need to test a private method, either it should be public or the public method's tests should cover it
- **Mirroring implementation.** Tests that replicate the source code line-by-line break on every refactor and catch zero bugs
- **Test-only production code.** Never add methods, flags, or branches to production code solely for testing. Use dependency injection instead

### Test Organization

- **Co-locate tests with packages:** `packages/<pkg>/tests/` not a root `tests/` directory. Each package owns its tests
- **Separate by type:**
  ```
  packages/<pkg>/tests/
    unit/           # Fast, isolated, mocked deps, <1s each
    integration/    # Real DB, filesystem, multi-component, <10s each
    e2e/            # Full workflows, subprocess calls, <60s each
    conftest.py     # Shared fixtures for this package
  ```
- **One test file per module** (not per function). `test_auth.py` tests the auth module, not `test_login.py` + `test_logout.py` + `test_session.py`
- **No duplicate test files.** Before creating a new test file, check if one already exists for that module. Duplicates cause collection conflicts and confusion

### Markers and Signals

Use markers to get fast feedback on what matters:

| Marker | Purpose | CI Behavior |
|--------|---------|-------------|
| `@pytest.mark.slow` | Runtime > 5s | Run in full suite, skip in quick checks |
| `@pytest.mark.ml` | Requires ML deps (torch, etc.) | Skip if deps not installed |
| `@pytest.mark.real_api` | Calls external APIs | Skip in CI — run manually before release |

**Organize CI runs for fast signals:**
- `pytest -m "not slow and not ml and not real_api"` — fast gate on every push (~30s)
- `pytest` — full suite on PR merge or nightly
- Package-level runs for targeted debugging: `pytest packages/core/tests/`

### Coverage Rules

- **Don't chase a coverage number.** 80% coverage with meaningless tests is worse than 40% coverage with behavior-testing integration tests
- **Cover the critical path first.** Data layer, auth, payment, core business logic — these get tests before helper utilities
- **Coverage tells you what's NOT tested, not what IS tested.** High coverage with bad assertions is false confidence
- **Delete tests that don't catch bugs.** If a test has never failed (or only fails on refactors), it's not providing value

### The Right Test Ratio

Aim for roughly:
- **~20% unit tests** — pure logic, math, parsing, validation
- **~60% integration tests** — components working together with real dependencies (DB, filesystem, HTTP)
- **~15% E2E tests** — critical user journeys, CLI workflows, API contracts
- **~5% manual/exploratory** — security, UX, edge cases that are hard to automate

### Practical Test Preferences

- Use `tmp_path` for filesystem tests, `:memory:` or `tmp_path` SQLite for DB tests
- Prefer dependency injection over `@patch` — it's more readable and survives refactors
- Tests must be self-sufficient — no dependency on project directories, user config, or environment state
- Use factories or builders for test data, not raw constructors with 15 arguments
- Keep test fixtures close to where they're used. Shared fixtures in `conftest.py`, not a global test utilities package

## Tech Stack Preferences

### Core Development Stack

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| Runtime | Node.js | 18+ | JavaScript server runtime |
| Framework | Express.js | 4.x | Web application framework |
| Language | TypeScript | 5.0+ | Type-safe development |
| Frontend | React + TypeScript | 18+ | Modern UI development |
| Styling | Tailwind CSS + shadcn/ui | Latest | Utility-first CSS + components |
| Database ORM | Drizzle ORM | 0.28+ | Type-safe database operations |
| Validation | Zod | 3.x | Schema validation and type inference |
| Authentication | JWT + bcrypt or Clerk | 9.x + 5.x | Secure authentication |
| HTTP Client | Axios | 1.x | External service integration |
| Caching | Redis | Latest | In-memory data structure store |
| Server State | TanStack Query (React Query) | Latest | Server state management in React |
| Language | Python | Latest | Versatile programming language |
| Language | JavaScript | Latest | Core web development language |

### Database Layer

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| Database | PostgreSQL | 15+ | ACID-compliant relational database |
| Migration Tool | Drizzle Kit | 0.19+ | Database schema management |
| Connection | postgres.js | 3.x | Database connection pooling |

### Infrastructure & Deployment

| Component | Technology | Purpose |
|-----------|------------|---------|
| VPS | RackNerd VPS | Production hosting |
| Database | Supabase | Development/Staging database |
| Analytics | Umami Analytics | Privacy-focused analytics |
| Email | MSMTP + Resend | Transactional emails |
| Reverse Proxy | Nginx | Load balancing and SSL |
| SSL | Let's Encrypt | Free SSL certificates |
| Version Control | GitHub | Source code management |

### For Complex Projects

| Component | Technology | Purpose |
|-----------|------------|---------|
| Container Registry | GHCR (GitHub Container Registry) | Docker image storage |
| Orchestration | Docker + Docker Compose | Container management |
| CI/CD | GitHub Actions | Automated deployment |
| Monitoring | PostHog | Product analytics |

### Development Tools

| Component | Technology | Purpose |
|-----------|------------|---------|
| Text Editor | Nvim | Highly customizable text editor |
| Terminal Multiplexer | tmux | Terminal session manager |
| IDE | PyCharm Community Edition | Python development environment |
| Terminal Emulator | ghostty | Terminal emulator with enhanced features |
| OS | Linux Ubuntu | Development environment |
| Code Editor | Ampcode | Collaborative code editing |

### Testing and Utilities

| Component | Technology | Purpose |
|-----------|------------|---------|
| API Client | Postman | API testing and documentation |
| Testing Framework | Jest | JavaScript testing framework |
| Browser Automation | Playwright | Automated browser testing |
| Environment Variables | dotenv | Manage environment variables |
| UI Components | Radix UI primitives | Building accessible UI components |

## Development Workflow

### Environments
- **Development**: Local machines + Replit for UI
- **Staging**: VPS with isolated database
- **Production**: VPS with containerized setup

### Deployment Strategy

#### Simple Projects
```bash
Local → GitHub → VPS (direct deployment)
```

#### Complex Projects
```bash
Local → GitHub → GHCR → VPS (containerized)
```

## Core Principles

### Architecture Methodology: The Twelve-Factor App

The **Twelve-Factor App** methodology provides a framework for building modern, scalable, and maintainable web applications. Originally designed for cloud platforms, these principles guide our development approach:

#### 📁 **1. Codebase**
- **Single Repository**: Maintain one codebase per application tracked in version control
- **Multiple Deploys**: Deploy the same codebase to development, staging, and production environments
- **Implementation**: Use GitHub for source control with feature branches and clear deployment strategies

#### 📦 **2. Dependencies**
- **Explicit Declaration**: Use package.json, requirements.txt, or similar dependency files
- **Isolation**: Ensure dependencies are installed in isolated environments (virtual environments, containers)
- **Implementation**: Use npm/pip for dependency management, avoid global installations

#### ⚙️ **3. Configuration**
- **Environment-Based**: Store all configuration in environment variables
- **No Hardcoded Values**: Never embed API keys, database URLs, or environment-specific settings in code
- **Implementation**: Use `.env` files for development, environment variables for production

#### 🔌 **4. Backing Services**
- **Treat as Attached**: View databases, caches, queues, and other services as pluggable resources
- **Interchangeable**: Design applications to work with different backing services
- **Implementation**: Use connection strings, abstraction layers, and service discovery patterns

#### 🏗️ **5. Build, Release, Run**
- **Strict Separation**: Maintain distinct phases for building (compilation), releasing (configuration), and running (execution)
- **Immutable Releases**: Once built, releases should not be modified
- **Implementation**: Use CI/CD pipelines, Docker containers, and deployment scripts

#### 🔄 **6. Processes**
- **Stateless Execution**: Run applications as stateless processes
- **External State**: Store all persistent data in external backing services (databases, caches)
- **Implementation**: Avoid in-memory state, use session stores or databases for persistence

#### 🚪 **7. Port Binding**
- **Self-Contained**: Applications should be fully self-contained and bind to a specified port
- **Web Server Agnostic**: Don't assume a specific web server or container
- **Implementation**: Use Express.js with port binding, deploy via reverse proxy

#### ⚡ **8. Concurrency**
- **Process Model**: Scale out by adding more processes rather than making individual processes larger
- **Horizontal Scaling**: Design for horizontal scaling across multiple instances
- **Implementation**: Use process managers (PM2), container orchestration, load balancers

#### 🗑️ **9. Disposability**
- **Fast Startup**: Applications should start quickly (typically in seconds)
- **Graceful Shutdown**: Handle shutdown signals cleanly, ensuring data consistency
- **Implementation**: Use health checks, proper signal handling, and idempotent operations

#### 🔀 **10. Dev/Prod Parity**
- **Environment Similarity**: Keep development, staging, and production environments as similar as possible
- **Minimize Differences**: Reduce bugs caused by environment discrepancies
- **Implementation**: Use Docker for local development, same database types, similar configurations

#### 📊 **11. Logs**
- **Event Streams**: Treat logs as event streams sent to standard output
- **Centralized Collection**: Aggregate logs from all environments for analysis
- **Implementation**: Use `console.log`, structured logging, and log aggregation services

#### 🛠️ **12. Admin Processes**
- **One-Off Tasks**: Run administrative tasks (migrations, maintenance) as one-off processes
- **Same Environment**: Execute admin tasks in the same environment as the application
- **Implementation**: Use npm scripts, separate command-line tools, and task runners

## Development Philosophy

### Validate Before You Build

- **POC everything first.** Before committing to a design, build a quick proof-of-concept (~15 min) that validates the core logic. Keep it stupidly simple — manual steps are fine, hardcoded values are fine, no tests needed yet
- **POC scope:** Cover the happy path and 2-3 common edge cases. If those work, the idea is sound
- **Graduation criteria:** POC validates logic and covers most common scenarios → stop, design properly, then build with structure, tests, and error handling. Never ship the POC — rewrite it
- **Build incrementally.** After POC graduates, break the work into small, independent modules. Focus on one at a time. Each piece should work on its own before integrating with the next

### Dependency Hierarchy

Use this order — always exhaust the simpler option before reaching for the next:

1. **Vanilla language** — Write it yourself using only language primitives. If it's <50 lines and not security-critical, this is the answer
2. **Standard library** — Use built-in modules (`os`, `json`, `pathlib`, `http`, `fs`, `crypto`). The stdlib is tested, maintained, and has zero supply chain risk
3. **External library** — Only when both vanilla and stdlib are insufficient. Must pass the checklist below

### External Dependency Checklist

Before adding any external dependency, all of these must be true:
- **Necessity:** Can't reasonably implement this with stdlib in <100 lines
- **Maintained:** Active commits in the last 6 months, responsive maintainer
- **Lightweight:** Few transitive dependencies (check the dep tree, not just the top-level)
- **Established:** Widely used, not a single-maintainer hobby project for production-critical code
- **Security-aware:** For security-critical domains (crypto, auth, sanitization, parsing untrusted input), a vetted library is *required* — never roll your own

### Language Selection

- **Prefer widely-adopted languages** — Python, JavaScript/TypeScript, Go, Rust. Avoid niche languages unless the domain demands it (e.g., Elixir for telecom-grade concurrency)
- **Pick the lightest language that fits the domain:** shell scripts for automation, Python for data/backend/CLI, TypeScript for web, Go for systems/infra, Rust for performance-critical
- **Minimize the polyglot tax.** Every language in the stack adds CI config, tooling, and onboarding friction. Don't add a new language for one microservice — use what you already have unless there's a compelling reason
- **Vanilla over frameworks.** Use Express over NestJS, Flask over Django, unless the project genuinely needs the framework's structure. You can always add structure later; removing a framework is painful

### Build Philosophy

- **Open-source first.** Always prefer open-source solutions. Avoid vendor lock-in
- **Lightweight over complex.** If two solutions solve the same problem, pick the one with fewer moving parts, fewer dependencies, and less configuration
- **Every line must have a purpose.** No speculative code, no "might need this later", no abstractions for one use case
- **Simple > clever.** Readable code that a junior can follow beats elegant code that requires a PhD to debug
- **Containerize only when necessary.** Start with a virtualenv or bare metal. Docker adds value for deployment parity and isolation — not for running a script

## Solution Guidelines

### Always Consider
- Is this the simplest approach?
- Can this be done with vanilla language or stdlib?
- What's the maintenance and dependency burden?
- Is there vendor lock-in?
- Would a 15-minute POC validate this before I commit?

### Red Flags to Call Out
- Over-engineering simple problems
- Adding external dependencies for trivial operations
- Frameworks where a library or stdlib would suffice
- Vendor-specific implementations when open alternatives exist
- Skipping POC validation for unproven ideas

## Quick Reference

### Common Commands

#### Database
```bash
npx drizzle-kit generate
npx drizzle-kit push
```

#### Development
```bash
npm run dev
npm run build
```

#### Docker
```bash
docker-compose up -d
docker-compose down
```

#### Testing
```bash
# Unit tests
npm test
npm test --coverage

# E2E tests
npx playwright test
npx playwright test --ui

# API tests
newman run collection.json
```

### Default Ports & URLs
- **Local Dev**: http://localhost:3000
- **PostgreSQL**: 5432
- **API Server**: 3001 (if separate)

### Environment Setup
```bash
# Node.js project setup
npm init -y
npm install express typescript @types/node
npm install -D jest @types/jest ts-jest
npm install -D playwright @playwright/test

# Database setup
npm install drizzle-orm postgres
npm install -D drizzle-kit

# Testing setup
npm install -D supertest @types/supertest
```

---

## AI Agent Instructions

When working with this user:
1. **Always verify** you understand the requirements before proceeding
2. **Provide step-by-step** instructions with clear explanations
3. **Include ready-to-run** scripts and commands
4. **Explain the "why"** behind technical recommendations
5. **Flag potential issues** before they become problems
6. **Suggest simpler alternatives** when appropriate
7. **Never modify** authentication or database schema without explicit permission
8. **Always identify** which files will be affected by changes