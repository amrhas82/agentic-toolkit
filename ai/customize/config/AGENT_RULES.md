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

### Testing Types to Implement

| Test Type | When to Use | What to Do | Tools | Additional Notes |
|-----------|-------------|------------|-------|------------------|
| **Unit Tests** | • Testing individual functions<br>• Validating component logic<br>• Before any integration work | • Test each function in isolation<br>• Mock external dependencies<br>• Aim for 80%+ code coverage | • Jest (JavaScript/TypeScript)<br>• Vitest (Vite projects)<br>• Mocha + Chai | • Fast execution<br>• Run on every commit<br>• Should be deterministic |
| **Integration Tests** | • Testing API endpoints<br>• Database interactions<br>• Service-to-service communication | • Test real database connections<br>• Test API request/response cycles<br>• Test external service integrations | • Jest + Supertest<br>• Postman/Newman<br>• Testcontainers | • Use test database<br>• Clean up after tests<br>• Test real data flows |
| **End-to-End Tests** | • User journey validation<br>• Critical business workflows<br>• Before production releases | • Simulate real user interactions<br>• Test complete user scenarios<br>• Validate UI/UX flows | • Playwright<br>• Cypress<br>• Selenium | • Run in CI/CD pipeline<br>• Test on multiple browsers<br>• Use realistic test data |
| **Performance Tests** | • Before scaling decisions<br>• Load capacity planning<br>• After major changes | • Simulate high user load<br>• Measure response times<br>• Test under stress conditions | • Artillery<br>• k6<br>• JMeter | • Test realistic scenarios<br>• Monitor resource usage<br>• Set performance baselines |
| **Security Tests** | • Before production deployment<br>• After adding authentication<br>• Regular security audits | • Test for common vulnerabilities<br>• Validate input sanitization<br>• Check authentication/authorization | • OWASP ZAP<br>• Burp Suite<br>• Custom security scripts | • Follow OWASP guidelines<br>• Test both positive and negative cases<br>• Regular security updates |
| **Regression Tests** | • After any code changes<br>• Before merging branches<br>• Automated in CI/CD | • Run existing test suites<br>• Verify no new bugs introduced<br>• Validate existing functionality | • All testing tools<br>• CI/CD pipelines<br>• Automated test runners | • Should be comprehensive<br>• Fast feedback loop<br>• Clear pass/fail criteria |

### Critical Testing Focus Areas
- **Silent Failures**: Test error handling and edge cases
- **Edge Cases**: Boundary conditions and unexpected inputs
- **Regression Prevention**: Automated testing for existing features
- **Data Integrity**: Database operations and data validation
- **API Reliability**: External service integration testing
- **User Experience**: UI/UX consistency and accessibility

### Testing Implementation Strategy
```bash
# Unit Testing (Jest)
npm test                    # Run all tests
npm test --watch          # Watch mode
npm test --coverage       # Coverage report

# E2E Testing (Playwright)
npx playwright test       # Run E2E tests
npx playwright test --ui  # Interactive mode
npx playwright test --headed  # Run with browser UI

# API Testing (Postman/Newman)
newman run collection.json  # Run API tests
```

### Additional Testing Strategies
- **Load Testing**: Use tools like Artillery or k6 for performance testing
- **Security Testing**: Implement OWASP security testing practices
- **Accessibility Testing**: Ensure WCAG compliance
- **Cross-Browser Testing**: Test across different browsers and devices
- **Database Testing**: Test migrations, constraints, and data integrity
- **Error Boundary Testing**: Test application error handling
- **Concurrent User Testing**: Test multi-user scenarios
- **Data Migration Testing**: Test data transformation and migration scripts

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

### Technology Choices
- Always prefer open-source solutions
- Avoid vendor lock-in whenever possible
- Use free/generous tiers for initial development
- Simplicity wins over complexity
- Every piece of code must have a purpose

### Architecture Guidelines
- Keep it simple - don't introduce complexity without clear need
- Containerize only when necessary - start simple, scale as needed
- Use established patterns - don't reinvent the wheel
- Focus on maintainability - clean, documented code

## Solution Guidelines

### Always Consider
- Is this the simplest approach?
- Can this be done with existing tools?
- What's the maintenance burden?
- Is there vendor lock-in?
- Does this align with my tech preferences?

### Red Flags to Call Out
- Over-engineering simple problems
- Adding unnecessary dependencies
- Complex solutions for straightforward tasks
- Vendor-specific implementations when open alternatives exist

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