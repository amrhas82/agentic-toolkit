# Vibecoding 101 Guide

**Status**: 🚧 In Active Development

A comprehensive guide for non-coders and vibecoders on building software with AI agents.

## What You'll Learn

- What vibecoding is and who it's for
- How to choose AI tools and models
- Understanding context windows and pricing models
- The 3-phase workflow (PRD → Tasks → Implementation)
- Avoiding common pitfalls (the $1,000 UI trap)
- Building sustainably without burning budget

## Detailed Section Breakdown

### ✅ Completed Sections (0-7)

**Section 0: The Agentic Field - What You're Actually Getting Into**
- Three Tiers of AI Assistance (Chat AI, Code Agents, Agentic Workflows)
- The path most beginners take (and why it fails)
- Uncomfortable truth about AI coding (what AI removes vs what it doesn't)
- Hidden traps: UI trap, context windows, possible tuning, sunk cost trap
- How successful non-coders actually do this (month-by-month progression)
- Real wisdom from experience (price shocks, tool diversity, CLI benefits, GitHub from Day 1)

**Section 1: The UI Trap - Why Most Beginners Fail**
- Week-by-week failure pattern (honeymoon → cracks → spiral → wall)
- Why it happens: the invisible 90% (database, auth, error handling vs UI)
- The delusion of progress (80% UI complete ≠ 80% app complete)
- Back-to-back prompting death spiral
- Context window reality during the trap
- Feature creep and MVP death
- The $1,000 mistake (real costs breakdown)
- When to restart vs keep fixing
- Critical AI problem: models won't tell you to stop
- How to actually avoid the trap

**Section 2: Your First 48 Hours - Practical Starting Plan**
- Hours 0-2: Tool setup (OS choice, AI tool selection, access methods)
- Hours 2-4: Free model access (OpenCode CLI, OpenRouter, free tiers)
- Hours 4-6: GitHub setup (Day 1, not eventually)
- Hours 6-8: The 3-step method (templates that guide agents)
- Hours 8-24: Execute first project (simplest, silliest thing)
- Hours 24-48: Core first, UI last (if not working ugly, won't work beautiful)
- 48-hour checklist (7+ items = on track)
- Red flags vs green flags
- Budget reality ($0, $20, $40 options)

**Section 3: Model Landscape - Western vs Chinese, Pricing, 50/50 Framework**
- The 50/50 framework (structure + right model mix)
- Three access methods: CLI, IDE, Web
- Western vs Chinese models (engagement training vs directness training)
- Model personalities (DeepSeek, ChatGPT, Claude, Copilot, GLM, Gemini)
- Real setup example ($40/month multi-tool strategy)
- Pricing reality (Western API vs Chinese API costs)
- Free tier viability (DeepSeek, GLM, Gemini, Grok, Poe)
- Anti-vendor lock-in philosophy
- 5-hour reset as feature, not limitation

**Section 4: Temperature Explained - Control Without Changing Personality**
- What temperature actually is (randomness control, NOT personality)
- Temperature scale (0.0-0.3 deterministic, 0.5-0.7 balanced, 1.2-1.5 creative, 1.8-2.0 chaotic)
- Real examples: Restaurant review bot, yoga planning bot at 0.5
- Core tradeoff (consistency vs creativity)
- When to use low temperature (specialized agents, one job)
- When to use high temperature (strategic, creative roles)
- Failure modes of high temperature (breaking character, context bloat, customer frustration)
- Web vs CLI differences (hidden vs visible control)
- Temperature vs personality: they're orthogonal
- Guardrailing reduction: 50% → 1-2% with persona MD files

**Section 5: Access Methods Deep Dive - Why CLI Changes Everything**
- The problem with web (Replit time breakdown: 50% guardrailing, 25% fixing, 25% exhausted)
- CLI transformation (50% guardrailing → 1-2% with @subagent invocation)
- Why CLI won (repo control, local testing, context visibility, agent invocation)
- The 5-hour reset as feature (forces planning, prevents spirals)
- Persona MD files replace constant guardrailing
- Web vs CLI vs Plugin comparison
- OpenRouter + OpenCode free tier strategy
- GLM comparable to Claude at fraction of price
- Kilocode plugin: similar to CLI but GUI overhead

**Section 6: Approaches Spectrum - Finding the Right Structure**
- Manual PM workflow: DeepSeek research → OneNote tracking → Replit execution (exhausting)
- The breakthrough: 3-step + Claude CLI
- Guardrailing shift: 50% → 1-2% with agent-driven planning
- When vibecoding works vs fails (single file vs multi-file)
- Three approaches: Vibecoding, 3-Step, BMAD Hybrid
- BMAD compaction (22 tasks → 13 subagents optimized)
- Why Replit failed (can't invoke agents, no repo control, hidden context)
- Real cost shift: $50/day → sustainable monthly
- The real win: agent planning, not manual PM work
- Tool + framework together (framework on bad tool still fails)

**Section 7: Context Windows - The Invisible Constraint**
- Wrong mental model: "preserve memory" by staying in same chat
- What actually happened (Week 4-5: AI starts lying, hallucinating)
- Hallucination symptoms (claimed work done, wrong file, breaks things, forgets, slow, over-apologetic)
- The backwards logic: staying in same window CAUSES hallucinations
- Web hides it, CLI shows it (`/context` command)
- The 75% rule (proactive reset prevents hallucinations)
- Fresh context protocol (continuation doc, 2-3% cost, prevents 20-30% waste)
- Context fill rates (UI changes 1-2%, complex features 3-5%, bug fixes 0.5-1%)
- Precision effect (vague prompts fill context faster)
- Cost comparison (with resets vs without)
- Why tools don't explain this (longer chats = more tokens = more profit)

### 🚧 In Development (8-12)

**Section 8: Pricing Reality** (Ready for elicitation)
- What context windows cost (hallucinations = wasted tokens)
- Subscription vs API/pay-as-you-go model breakdown
- $20/month club (Claude Code, Cursor, ChatGPT Plus) and what the reset limit actually does
- API pricing: Western ($1-3 input / $10-15 output) vs Chinese ($0.02-0.6 input / $0.28-2.2 output)
- Output tokens 2-5x more expensive than input (model verbosity matters)
- The $1,000 Replit story (timeline, breakdown, what actually burned the budget)
- Pay-as-you-go psychology (daily charges = sunk cost trap)
- Free tier viability (real limits, when to upgrade)
- Cost tracking strategies (track weekly? monthly? per-project?)
- Budget recommendations by skill level (beginner, intermediate, advanced)
- Economic sustainability (what costs can't be sustained, what can)
- The 5-hour reset as economic feature (forces proactivity, prevents spirals)
- When to pay vs when to stay free
- How much of Replit $1,000 was context mismanagement vs actual building

**Section 9: Technical Essentials** (Ready for elicitation)
Topics to cover:
- GitHub workflow - how does he actually use it?
- Dev/staging/prod - does he use this locally?
- Localhost vs cloud preference?
- Database choices in practice?
- Any vendor lock-in experiences?
- Technical setup that prevents common failures
- Tools and environment configuration
- Version control best practices
- Deployment strategies for vibecoders

**Section 10: MVP Priorities** (Ready for elicitation)
Topics to cover:
- UI trap personal experience - what was his MVP?
- How does he define "done" now?
- Feature creep examples?
- When does he polish UI?
- Validation strategy?
- Core-first, UI-last methodology
- What belongs in MVP vs what doesn't
- How to recognize scope creep
- Testing strategies for MVP validation

**Section 11: Comparison Tables & Quick Reference**
- Tool comparison matrix (Web vs CLI vs IDE)
- Framework comparison (Simple vs 3-Step vs BMAD)
- Model comparison (Western vs Chinese, by use case)
- Cost comparison (Free vs Subscription vs Pay-as-you-go)
- When-to-use decision trees
- Quick reference cards
- Troubleshooting matrix

**Section 12: FAQ & Glossary**
- Top questions from 82-question research
- Common beginner mistakes
- Quick answers and references
- Troubleshooting guide
- **Glossary**: guardrailing, persona MD, config.json, context window, temperature, hallucination, spec engineering, UI trap, sunk cost trap, token, API, CLI, IDE, MCP, subagent, workflow agent, BMAD, 3-step method, vibecoding

## Preview Available

The guide is being developed collaboratively with real-world experience, data analysis, and practical examples.

**Follow progress:** This will be published when complete (estimated ~35,000 words covering 12 comprehensive sections).

## Want to Get Started Now?

While the full guide is in development, you can:

1. **Try the subagents** - [Quick Start Guide](../ai/subagents/subagentic-manual.md)
2. **Read AGENT_RULES** - [Generic AI collaboration guidelines](../ai/AGENT_RULES.md)
3. **Join Discord** - [Get help from the community](https://discord.gg/SDaSrH3J8d)

---

**Note**: This guide is being written based on real experience building with AI, including hard-won lessons from burning $1,000+ on the wrong tools and approaches. It will be published when complete to ensure accuracy and comprehensive coverage.
