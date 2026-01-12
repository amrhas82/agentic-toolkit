---
name: market-research-brief
description: This skill transforms loose ideas, notes, or rough concepts into structured briefs optimized for downstream workflows. Use when a user has raw notes about a new idea and needs to prepare input for market research (business-analyst), design exploration (/brainstorming), or formal requirements (1-create-prd). Routes to optimal destination based on user's stage and needs.
---

# Idea-to-Brief Transformer

## Overview

This skill converts unstructured idea fragments into structured briefs optimized for three downstream destinations:

| Destination | Agent/Skill | When to Use | Output Focus |
|-------------|-------------|-------------|--------------|
| **Market Research** | `@business-analyst` | Validate assumptions, understand market | Hypotheses, competitors, customer needs |
| **Design Exploration** | `/brainstorming` | Explore approaches, refine the idea | Purpose, constraints, success criteria |
| **PRD Creation** | `@1-create-prd` | Document requirements for implementation | Users, functionality, acceptance criteria |

## When to Use

- User has "loose notes" or "rough ideas" about a new product/feature
- User wants to prepare input for research, brainstorming, or PRD creation
- User is unsure which downstream workflow to use
- User wants help articulating what they're trying to build/validate

## Workflow

### Phase 1: Capture Raw Input

Accept the user's unfiltered notes in any format. Reassure users that incomplete, messy input is fine—the skill's purpose is to add structure.

Accepted formats:
- Bullet points, keywords, phrases
- Stream of consciousness
- Voice transcript dumps
- Existing documents or snippets

### Phase 2: Destination Selection

Based on the raw input, recommend a destination. Present as numbered options:

```
Based on your notes, I recommend:

1. **Market Research** (Recommended if unsure)
   - You have untested assumptions about customers or market
   - You want to validate the problem exists before building
   - You're entering an unfamiliar domain

2. **Design Exploration**
   - You're confident the problem is real
   - You need to explore different solution approaches
   - You want collaborative refinement before formalizing

3. **PRD Creation**
   - You know what you want to build
   - You need formal documentation for implementation
   - You're ready to hand off to developers

Which destination? (1/2/3)
```

**Routing heuristics:**

| Signal in Raw Notes | Likely Destination |
|---------------------|-------------------|
| Questions like "would people pay for...?" | Market Research |
| "I think customers want..." (unvalidated) | Market Research |
| Multiple solution ideas, unsure which | Design Exploration |
| "How should we approach...?" | Design Exploration |
| Clear problem + solution, needs documentation | PRD Creation |
| "Build feature that does X" (well-defined) | PRD Creation |

### Phase 3: Destination-Specific Elicitation

Once destination is selected, ask targeted questions. Use numbered/lettered options for quick responses.

---

#### Path A: Market Research

**Focus:** Validate assumptions before building

**Elicitation Questions:**

1. **Problem Hypothesis**
   - Who do you think has this problem? (A) Consumers, B) SMBs, C) Enterprise, D) Other)
   - What's the actual pain/frustration?
   - How confident are you this problem is real? (1-5)

2. **Customer Hypothesis**
   - How are people solving this today?
   - What would make them switch to something new?

3. **Market Assumptions**
   - Who are the known competitors? (List or "unsure")
   - What do you believe that others might not?

4. **Research Objectives**
   - What decision does this research inform? (A) Go/no-go, B) Which segment to target, C) Pricing, D) Positioning, E) Other)
   - What finding would make you abandon this idea?

5. **Scope**
   - Broad exploration, focused validation, or competitive deep-dive?

**Output:** Use template in `references/input-template.md`

---

#### Path B: Design Exploration

**Focus:** Refine the idea into a buildable design

**Elicitation Questions:**

1. **Purpose**
   - In one sentence, what should this enable users to do?
   - Why does this matter? What's the "so what"?

2. **Success Criteria**
   - How will you know if this works? (A) User adoption, B) Time saved, C) Revenue, D) Error reduction, E) Other)
   - What does "good enough" look like for v1?

3. **Constraints**
   - Technical constraints? (A) Must use existing stack, B) Greenfield, C) Specific tech required, D) Unsure)
   - Timeline pressure? (A) ASAP, B) Weeks, C) Flexible)
   - Resource constraints?

4. **Context**
   - Does this integrate with existing systems? Which ones?
   - Are there design patterns or UX conventions to follow?

5. **Scope Boundaries**
   - What should this explicitly NOT do?
   - What's out of scope for the first version?

**Output:** Use template in `references/brainstorming-output.md`

---

#### Path C: PRD Creation

**Focus:** Document requirements for implementation handoff

**Elicitation Questions:**

1. **Problem & Goals**
   - What problem does this solve? (A) Reduce friction, B) Add capability, C) Increase engagement, D) Fix bug, E) Other)
   - Primary goal in one sentence?

2. **Target Users**
   - Who will use this? (Provide persona options based on notes)
   - What's their current workflow?

3. **Core Functionality**
   - What are the 3-5 key actions users should perform?
   - Any must-have features vs. nice-to-haves?

4. **User Stories**
   - Help user formulate: "As a [user], I want to [action] so that [benefit]"
   - Cover primary and edge case scenarios

5. **Acceptance Criteria**
   - How will we know each feature is done?
   - What testing is needed? (A) Unit, B) Integration, C) E2E, D) Manual QA, E) Combination)

6. **Non-Goals**
   - What is explicitly NOT in scope?
   - What should be deferred to future versions?

7. **Design/Technical Considerations**
   - UI/UX requirements or mockups?
   - Technical constraints or dependencies?
   - Data requirements?

**Output:** Use template in `references/prd-input-template.md`

---

### Phase 4: Generate Output

Transform captured information into the destination-specific template. Ensure:

1. **Raw notes preserved** in a dedicated section (maintains authentic signal)
2. **Confidence levels marked** where applicable
3. **Gaps acknowledged** rather than glossed over
4. **Handoff instructions included** for the destination agent/skill

### Phase 5: Handoff

Provide the formatted brief with explicit handoff command:

**For Market Research:**
```
@business-analyst *perform-market-research

**Research Mode: [Broad Exploration | Focused Validation | Competitive Deep-Dive]**

[Completed brief from input-template.md]
```

**For Design Exploration:**
```
/brainstorming

[Completed brief from brainstorming-output.md]
```

**For PRD Creation:**
```
@1-create-prd

[Completed brief from prd-input-template.md]
```

## Minimum Viable Brief

When users want speed over completeness:

| Destination | Minimum Required |
|-------------|------------------|
| Market Research | Raw idea + 1-3 assumptions to test + decision it informs |
| Brainstorming | Raw idea + purpose statement + success criteria |
| PRD Creation | Raw idea + target user + 3 core features |

## Quality Markers

A well-formed brief exhibits:

- [ ] Raw input preserved verbatim
- [ ] Destination-appropriate structure
- [ ] Confidence levels on uncertain claims
- [ ] Explicit gaps/unknowns acknowledged
- [ ] Clear handoff instructions
- [ ] Scope boundaries defined

## Sequential Workflow Support

Users often progress through destinations sequentially:

```
Raw Notes → Market Research → Brainstorming → PRD
```

This skill can re-engage at any transition point. After completing one phase, ask:

"Research complete. Would you like to:
1. Proceed to design exploration (/brainstorming)
2. Jump to PRD creation (@1-create-prd)
3. Done for now"

## Resources

### references/
- `input-template.md` - Market research brief template (for @business-analyst)
- `brainstorming-output.md` - Design exploration brief template (for /brainstorming)
- `prd-input-template.md` - PRD input brief template (for @1-create-prd)
- `research-modes.md` - Guidance on market research scope modes
