# PRD Input Brief Template

Use this template to structure input for the `@1-create-prd` agent. Optimized to give the PRD agent a head start while preserving space for its clarifying questions.

---

## PRD Input Brief: [Feature Name]

### Raw Idea

*Preserve the user's original notes verbatim. The PRD agent uses this as grounding context.*

```
[Paste raw notes here exactly as provided]
```

---

### Problem & Goals

**Problem being solved:**
<!-- What pain point, frustration, or inefficiency does this address? -->

**Primary goal:**
<!-- One sentence: what does success look like? -->

**Goal type:**
- [ ] A) Increase engagement
- [ ] B) Reduce friction
- [ ] C) Add capability
- [ ] D) Fix bug/issue
- [ ] E) Other: _______________

**Why now?**
<!-- What's driving the urgency or priority? -->

---

### Target Users

**Primary user persona:**
<!-- Who will use this most? Be specific. -->

**User's current workflow:**
<!-- How do they accomplish this today? What's painful about it? -->

**Secondary users (if any):**
<!-- Other user types who will interact with this -->

**User expertise level:**
- [ ] Novice (needs guidance)
- [ ] Intermediate (knows basics)
- [ ] Expert (power user)

---

### Core Functionality

**Key actions users should perform:**
1.
2.
3.
4.
5.

**Must-have features (v1):**
-
-
-

**Nice-to-have features (can defer):**
-
-

---

### User Stories (Draft)

*Format: "As a [user], I want to [action] so that [benefit]"*

**Primary story:**
> As a _______________, I want to _______________ so that _______________.

**Secondary stories:**
> As a _______________, I want to _______________ so that _______________.

> As a _______________, I want to _______________ so that _______________.

**Edge case stories:**
> As a _______________, I want to _______________ so that _______________.

---

### Acceptance Criteria (Draft)

*How will we know each feature is successfully implemented?*

**For [Feature 1]:**
- [ ] Given ___, when ___, then ___
- [ ] Given ___, when ___, then ___

**For [Feature 2]:**
- [ ] Given ___, when ___, then ___
- [ ] Given ___, when ___, then ___

---

### Testing & Verification

**Testing types needed:**
- [ ] A) Unit tests
- [ ] B) Integration tests
- [ ] C) Manual QA testing
- [ ] D) End-to-end tests
- [ ] E) Combination (specify): _______________
- [ ] F) Other: _______________

**Critical paths to test:**
-
-

---

### Scope & Boundaries

**In scope:**
-
-
-

**Non-goals (explicitly out of scope):**
-
-
-

**Deferred to future versions:**
-
-

---

### Data Requirements

**Data this feature needs:**
<!-- What data inputs are required? Where does it come from? -->

**Data this feature produces:**
<!-- What data outputs are created? Where does it go? -->

**Data type:**
- [ ] A) User-generated content
- [ ] B) System/computed data
- [ ] C) External API data
- [ ] D) Stored/persisted data
- [ ] E) Combination: _______________

---

### Design/UI Considerations

**UI/UX requirements:**
- [ ] A) Minimal (simple, few elements)
- [ ] B) Data-rich (tables, charts, lists)
- [ ] C) Interactive (drag-drop, real-time)
- [ ] D) Other: _______________

**Mockups available?**
- [ ] Yes (location: _______________)
- [ ] No, but have rough sketches
- [ ] No, needs design input

**Existing components to use:**
<!-- Reference existing UI patterns, components, or style guides -->

**Accessibility requirements:**
<!-- WCAG level, screen reader support, keyboard navigation, etc. -->

---

### Technical Considerations

**Constraints:**
<!-- Tech stack requirements, performance targets, etc. -->

**Dependencies:**
<!-- APIs, services, libraries this depends on -->

**Integration points:**
<!-- Existing systems this connects to -->

**Security considerations:**
<!-- Auth, data privacy, compliance requirements -->

---

### Edge Cases & Error Conditions

**Known edge cases:**
-
-
-

**Error conditions to handle:**
-
-
-

**Graceful degradation:**
<!-- What happens when things fail? Offline mode? -->

---

### Open Questions

*Questions for the PRD agent to help resolve:*

1.
2.
3.

---

### Confidence Assessment

| Section | Confidence | Notes |
|---------|------------|-------|
| Problem & Goals | High / Medium / Low | |
| Target Users | High / Medium / Low | |
| Core Functionality | High / Medium / Low | |
| User Stories | High / Medium / Low | |
| Acceptance Criteria | High / Medium / Low | |
| Non-Goals | High / Medium / Low | |

---

## Handoff to @1-create-prd

Copy the completed brief and invoke:

```
@1-create-prd

[Paste completed brief here]
```

The PRD agent will:
1. Review the brief
2. Ask 5-10 clarifying questions (with lettered/numbered options)
3. Generate comprehensive PRD following its structure
4. Save as `/tasks/[n]-prd-[feature-name].md`
5. Optionally invoke `@2-generate-tasks` for implementation task list

---

## Template Usage Notes

### What Makes a Good PRD Input

**Essential (PRD agent will ask if missing):**
- Problem statement
- Target user
- Core functionality (3-5 key actions)

**Helpful (reduces back-and-forth):**
- Draft user stories
- Non-goals/scope boundaries
- Acceptance criteria sketches

**Optional (agent can help develop):**
- Technical considerations
- Edge cases
- Design details

### Filling Gaps

For sections you can't complete:
- Write "TBD" or "Unknown"
- Add a note: "(Need input from [stakeholder])"
- Include in Open Questions section

This signals to the PRD agent where to focus its clarifying questions.

### Pre-PRD Checklist

Before handoff, verify:
- [ ] Problem is clearly stated
- [ ] At least one user persona defined
- [ ] 3+ core features/actions listed
- [ ] Non-goals stated (even if just "nothing out of scope yet")
- [ ] Open questions captured
