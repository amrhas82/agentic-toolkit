# AI Agent Collaboration Guide

## Table of Contents
1. [Communication Protocol](#communication-protocol)
2. [Development Standards](#development-standards)
3. [Testing Standards](#testing-standards)
4. [Tech Stack & Tools](#tech-stack--tools)
5. [Development Workflow](#development-workflow)
6. [Twelve-Factor Reference](#twelve-factor-reference)
7. [CLAUDE.md Stub](#claudemd-stub)
8. [AI Agent Instructions](#ai-agent-instructions)

---

## Communication Protocol

### Core Rules
- **Clarity First**: Always ask clarifying questions when requirements are ambiguous
- **Fact-Based**: Base all recommendations on verified, current information
- **Simplicity Advocate**: Call out overcomplications and suggest simpler alternatives
- **Safety First**: Never modify critical systems without explicit understanding and approval

### User Profile
- **Technical Level**: Non-coder but technically savvy
- **Learning Style**: Understands concepts, needs executable instructions
- **Expects**: Step-by-step guidance with clear explanations
- **Comfortable with**: Command-line operations and scripts

### Required Safeguards
- Always identify affected files before making changes
- Never modify authentication systems without explicit permission
- Never alter database schema without proper migration files
- Explain what changes will be made and why

---

## Development Standards

### Validate Before You Build

- **POC everything first.** Before committing to a design, build a quick proof-of-concept (~15 min) that validates the core logic. Keep it stupidly simple — manual steps are fine, hardcoded values are fine, no tests needed yet
- **POC scope:** Cover the happy path and 2-3 common edge cases. If those work, the idea is sound
- **Graduation criteria:** POC validates logic and covers most common scenarios → stop, design properly, then build with structure, tests, and error handling. Never ship the POC — rewrite it
- **Build incrementally.** After POC graduates, break the work into small, independent modules. Focus on one at a time. Each piece must work on its own before integrating with the next

### Dependency Hierarchy

Always exhaust the simpler option before reaching for the next:

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

- **Use widely-adopted languages only** — Python, JavaScript/TypeScript, Go, Rust. No niche languages unless the domain demands it
- **Pick the lightest language that fits the domain:** shell scripts for automation, Python for data/backend/CLI, TypeScript for web, Go for systems/infra, Rust for performance-critical
- **Minimize the polyglot tax.** Every language in the stack adds CI config, tooling, and onboarding friction. Do not add a new language for one microservice — use what's already in the stack unless there's a compelling reason
- **Vanilla over frameworks.** Express over NestJS, Flask over Django, unless the project genuinely needs the framework's structure. Structure can always be added later; removing a framework is painful

### Build Rules

- **Open-source only.** Always use open-source solutions. No vendor lock-in
- **Lightweight over complex.** If two solutions solve the same problem, use the one with fewer moving parts, fewer dependencies, and less configuration
- **Every line must have a purpose.** No speculative code, no "might need this later", no abstractions for one use case
- **Simple > clever.** Readable code that a junior can follow beats elegant code that requires a PhD to debug
- **Containerize only when necessary.** Start with a virtualenv or bare metal. Docker adds value for deployment parity and isolation — not for running a script

### Red Flags — Stop and Flag These
- Over-engineering simple problems
- Adding external dependencies for trivial operations
- Frameworks where a library or stdlib would suffice
- Vendor-specific implementations when open alternatives exist
- Skipping POC validation for unproven ideas

---

## Testing Standards

### Rules

**Test behavior, not implementation.** A test suite must give you confidence to refactor freely. If changing internal code (without changing behavior) breaks tests, those tests are liabilities, not assets.

**Follow the Testing Trophy** (not the Testing Pyramid):
- Few unit tests — only for pure logic, algorithms, and complex calculations
- Many integration tests — the sweet spot; test real components working together
- Some E2E tests — cover critical user journeys end-to-end
- Static analysis — types and linters catch bugs cheaper than tests

### When to Write Tests

- **After the design stabilizes, not during exploration.** Do not TDD a prototype — you'll write 500 tests for code you delete tomorrow. First make it work (POC), then make it right (refactor + tests), then make it fast
- **Write tests when the code has users.** If a function is called by other modules or exposed to users, it needs tests. Internal helpers that only serve one caller don't need their own test file
- **Write tests for bugs.** Every bug fix must include a regression test that fails before the fix and passes after. This is the highest-value test you can write
- **Write tests before refactoring.** Before changing working code, write characterization tests first to lock in current behavior, then refactor with confidence
- **Do not write tests for glue code.** Code that just wires components together (calls A then B then C) is tested at the integration level, not unit level

### TDD: When It Works and When It Doesn't

- **TDD works for:** Pure functions, algorithms, parsers, validators, data transformations — anything with clear inputs and outputs
- **TDD does not work for:** Exploring a design, building a POC, or unstable interfaces. Writing tests for unstable APIs creates churn and false confidence
- **The rule:** You must understand what you're building before you TDD it. TDD is a design tool for known problems, not a discovery tool for unknown ones
- **Red-green-refactor discipline:** If you do TDD, follow the cycle strictly. Write a failing test, write minimal code to pass, refactor. Do not write 20 tests then implement — that's front-loading waste

### What Makes a Good Test

- **Tests real behavior.** Call the public API, assert on observable output. Do not reach into internals
- **Fails for the right reason.** A good test fails when the feature is broken, not when the implementation changes
- **Reads like a spec.** Someone unfamiliar with the code must understand what the feature does by reading the test
- **Self-contained.** Each test sets up its own state, runs, and cleans up. No ordering dependencies between tests
- **Fast and deterministic.** Flaky tests erode trust. If a test depends on timing, network, or global state, fix that dependency

### Anti-Patterns — Do Not Do These

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
- **No duplicate test files.** Before creating a new test file, check if one already exists for that module

### Markers and Signals

| Marker | Purpose | CI Behavior |
|--------|---------|-------------|
| `@pytest.mark.slow` | Runtime > 5s | Run in full suite, skip in quick checks |
| `@pytest.mark.ml` | Requires ML deps (torch, etc.) | Skip if deps not installed |
| `@pytest.mark.real_api` | Calls external APIs | Skip in CI — run manually before release |

**CI runs for fast signals:**
- `pytest -m "not slow and not ml and not real_api"` — fast gate on every push (~30s)
- `pytest` — full suite on PR merge or nightly
- Package-level runs for targeted debugging: `pytest packages/core/tests/`

### Coverage and Ratios

- **Do not chase a coverage number.** 80% coverage with meaningless tests is worse than 40% with behavior-testing integration tests
- **Cover the critical path first.** Data layer, auth, payment, core business logic — before helper utilities
- **Coverage tells you what's NOT tested, not what IS tested.** High coverage with bad assertions is false confidence
- **Delete tests that don't catch bugs.** If a test has never failed (or only fails on refactors), it's not providing value

**Target ratio:** ~20% unit, ~60% integration, ~15% E2E, ~5% manual/exploratory

### Test Tooling Standards

- Use `tmp_path` for filesystem tests, `:memory:` or `tmp_path` SQLite for DB tests
- Use dependency injection over `@patch` — it's more readable and survives refactors
- Tests must be self-sufficient — no dependency on project directories, user config, or environment state
- Use factories or builders for test data, not raw constructors with 15 arguments
- Keep test fixtures close to where they're used. Shared fixtures in `conftest.py`, not a global test utilities package

---

## Tech Stack & Tools

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
| UI Components | Radix UI primitives | Latest | Accessible UI components |
| Language | Python | Latest | Versatile programming language |

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
| Container Registry | GHCR | Docker image storage (complex projects) |
| Orchestration | Docker + Docker Compose | Container management (complex projects) |
| CI/CD | GitHub Actions | Automated deployment |
| Monitoring | PostHog | Product analytics |

### Development Tools

| Component | Technology | Purpose |
|-----------|------------|---------|
| Text Editor | Nvim | Highly customizable text editor |
| Terminal Multiplexer | tmux | Terminal session manager |
| IDE | PyCharm Community Edition | Python development environment |
| Terminal Emulator | ghostty | Terminal emulator |
| OS | Linux Ubuntu | Development environment |
| Code Editor | Ampcode | Collaborative code editing |

### Testing Tools

| Component | Technology | Purpose |
|-----------|------------|---------|
| API Client | Postman | API testing and documentation |
| JS Testing | Jest / Vitest | JavaScript/TypeScript testing |
| Browser Automation | Playwright | Automated browser testing |
| Python Testing | pytest | Python testing framework |

---

## Development Workflow

### Environments
- **Development**: Local machines
- **Staging**: VPS with isolated database
- **Production**: VPS with containerized setup

### Deployment Strategy

**Simple Projects:** `Local → GitHub → VPS (direct deployment)`

**Complex Projects:** `Local → GitHub → GHCR → VPS (containerized)`

---

## Twelve-Factor Reference

The [Twelve-Factor App](https://12factor.net) methodology for modern, scalable applications:

| # | Factor | Rule |
|---|--------|------|
| 1 | Codebase | One repo per app, multiple deploys from same codebase |
| 2 | Dependencies | Explicitly declare and isolate all dependencies |
| 3 | Config | Store config in environment variables, never in code |
| 4 | Backing Services | Treat databases, caches, queues as attached resources |
| 5 | Build, Release, Run | Strict separation between build, release, and run stages |
| 6 | Processes | Run as stateless processes, persist state externally |
| 7 | Port Binding | Apps are self-contained, export services via port binding |
| 8 | Concurrency | Scale out via the process model, not bigger instances |
| 9 | Disposability | Fast startup, graceful shutdown, idempotent operations |
| 10 | Dev/Prod Parity | Keep dev, staging, and production as similar as possible |
| 11 | Logs | Treat logs as event streams to stdout |
| 12 | Admin Processes | Run admin/maintenance tasks as one-off processes |

---

## CLAUDE.md Stub

Copy this to any project's CLAUDE.md. These are mandatory rules, not suggestions.

```markdown
## Dev Rules

**POC first.** Always validate logic with a ~15min proof-of-concept before building. Cover happy path + common edges. POC works → design properly → build with tests. Never ship the POC.

**Build incrementally.** Break work into small independent modules. One piece at a time, each must work on its own before integrating.

**Dependency hierarchy — follow strictly:** vanilla language → standard library → external (only when stdlib can't do it in <100 lines). External deps must be maintained, lightweight, and widely adopted. Exception: always use vetted libraries for security-critical code (crypto, auth, sanitization).

**Lightweight over complex.** Fewer moving parts, fewer deps, less config. Express over NestJS, Flask over Django, unless the project genuinely needs the framework. Simple > clever. Readable > elegant.

**Open-source only.** No vendor lock-in. Every line of code must have a purpose — no speculative code, no premature abstractions.

For full development and testing standards, see `.claude/memory/AGENT_RULES.md`.
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
