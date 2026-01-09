# Design Exploration Brief Template

Use this template to structure input for the `/brainstorming` skill. Optimized to enable collaborative design refinement through natural dialogue.

---

## Design Exploration Brief: [Working Title]

### Raw Idea

*Preserve the user's original notes verbatim. This provides authentic context for exploration.*

```
[Paste raw notes here exactly as provided]
```

---

### Purpose Statement

**What this enables users to do:**
<!-- One clear sentence: "[User] can [action] to [outcome]" -->

**Why it matters (the "so what"):**
<!-- What happens if this doesn't exist? What's the cost of the status quo? -->

**Problem being solved:**
<!-- The underlying pain point or inefficiency -->

---

### Success Criteria

**How we'll know it works:**
<!-- Pick primary metric: adoption, time saved, revenue, error reduction, engagement, etc. -->

**"Good enough" for v1:**
<!-- What's the minimum bar? What can wait for v2? -->

**Anti-goals (what success is NOT):**
<!-- Prevent scope creep by defining what you're not optimizing for -->

---

### Constraints

**Technical:**
- [ ] Must use existing stack: _______________
- [ ] Greenfield (no constraints)
- [ ] Specific tech required: _______________
- [ ] Unknown/to be determined

**Timeline:**
- [ ] ASAP (days)
- [ ] Short-term (weeks)
- [ ] Flexible (months)

**Resources:**
<!-- Team size, budget, expertise available -->

**Other constraints:**
<!-- Regulatory, security, accessibility, etc. -->

---

### Context

**Existing systems this integrates with:**
<!-- APIs, databases, services, UI components -->

**Design patterns or conventions to follow:**
<!-- Existing UX patterns, component libraries, style guides -->

**Prior art or inspiration:**
<!-- Similar features elsewhere, competitor examples, internal precedents -->

**User context:**
<!-- Who uses this? What's their workflow? What do they already know? -->

---

### Scope Boundaries

**In scope for this exploration:**
-
-
-

**Explicitly out of scope:**
-
-
-

**Deferred to future versions:**
-
-

---

### Open Questions

*Questions the brainstorming session should help answer:*

1.
2.
3.

---

### Approaches to Consider (Optional)

*If the user already has ideas about potential approaches, list them here. Otherwise leave blank—brainstorming will generate options.*

**Approach A:**

**Approach B:**

**Approach C:**

---

## Handoff to /brainstorming

Copy the completed brief and invoke:

```
/brainstorming

[Paste completed brief here]
```

The brainstorming skill will:
1. Review the brief and project context
2. Ask clarifying questions one at a time
3. Propose 2-3 approaches with tradeoffs
4. Present design in sections for incremental validation
5. Write validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`

---

## Template Usage Notes

### What Makes a Good Brainstorming Input

**Essential:**
- Clear purpose statement (what + why)
- Success criteria (how you'll measure)
- Known constraints (technical, timeline, resources)

**Helpful:**
- Integration context (what this connects to)
- Scope boundaries (what's NOT included)
- Open questions (what you need help deciding)

**Optional:**
- Pre-existing approach ideas
- Prior art references

### Confidence Markers

When filling sections, indicate certainty:
- **Confident:** No marker needed
- **Best guess:** Add "(tentative)"
- **Unknown:** Add "(to be determined)" or "TBD"

This helps brainstorming know where to probe deeper.
