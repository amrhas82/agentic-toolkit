# Market Research Brief Template

Use this template to structure raw ideas into research-ready briefs. Sections marked [REQUIRED] are essential; others improve quality but can be omitted for speed.

---

## Market Research Brief: [Working Title]

### 1. The Seed [REQUIRED]

*Preserve the user's original notes verbatim. Do not edit, sanitize, or restructure. This captures authentic initial thinking and provides raw signal for research.*

```
[Paste raw notes here exactly as provided]
```

---

### 2. Problem Hypothesis

**Who** might have this problem:
<!-- Target customer/user segment. Be specific: "mid-size SaaS companies with 50-200 employees" not just "businesses" -->

**What** the problem might be:
<!-- The actual pain, frustration, or inefficiency. Focus on the problem, not your solution. -->

**Why** it matters to them:
<!-- Consequences of the problem. What happens if they don't solve it? What's the cost? -->

**Why** it persists:
<!-- Why hasn't this been solved already? What's blocking existing solutions? -->

**Current workarounds**:
<!-- How are people dealing with this today? What's their makeshift solution? -->

**Confidence level**: [ ] Low  [ ] Medium  [ ] High

---

### 3. Solution Direction

**General approach**:
<!-- High-level description of the solution concept. Not features—the core idea. -->

**Core insight or advantage**:
<!-- What do you believe that others don't? What's the non-obvious angle? -->

**What makes it different**:
<!-- How does this differ from existing alternatives? Why would someone switch? -->

**Confidence level**: [ ] Low  [ ] Medium  [ ] High

---

### 4. Assumptions to Validate [REQUIRED]

*List beliefs that must be true for this to work. Frame as testable hypotheses.*

| # | Assumption | Confidence | How to Test |
|---|------------|------------|-------------|
| 1 | | [ ] Low [ ] Med [ ] High | |
| 2 | | [ ] Low [ ] Med [ ] High | |
| 3 | | [ ] Low [ ] Med [ ] High | |
| 4 | | [ ] Low [ ] Med [ ] High | |
| 5 | | [ ] Low [ ] Med [ ] High | |

---

### 5. Research Objectives [REQUIRED]

**Priority questions** (what decisions depend on this research?):

1.
2.
3.

**Decision this research informs**:
<!-- Be explicit: "Whether to pursue this idea" / "Which customer segment to target first" / "What pricing model to use" -->

**What would make you abandon this idea?**
<!-- Kill criteria. What findings would signal this isn't worth pursuing? -->

**What would make you pursue aggressively?**
<!-- Green light criteria. What findings would signal strong opportunity? -->

**Nice to know** (lower priority):
-
-

---

### 6. Constraints & Context

**Industry/domain**:
<!-- What sector or vertical? Any domain-specific considerations? -->

**Geographic scope**:
<!-- Global, regional, or specific markets? -->

**Known competitors or alternatives**:
<!-- List any you're already aware of -->

**Budget range** (if relevant to scope):
<!-- Helps calibrate research depth -->

**Timeline pressure** (if relevant):
<!-- Any deadlines driving urgency? -->

**Other constraints**:
<!-- Regulatory, technical, resource, or other limitations -->

---

### 7. Research Scope Preference [REQUIRED]

Select one:

- [ ] **Broad Exploration** — Early stage, many unknowns, need landscape understanding
- [ ] **Focused Validation** — Have specific hypotheses to test, need confirmation/refutation
- [ ] **Competitive Deep-Dive** — Know the space, need detailed competitive intelligence

---

## Template Usage Notes

### For Minimum Viable Brief
Only sections 1, 4, 5, and 7 are required. This produces a brief that:
- Preserves the raw idea
- Lists testable assumptions
- Connects to decision-making
- Sets appropriate scope

### Confidence Level Guide
- **Low**: Gut feeling, no evidence, pure speculation
- **Medium**: Some indirect evidence, informed guess, pattern matching from adjacent domains
- **High**: Direct evidence, customer conversations, data, or strong domain expertise

### Assumption Quality
Good assumptions are:
- Specific enough to be proven wrong
- Important enough that being wrong matters
- Testable through research (not just "wait and see")

Bad: "Customers will like this"
Good: "Mid-market SaaS CTOs spend >5 hours/week on manual reporting tasks"

---

## Handoff to @business-analyst

Copy the completed brief and invoke:

```
@business-analyst *perform-market-research

**Research Mode: [Broad Exploration | Focused Validation | Competitive Deep-Dive]**

[Paste completed brief here]
```

The business-analyst agent will:
1. Review the brief and research objectives
2. Conduct market research based on selected mode
3. Validate or refute assumptions with evidence
4. Provide actionable implications and recommendations
5. Optionally output to `/docs` via `*doc-out` command

---

## Next Steps After Research

After market research is complete, consider:

1. **Proceed to design exploration** (`/brainstorming`)
   - If research validated the opportunity
   - Need to explore solution approaches

2. **Proceed to PRD creation** (`@1-create-prd`)
   - If research + approach are clear
   - Ready to document requirements for implementation

3. **Iterate on research**
   - If key assumptions remain unvalidated
   - Need deeper competitive or customer analysis
