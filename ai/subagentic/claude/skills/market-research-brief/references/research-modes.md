# Research Scope Modes

This reference details the three research modes available when handing off a brief to the business-analyst agent. Select based on the user's stage and information needs.

---

## Mode 1: Broad Exploration

**Best for:** Early-stage ideas, unfamiliar domains, high uncertainty

### Characteristics
- User is new to the space or has limited domain knowledge
- Many foundational questions remain unanswered
- Problem and solution hypotheses are fuzzy
- User needs to understand the landscape before narrowing focus

### Research Focus Areas
1. **Market Structure** — Who are the players? How is the market segmented?
2. **Customer Landscape** — Who has this problem? How do they currently solve it?
3. **Trend Analysis** — What's changing in this space? What's driving change?
4. **Problem Validation** — Does the problem exist at scale? Is it painful enough?
5. **Solution Landscape** — What solutions exist? Where are the gaps?

### Output Emphasis
- Broad survey over deep analysis
- Multiple customer segment profiles
- Macro trends and market dynamics
- Discovery of unknowns (things user didn't know to ask about)
- Options and directions for further investigation

### Typical User Statements
- "I'm not sure who the customer even is yet"
- "I don't know much about this space"
- "Help me understand what's out there"
- "I have a rough idea but need to validate it's real"

---

## Mode 2: Focused Validation

**Best for:** Testing specific hypotheses, de-risking assumptions, go/no-go decisions

### Characteristics
- User has clear hypotheses they want to test
- Specific assumptions are documented and need validation
- User is approaching a decision point
- Prior exploration has been done; now need confirmation

### Research Focus Areas
1. **Assumption Testing** — Direct investigation of stated hypotheses
2. **Evidence Gathering** — Data, quotes, examples that support or refute
3. **Segment Validation** — Does target segment exist and behave as expected?
4. **Willingness to Pay** — Price sensitivity, budget availability
5. **Competitive Positioning** — Is the differentiation real and valued?

### Output Emphasis
- Verdict on each assumption (confirmed/refuted/inconclusive)
- Supporting evidence for conclusions
- Confidence levels with reasoning
- Clear implications for the decision at hand
- Recommendations based on findings

### Typical User Statements
- "I need to validate these assumptions before proceeding"
- "Is this hypothesis actually true?"
- "I'm trying to decide whether to build this"
- "I think X is true, but I need evidence"

---

## Mode 3: Competitive Deep-Dive

**Best for:** Understanding competitive dynamics, positioning strategy, differentiation

### Characteristics
- User knows the market exists and is active
- Competition is the primary concern or opportunity
- User needs detailed intelligence on specific competitors
- Strategic positioning decisions are pending

### Research Focus Areas
1. **Competitor Profiles** — Deep analysis of key players
2. **Positioning Maps** — How competitors position themselves
3. **Feature/Capability Comparison** — What each offers
4. **Pricing Analysis** — How competitors price, package, monetize
5. **Go-to-Market** — How competitors acquire customers
6. **Weaknesses & Gaps** — Where competitors fall short
7. **Differentiation Opportunities** — Underserved needs, positioning gaps

### Output Emphasis
- Detailed competitor profiles
- Comparative analysis tables
- Positioning map visualization concepts
- Gap analysis and opportunity identification
- Strategic recommendations for differentiation

### Typical User Statements
- "I know who the competitors are, but I need to understand them deeply"
- "How should I position against X?"
- "What are competitors doing that we should/shouldn't copy?"
- "Where can I differentiate?"

---

## Mode Selection Guide

| Signal | Recommended Mode |
|--------|------------------|
| "I don't know the market" | Broad Exploration |
| Low confidence across most assumptions | Broad Exploration |
| No competitors identified | Broad Exploration |
| "Is my assumption about X true?" | Focused Validation |
| Go/no-go decision pending | Focused Validation |
| Specific hypotheses documented | Focused Validation |
| Competitors already identified | Competitive Deep-Dive |
| "How do I differentiate?" | Competitive Deep-Dive |
| Positioning/pricing questions | Competitive Deep-Dive |

---

## Hybrid Approaches

Modes can be combined when appropriate:

**Exploration + Validation**: Start broad, then dive deep on discoveries
- Use when: User is early but has one or two specific questions

**Validation + Competitive**: Test assumptions while analyzing competition
- Use when: Assumptions relate directly to competitive positioning

**Sequential Modes**: Complete one mode, then proceed to another
- Use when: Research reveals need for different type of analysis

---

## Handoff Format

When passing the completed brief to business-analyst, include the mode explicitly:

```
@business-analyst *perform-market-research

**Research Mode: [Broad Exploration | Focused Validation | Competitive Deep-Dive]**

[Completed brief]
```

This ensures the analyst agent calibrates its approach appropriately.
