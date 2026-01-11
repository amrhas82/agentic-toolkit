# Documentation Structure

```
/docs
├── 00-context                # WHY and WHAT EXISTS RIGHT NOW
│   ├── vision.md             # Product purpose & boundaries (anchor)
│   ├── assumptions.md        # Assumptions, risks, unknowns
│   └── system-state.md       # What is actually built & running
├── 01-product                # WHAT the product must do
│   └── prd.md                # Single source of truth for requirements
├── 02-features               # HOW features are designed & built
│   └── feature-<name>/
│       ├── feature-spec.md   # User intent & acceptance criteria
│       ├── tech-design.md    # Architecture & implementation approach
│       ├── dev-tasks.md      # LLM-executable tasks
│       └── test-plan.md      # Validation strategy
├── 03-logs                   # MEMORY (this is what most teams miss)
│   ├── implementation-log.md # What changed in code & why
│   ├── decisions-log.md      # Architectural & product decisions
│   ├── bug-log.md            # Bugs, fixes, regressions
│   ├── validation-log.md     # What happened after shipping
│   └── insights.md           # Learnings & future improvements
├── 04-process                # HOW to work with this system
│   ├── dev-workflow.md       # Daily dev loop (human + LLM)
│   ├── definition-of-done.md # When docs/code are "done"
│   └── llm-prompts.md        # Canonical prompts per doc type
└── README.md                 # How to use this repo
```
