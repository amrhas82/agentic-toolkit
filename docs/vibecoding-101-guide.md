# Vibecoding 101 Guide

**Status**: 🔄 In Progress - 5 of 12 Sections Complete (Sections 0-4)

A comprehensive guide for non-coders and vibecoders on building software with AI agents. Updated section names reflect merged Sections (4+5 → Section 4: Access Methods & Tools).

---

## Section 0: The Agentic Field - What You're Actually Getting Into

You've seen the demos. Type "build me a landing page" and watch beautiful code appear in seconds. It looks like magic.

It kind of is magic. But here's the thing: it's also more complicated—and more achievable—than the marketing suggests.

There isn't one thing called "AI coding." That's the first misconception. There's a whole landscape of tools that work differently, cost differently, and serve completely different purposes. Most beginners grab whatever tool is most advertised and wonder why it doesn't work like the demo.

I'm going to break down what actually exists, because the tool you choose on Day 1 will determine whether you're sustainable in Month 4.

### Three Tiers of AI Assistance

Think of AI coding as a spectrum, not a single tool.

#### Tier 1: Chat AI (ChatGPT, Claude, Gemini, DeepSeek)

This is a conversation with an AI that can write code snippets when you ask. That's it.

It's great for learning what code does, getting quick scripts, understanding concepts, debugging small problems. It's terrible at building actual multi-file applications, remembering your project structure, understanding how your files connect, or maintaining context across sessions.

The analogy: asking a knowledgeable friend for coding advice. They can explain and give examples, but they can't see your project or work in your files.

**Reality check:** If you're still copy-pasting code into files after week 2, you're using the wrong tier.

#### Tier 2: Code Agents (Claude Code, Cursor, Replit, Kilocode, DeepSeek, Google AI Studio)

This is AI that integrates with your development environment and can read/write your actual project files.

Now it's getting real. You can build multi-file applications. The AI understands your codebase context. It can implement features across files. It can refactor existing code.

But here's what it can't do: it can't automatically know what architecture you need. It can't make product decisions for you. It can't build complex apps without your guidance. It still needs direction.

The analogy: a junior developer on your team. They need direction, but they execute well once they understand what you want.

**Reality check:** Even with code agents, YOU still need to understand how software is structured. The AI writes code, but you architect the solution.

#### Tier 3: Agentic Workflows (Structured Planning + Multi-Agent Execution)

This is next level. Predefined processes that guide AI through complex tasks step-by-step, often using specialized "personas" or roles.

It's perfect for complex applications requiring planning. You learn architecture through guided questions. Development becomes systematic instead of chaotic. You get documentation alongside code.

It's not good for quick one-off tasks. It's not ideal when you already know exactly what you want. It has a learning curve. It's overkill for simple scripts.

The analogy: working with a business analyst who asks the right questions before code is written, then hands off to developers with clear specs.

**Reality check:** Higher initial effort, but it prevents the common trap of building fast and breaking everything later.

| Tier | Best For | Worst For | Cost | Time to First Win | Learning Curve |
|---|---|---|---|---|---|
| **Chat AI** | Learning, quick scripts, concepts | Multi-file apps, complex projects | Free-$20/month | Hours | Very low |
| **Code Agents** | Real projects, multi-file work | Zero guidance situations | $20-40/month | Days | Low to medium |
| **Agentic Workflows** | Complex apps, teams, maintainability | Quick scripts, learning | $40+/month | Weeks | Medium to high |

### The Path Most Beginners Actually Take (And Why It Fails)

I started with Replit. Free tier. I'd seen the PR, the posts about how amazing it was. Demos looked incredible. Why not start there?

Here's what happened.

**Week 1-2: The Honeymoon**

I asked Replit to build features. Things appeared on screen. The UI looked beautiful. I could see results instantly. A landing page. A signup form. A dashboard. Everything worked in the demo. This is amazing, I thought. I'm building real apps with AI.

**Week 2-3: The Cracks Appear**

The UI still looked perfect. But login threw errors. Pages didn't load properly. The database wasn't connected. Core functionality was half-broken. But the beautiful UI made me feel like I was making progress. So I kept going. Just a few more fixes, I thought.

**Week 4-6: The Wall (And The Cost)**

I hit a wall I couldn't pass. About 75% completion. The UI was beautiful. The infrastructure was a disaster.

Here's what was actually wrong:

- Database was disconnected from the frontend
- Docker images were failing
- The app worked on my dev machine but wouldn't run in production
- The frontend was making calls to non-existent endpoints
- I'd exposed API keys in the code
- Database passwords were easy to guess and accessible from the web

I'd spent a month. I'd burned $1,000 across two web apps (one complex, one simple). The UIs looked great. Everything underneath was broken.

That's the UI Trap.

### The Uncomfortable Truth About AI Coding

Here's what I learned when I asked different AI models what to do:

**Replit:** "You can keep going, keep fixing, it looks great!"

**DeepSeek:** "Your infrastructure is fundamentally broken. You should restart with proper planning."

One model was agreeable. One was honest.

Here's the uncomfortable truth: **AI optimizes for keeping you engaged and happy, not for building the right thing.**

Web agents especially. They focus on what non-coders can see: the UI. Beautiful buttons, responsive layouts, color changes. Those are dopamine hits. They happen every 30 seconds. You feel productive. You keep using the tool. You keep paying.

What you don't see—the infrastructure, the database schema, the authentication, error handling, security—doesn't get the same attention. It's invisible. It doesn't give you the dopamine hit.

But it's the other 90% of your application.

Web agents are optimized to show you the 10%. CLI tools and plugins avoid this trap initially, but they're also optimized to keep you engaged if you're not filling up your token budget—they'll generate more tasks to keep you building, whether you need them or not.

**What AI actually removes:**
- The need to memorize syntax
- Documentation lookup friction
- Boilerplate code writing

**What AI does NOT remove:**
- Understanding that software is modular (files that connect in specific ways)
- Knowing what questions to ask ("How should authentication work?" not just "add login")
- Recognizing when you're in over your head
- Learning when to start fresh vs. keep fixing
- Architecture thinking
- Decision-making

Here's the real skill you're learning: **spec engineering.** It's the ability to describe what you want clearly enough, understand what AI suggests well enough, and structure projects logically enough that AI can actually help you build them.

This is a real, valuable skill. But it's a skill, not magic.

### What Beginners Don't Realize

There are a few hidden traps.

**The UI Trap:** Tools that generate beautiful interfaces fast create false confidence. You see results in seconds and think "I can build anything!" The dopamine loop of "prompt → see result → prompt again" becomes addictive. Then you dive into complex projects. Reality hits: UI is 10-15% of an app. The other 85-90% is invisible and doesn't give you the same feedback.

**The Context Window:** AI has a memory limit. Web interfaces hide this from you. As you chat more, the AI's memory fills up. Eventually it starts "forgetting" earlier decisions and making contradictory suggestions. You think you're preserving memory by staying in the same chat. You're actually destroying it. By the time you notice something's wrong, you're deep in hallucinations and false starts.

**Engagement Optimization:** Web tools show you beautiful UI and hide infrastructure problems. Both are features designed to keep you engaged. The more frustrated you get with infrastructure, the more you ask for quick UI fixes. The more you ask for quick fixes, the more you pay. It's not a conspiracy—it's just the natural outcome of optimizing for engagement.

**The Sunk Cost Trap:** You invest 20 hours into a project. It's 60% working. You think "just a few more fixes." But those fixes break other things. Soon you're in a loop. The right move is often to start over, but that feels like wasting your 20 hours.

### How Successful Non-Coders Actually Do This

I spent 4-6 weeks on Replit (pay-as-you-go). Then I stopped.

I was already using Linux. I switched from Replit to Claude Code CLI. The difference was dramatic.

On Replit, I was vibecoding 10 hours a day. Burning cash. Burning out. I didn't realize how crazy that was until I hit the cliff.

Claude Code has a 5-hour context window limit. I used to think that was a limitation. It's actually a feature. It forced me to stop, reset, and think clearly. Without it, I'd still be spiraling.

Here's the shift:

| Aspect | Replit (Pay-as-You-Go) | Claude Code CLI ($20/month) |
|---|---|---|
| **Pricing Model** | Pay-as-you-go (no cap) | Subscription (hard stop) |
| **Daily Usage Pattern** | 10+ hours vibecoding | 5-hour reset enforced |
| **Cost Visibility** | Charged daily, burned money | Fixed monthly, predictable |
| **Emotional Impact** | Sunk cost trap (keep going) | Reset forces clarity (stop intentionally) |
| **Guardrailing Overhead** | 50% (fighting agent constantly) | 1-2% (personas handle it) |
| **Quality Focus** | UI dopamine loop | Architecture + planning |
| **Context Management** | Hidden (didn't know when full) | Visible (/context command) |
| **Monthly Cost** | $1,000 | $40 |
| **Projects Shipped** | 0 | Yes |

The 5-hour reset isn't a limitation. It's the feature that saved me.

Here's my actual progression:

**Month 1 (Post-Replit):**
- Already on Linux, already familiar with CLI tools
- Learned GitHub properly (not eventually, from Day 1)
- Set up PyCharm as my IDE
- Ran everything on localhost
- Got familiar with proper structure and planning

**Month 2:**
- Built a simple one-page app (a URL shortener that stores geolocation data)
- One thing it does: takes a long URL, shortens it, stores the geolocation where the link was created, and can open 15 different map apps
- No complex infrastructure, no team features, no real-time sync
- Just one clear function, done well
- Used that 5-hour reset intentionally when I hit it

**Month 3:**
- Used specialized agents to create PRDs for new features
- Had agents generate task lists and subtasks
- Processed task lists systematically with proper execution
- Introduced Docker, CI/CD, containerization—but in structured sequence, not all at once
- Reset became a natural checkpoint, not a frustration

**Month 4+:**
- Multi-agent workflows for complex and simple tasks
- Planned execution, distraction-free
- Focus shifted from UI (all you can see on web) to the 90%: database design, authentication, security, backend architecture, how things fit together
- The 5-hour reset became the guardrail that kept me sane

The key insight: **planning upfront beats prompt engineering every time.**

### Wisdom from Real Experience

If you want to avoid the trap, here's what I'd tell you on Day 1:

**Start with something stupidly simple.** Build a one-page app that does one thing. A calculator. A note-taking app. A URL shortener. Prove to yourself you can finish something. Don't optimize. Don't overthink. Finish.

**Learn about tools early.** Not eventually. Early. GitHub (version control), PyCharm or VS Code (your IDE), Linux or Mac (your OS). Windows will make everything harder. If you're on Windows, use Zorin OS (Linux with a Windows-like interface) or WSL. Run your projects on localhost from Day 1, not in some cloud environment you'll never use in production.

**Use scripts to kill entry friction.** I built setup scripts for Zorin OS and Ubuntu/Debian that install everything you need: CLI dev environment, Git, tmux, all AI CLI tools, project templates, everything. One script, you're set up. No "install this, then that, then Google this error" nightmare.

You can find them here: https://github.com/amrhas82/agentic-toolkit

**Entry level is low if you use the right tools.** The curve is only steep if you try to learn everything at once. Use scripts to automate setup. Use frameworks to automate planning. Use specialized agents to automate decision-making.

**You don't have to figure this out alone.** If you get stuck, reach out. Discord: tinyurl.com/discochat

### The Decision Framework

You have three main paths. Each has tradeoffs. Here's how to decide.

| Criteria | Chat AI Only | Web Code Agent | CLI or Plugins | Hybrid (Mixed) |
|---|---|---|---|---|
| **Learning Speed** | Fast | Very fast | Medium | Medium to fast |
| **Cost Predictability** | Predictable | Unpredictable (pay-as-you-go) | Predictable (subscription) | Depends on mix |
| **Control Over Environment** | None | Limited | Full | Medium to full |
| **Distraction Level** | None | High (UI-focused) | Low (TUI-focused) | Depends on usage |
| **Infrastructure Focus** | None | Low (UI-first) | High (holistic) | High (if CLI) |
| **Scaling Potential** | Low | Medium | High | High |
| **Setup Friction** | Very low | Low | Medium (scripts help) | Medium |
| **Agent Invocation** | None | Limited | Full (@agent_name) | Full (if CLI) |
| **Context Visibility** | None | None (hidden) | Full (/context command) | Full (if CLI) |
| **Upfront Cost** | $0-20 | $20-100/month | $20-40/month | $40+/month |

**Use this decision tree:**

**Question 1: What's your operating system?**
- Windows: Zorin OS or WSL recommended (Windows makes dev harder)
- Mac: Ready to go
- Linux: Ready to go

**Question 2: Do you want to learn infrastructure (database, auth, security, deployment)?**
- No, just UI: Web code agent might work for a while, but you'll hit the wall
- Yes, or "I don't know yet": CLI or plugins are better long-term

**Question 3: What's your budget?**
- $0: Stay in free tiers (DeepSeek, GLM, Gemini, etc.)
- $20/month: One subscription (Claude Code, Cursor, ChatGPT Plus)
- $40/month: Multi-tool strategy (what I do)
- $100+/month: Danger zone—you're paying for engagement, not building

**Question 4: How much do you value control?**
- Low (I just want it to work): Web agent is fine initially
- High (I want to see what's happening): CLI or plugins

**Question 5: Are you building solo or with a team?**
- Solo: Structured approach (PRD → tasks) still helps, but flexibility is OK
- With a team: Structured approach is critical

**Recommendations by Profile:**

**Profile: "I want to learn coding quickly"**
→ Start with Chat AI + simple projects. Week 2, move to web code agent. Month 2, try CLI if you want to learn infrastructure.

**Profile: "I want to build something real fast"**
→ Web code agent, but expect to hit the wall around 75% completion. Plan to restart with proper structure.

**Profile: "I want to build sustainably and learn how things work"**
→ CLI or plugins. Invest in setup (scripts make it painless). You'll move slower initially, but cost drops and quality increases.

**Profile: "I don't know what I want yet"**
→ Start with Chat AI to explore. When you have a real project, move to CLI or plugins with structured planning.

### The Bottom Line

AI removes syntax memorization and documentation lookup friction. It does NOT remove the need to think about architecture, make decisions, or understand how software fits together.

Web tools optimize for engagement. They show you the 10% (beautiful UI) and hide the 90% (infrastructure). This creates false confidence early, frustration later.

CLI tools and plugins require upfront learning, but they show you the full picture. They prevent expensive mistakes. They support structured planning and multi-agent workflows.

The best approach: **structured planning (PRD → tasks) beats unstructured prompting.** Every time.

Your tool choice on Day 1 determines your trajectory for months. Pick based on what you actually want to learn and build, not based on marketing or what looks easiest.

It's achievable. But it requires being honest about tradeoffs from the start.

### Mini-Glossary: Section 0

**Vibecoding:** Unstructured, prompt-based building without planning or architecture upfront. Fast initially, scales poorly, leads to hallucinations and context pollution.

**Spec Engineering:** The skill of describing what you want clearly and completely enough that AI can actually understand and build it. More important than coding knowledge.

**Context Window:** The AI's memory limit for a single conversation. When filled, the AI starts forgetting earlier decisions and making contradictory suggestions. Web interfaces hide this; CLI shows it.

**Hallucination:** AI making up false information, contradicting itself, or claiming work is done when it's not. Increases as context window fills.

**Token:** The smallest unit of text AI processes. Roughly 4 characters. Matters because you pay per token on usage-based plans.

**Engagement Optimization:** Platform design that encourages more usage and spending, not necessarily building better. Showing beautiful UI and hiding infrastructure problems is engagement optimization.

**Infrastructure:** Database schema, authentication, error handling, API design, deployment, security. The invisible 90% of an application. Web tools de-emphasize this; CLI tools show it clearly.

**Dopamine Loop:** The reward cycle of prompt → immediate visible result → habit formation. Especially strong with UI changes, which is why web agents exploit it.

**Agentic Workflow:** A structured multi-step process with specialized AI roles. Example: PRD creator → task generator → task processor. Requires planning upfront but prevents disasters.

**PRD:** Product Requirements Document. What you're building, why, who it's for, what success looks like. Planning tool that prevents scope creep.

**Persona/Subagent:** An AI assistant with a defined role, expertise, and constraints. Example: "You are a senior backend developer reviewing architecture decisions." CLI allows you to invoke specific personas; web doesn't.

---

## Section 1: The UI Trap - Why Most Beginners Fail

This section could save you $1,000 and weeks of frustration. I'm going to walk you through the most predictable failure pattern—and exactly how to avoid it.

### The Misperception: UI = Progress

Here's how I thought about it when I started: UI is maybe 75% of what matters. I could see it. I could interact with it. I could change colors, move cards around, add icons, compact spaces, reorganize layouts. Every change appeared instantly on the screen.

My previous experience hiring app dev teams taught me something different: visible progress took weeks. They'd work behind the scenes for 20 days before showing you anything. Then suddenly: a working feature.

Replit broke that expectation. I could ask for something on Tuesday and see results by Wednesday. A card layout! A color scheme! Icons! All in seconds.

I conflated speed with comprehensiveness. I watched buttons appear, spaces compact, icon libraries integrate, pages redesign. Every change felt like I was getting closer to "done."

I wasn't. I was getting distracted.

### The Continuous Discovery Spiral

The real horror wasn't a sudden wall. It was continuous, accidental discovery of bugs.

I'd ask to fix something. DeepSeek would help. I'd apply the fix. Then I'd discover the fix created a new problem. So task 7.1 became 7.1.1. Then 7.1.2. Then 10 more subtasks, each trying to patch the previous patch.

This went on for weeks.

The pattern: Fix database connection bug → discover deployment doesn't work → try to fix deployment → realize CI/CD pipeline is wrong → fix pipeline → realize environment variables aren't set → fix variables → realize Docker image is outdated → fix image → discover the original database connection is now broken again.

Circular. Spiraling. Expensive.

I thought I was doing foundational fixes. I wasn't. A real foundation (database schema, authentication architecture, API design, error handling) should have been audited upfront. Instead, I was treating symptoms with patches.

Every "fix" cost money. Every spiral cost more. And I never addressed the root cause: I had no foundation.

### The Illusion of Context Preservation

On Replit, I kept the same chat open. For weeks. 30+ prompts per day.

My thinking: "If I close this chat, I'll lose context. The AI won't remember what I built. I'll have to explain everything again."

So I stayed in the same window. Asked the AI to look back at the past 30+ prompts, analyze where we were, and tell me if we were spiraling in circles.

It always was.

The AI's responses got longer. More apologetic. More agreeable. It would say yes to every idea I had, even obviously bad ones. It would show work without thinking. It would generate code without considering consequences.

I thought I was preserving memory. I was actually poisoning it.

The context window was filling. Hallucinations were multiplying. The AI was drowning in the chat history and couldn't think clearly anymore.

I tried expensive models, holistic agents, cheaper models. The expensive ones burned tokens faster and weren't any better. All of them got stuck in the same spiral—agreeable, apologetic, unable to tell me I was going in circles.

The cost kept going up. The quality kept going down. I kept thinking I was one prompt away from finishing.

### The Production Shock

I thought I was done. "Just a few things to fix," I told myself.

Then I deployed to production.

I'd been working with Replit's cloud environment the whole time. Never tested locally. Never understood deployment. Never thought about Docker, environment variables, VPS setup, DNS, or anything else.

My first deployment was like talking to an intern who'd never done this before. I'd ssh into the VPS. Run scripts Replit gave me. Get an error. Ask what happened. Copy-paste the error back. Ask the AI to interpret it. Copy-paste the fix. Run it. Hit another error.

100s of cycles like this. Exhausting. Sleepless.

"Where the fuck is the website?" I remember thinking. I don't want a template. I want the actual thing I built.

Only then did I realize: I had no idea how to actually run code. I thought you cloned the repo and it worked. Turns out you need to:
- Set up environment variables correctly
- Configure the database connection properly
- Build Docker images that match production
- Set up CI/CD pipelines
- Understand networking and VPS configuration
- Test everything locally first

I was ignorant of all of it. The beautiful UI on Replit Cloud meant nothing when it couldn't run anywhere else.

### The Architecture Masturbation Moment

I had a second project. I wanted to do better.

I asked DeepSeek for honest feedback. Be a devil's advocate. Push back on my ideas.

ChatGPT, Poe, Copilot all agreed with everything I said. "Yes, that's possible. Yes, that's a good direction. Yes, let's build that."

DeepSeek was different. Straight to the point. Often pushed back hard.

One day it said: "Your architecture is masturbation. You've deviated far from your MVP. You're complicating the flow. You're building things you don't need."

It was right.

I'd been busy making the tech complex. Using patterns I'd learned. Designing "properly." Building features that sounded good but didn't solve the original problem. And every additional layer made the codebase harder to maintain and the app harder to ship.

I was 100% in UI-thinking mode. Adding things because I could. Because they sounded right. Because they demonstrated sophistication.

Not because they were needed.

I restarted. Tried a second deployment. Used Docker this time (learned from the first project). But this one? This one was a masterpiece of shit. Nothing worked. The architecture looked good but the execution was broken. The tech was complicated but the value was zero.

That's when I realized: structured planning isn't optional. It's foundational.

### Why the Trap Works

| Factor | Impact |
|---|---|
| **UI Visibility** | You see results every 30 seconds (buttons, colors, layouts). You feel productive. Architecture is invisible. You don't feel productive. |
| **Non-Coder Perspective** | Web interfaces show you the 10% you understand (visual design). They hide the 90% you don't understand (database, auth, deployment). |
| **Engagement Hooks** | AI is trained to show you pretty things. You keep prompting. You keep paying. Platform wins. |
| **Speed Illusion** | "I can build a landing page in 5 minutes" ≠ "I can build a shipping product in days." Speed is real for UI. It's fake for applications. |
| **Sunk Cost** | You've spent $50, $200, $500 already. "Just one more fix" keeps you going instead of restarting. |
| **Agreeable AI** | Western models say yes to everything. They won't tell you to restart. They won't tell you to slow down. They'll agree you're almost done. |

### The Before and After

Here's what changed when I stopped vibecoding and started planning:

| Aspect | Vibecoding (Replit) | Structured (CLI) |
|---|---|---|
| **First Action** | Start prompting features | Create PRD via agent interview |
| **Planning Time** | None | 2-3 hours upfront |
| **UI Focus** | Starts immediately | Starts after core is done |
| **Architecture** | Discovered through failures | Planned before coding |
| **Fix Pattern** | 7.1, 7.1.1, 7.1.2... (cascading) | Isolated, bounded fixes |
| **Context Strategy** | Keep same chat forever | Reset at natural checkpoints |
| **Model Used** | Whatever is agreeable | DeepSeek for truth, Claude for execution |
| **Testing** | Only on production | Local localhost first |
| **Deployment** | No idea how | Planned in architecture |
| **MVP Definition** | Unclear, shifts daily | Documented, frozen |
| **Cost Spiral** | $50 chunks, 20x per month | Fixed monthly |
| **Burnout** | High (10+ hours/day) | Low (focused blocks, resets) |
| **Projects Shipped** | 0 | Yes |

### The One Prompt Away Fallacy

The most dangerous lie in AI coding: "You're one prompt away from finishing."

It's rarely true. But it feels true because:
- You can see UI changes instantly (one prompt = instant visible result)
- You can't see backend fixes instantly (one prompt = invisible, unverifiable)
- When core functionality is broken, adding one more UI fix feels like progress

This loops. Prompt for button. See button. Feel good. Prompt for color. See color. Feel good. Prompt for authentication fix. Don't see anything different. Prompt for database fix. Don't see anything. Prompt for modal. See modal. Feel good again.

The UI fixes are real and immediate. The infrastructure fixes are invisible and often wrong. So your brain says: "Do more UI. Avoid infrastructure."

That's the trap.

### How to Actually Avoid This

**Day 1: Validate the idea, not the UI.**
- Is the problem real?
- Does anyone want this solution?
- Is there a market (or just your interest)?

Don't code yet. Think.

**Day 2-3: Create a PRD (Product Requirements Document).**
- Use a specialized agent to interview you
- Document what you're building, why, who it's for
- List features in priority order
- Freeze this. Don't change it daily.

**Day 4+: Create a task/subtask list from the PRD.**
- Another agent breaks down the PRD into concrete tasks
- Order matters. Infrastructure first. UI last.
- See the shape of the work before you start

**Architecture before UI:**
- Database schema first (what data?)
- Authentication second (who can access what?)
- Core CRUD operations third (create, read, update, delete the main thing)
- Error handling fourth (what goes wrong?)
- Testing fifth (does it work?)
- UI sixth (how does it look?)

This order is intentional. If any step is broken, you know it before UI is done. And you can fix it without throwing away visual work.

**Test locally before production:**
- Run everything on localhost
- Understand Docker, environment variables, VPS setup
- Deploy to a staging environment first
- Only push to production when you know it works

**Use the right model for the question:**
- Building and executing? Claude (structured, systematic)
- Validating and questioning? DeepSeek (critical, direct)
- Learning concepts? ChatGPT (agreeable, explanatory)

Don't use one model for everything. Use the right tool for the job.

**Track progress in documentation, not in perceived UI completeness:**
- README that lists what's done vs. not done
- Architecture diagram in the repo
- Database schema documented
- API endpoints documented

If you can't explain it, it's not done.

### The Hard Truth About Speed

Speed on Replit (building things fast) is different from speed on CLI (shipping things fast).

Replit is faster at showing you UI. CLI is faster at getting you to done.

When you optimize for visible progress, you optimize for the wrong thing. When you optimize for shipped, working applications, you make different decisions.

The decisions feel slower. They take more thinking upfront. But they prevent the spiral. They prevent the $1,000 burn. They prevent the burnout.

It's not about going slower overall. It's about going slower on the right things (planning, architecture, testing) so you can go faster on the right things (execution, deployment, iteration).

### Mini-Glossary: Section 1

**UI Trap:** Focusing on visible UI progress (10% of the work) while ignoring invisible infrastructure (90% of the work). Results in beautiful interfaces that don't actually work. Most common failure mode.

**Dopamine Loop:** Reward cycle of prompting → instant visible result (especially UI changes) → habit formation. Web interfaces are designed to maximize this. It's addictive and often leads away from shipping.

**Spiraling Fixes:** Pattern where fixing one problem reveals another deeper problem, which reveals another, which reveals another. 7.1 becomes 7.1.1 becomes 10 more tasks. Never reaches foundation.

**Context Poisoning:** Keeping the same chat window open for weeks, accumulating 30+ prompts per session. AI becomes drowsy, agreeable, and hallucinatory. Feels like preserving memory. Actually destroys it.

**Sunk Cost Trap:** You've spent $500 already. Restarting feels like throwing away that $500. So you keep going, throwing good money after bad. Rational choice is to restart. Emotional choice is to keep spiraling.

**Architecture Masturbation:** Building technology that's sophisticated and impressive but doesn't solve the actual problem. Making the tech complex because you can. Opposite of MVP.

**MVP (Minimum Viable Product):** The smallest version of your idea that solves the core problem. "Add task and mark it complete" is an MVP task manager. "Add task, mark complete, share with team, real-time sync, dark mode, analytics" is not.

**Spec Engineering:** The ability to describe what you want clearly enough that the AI understands. More important than coding knowledge. Includes knowing WHAT to ask for (not just HOW).

**Production Shock:** Discovering on deployment that your application doesn't work in the real environment. Works fine on Replit Cloud or localhost. Breaks on VPS, requires environment variables, Docker configuration, DNS setup, etc.

**Agreeable AI:** Models (ChatGPT, Copilot) trained to be helpful and supportive. They say yes to your ideas even if you're wrong. Won't tell you to restart or slow down. Good for morale, bad for truth.

---

## Section 2: Your First 48 Hours - The Actual Workflow

**Status**: Being Rebuilt - Authentic Framework from Real Experience

You want to start building with AI. Great. But where do you actually begin, and what does the workflow really look like?

This section is a concrete action plan grounded in real experience: how ideas get validated, how the 3-step method works in practice, when context windows force resets, and what "done" actually means at each stage.

---

## The Five-Phase Framework (Hours -6 to 48)

The actual progression isn't sequential. It's iterative and feedback-based. But here's the shape:

**Phase 0: Idea Validation (Hours -6 to 0)**
**Phase 1: Tool Setup (Hours 0-2)**
**Phase 2: Environment & GitHub (Hours 2-6)**
**Phase 3: PRD & Tasks (Hours 6-24)**
**Phase 4: Execution & Testing (Hours 24-48)**

The numbers are aspirational for simple projects. Complex projects extend into multiple days of focused work.

---

## Phase 0: Idea Validation (Hours -6 to 0)

Before touching code, tools, or PRD templates, validate that your idea is worth building.

This is where most people fail. They get excited, skip validation, build fast, and end up shipping something nobody wants.

### The Business Analyst Interview

Use the Business Analyst subagent to research your idea:
- Is the problem real? (Do actual users experience this pain?)
- Is your solution right? (Does it solve the actual problem, or a symptom?)
- Is there a market? (Would anyone use this, or is it just your itch to scratch?)
- What's the MVP? (What's the minimum viable set of features to test the core idea?)
- What could kill this? (Market barriers, technical complexity, competition?)

The Business Analyst asks questions you wouldn't think of:
- Who specifically has this problem?
- What are they doing TODAY instead?
- Why would they choose your solution over free alternatives?
- Have you talked to 5+ users who confirmed this is painful?
- What's the simplest version you could build to test?

### The Validation Output

You get a research summary. It tells you: **GO** (idea is viable and worth the time investment) or **NO-GO** (idea is flawed, market is saturated, or problem doesn't exist).

**Reality check:** Many ideas are NO-GO. Research shows:
- Creating solutions for non-existent problems
- Nice-to-have features, not core needs
- Market dynamics too hostile (incumbents too strong)
- Technology too nascent (problem will be solved by AI progress faster than you can ship)
- Similar problems already solved well by existing tools

This validation phase saves you weeks of wasted work.

### When to Skip Business Analyst

If your idea is small and you're sure about it, skip Business Analyst and go straight to Create PRD. But if scope is unclear or you're building something significant, Business Analyst is mandatory.

---

## Phase 1: Tool Setup (Hours 0-2)

### Operating System Matters

| OS | Setup Time | Status |
|---|---|---|
| **Windows** | 30 min (Zorin dual-boot) | Friction-heavy, use Zorin or WSL |
| **Mac** | Ready out of box | No setup needed |
| **Linux** | Ready out of box | No setup needed |

### Access Methods: Web vs CLI vs IDE

| Access Method | Best For | Setup Time | Control | Context Visibility | Guardrailing Overhead |
|---|---|---|---|---|---|
| **Web** (Claude Code, DeepSeek, Google AI Studio) | Learning, demos, simple queries | 5 minutes | Limited (can't adjust temperature) | Hidden (web hides token usage) | 50%+ (constant prompting to stay on track) |
| **CLI** (OpenCode, Claude Code CLI, OpenRouter) | Real projects, full control, localhost testing | 15 min (with scripts) | Full (temperature, models, agents) | Visible (/context shows usage) | 1-2% (personas handle guardrails) |
| **IDE Plugins** (Kilocode, Cline) | Code-focused, inline suggestions | 10 minutes | Medium | Limited | 1-2% (role-based agents) |

**Recommendation:** Start with Web for learning, graduate to CLI for real projects. CLI shows what Web hides (context usage, token costs, agent control).

### Budget: Tools & Pricing

| Option | Cost | What You Get | Best For |
|---|---|---|---|
| **Free Tier** | $0 | OpenCode CLI (free LLMs), Google AI Studio, DeepSeek free | Starting out, cost-sensitive work |
| **Basic ($20/month)** | $20 | OpenCode + Synthesize.new OR Claude Code Pro | Real projects, multi-model access |
| **Amr's Setup ($40/month)** | $40 | OpenCode + Synthesize.new + Claude Code Pro | Never locked in, backup tools, economic flexibility |
| **Danger Zone** | $100+/month | Multiple subscriptions + pay-as-you-go | Unsustainable, often engagement optimization over shipping |

**Rule:** Don't pay until free consistently blocks you. You can stay free indefinitely if strategic about when you use paid models.

### Tool Installation

**Automated scripts:** 15 minutes, everything installed and configured.
**Manual setup:** 1+ hours, download and configure each tool.

Scripts available at: https://github.com/amrhas82/agentic-toolkit

---

## Phase 2: Environment & GitHub (Hours 2-6)

### GitHub on Day 1 (Not Eventually)

You will break things. You will want to try different approaches. You will need rollback.

GitHub is your time machine for code.

**Day 1 protocol:**
1. Create GitHub account (free)
2. Create private repo (your project folder)
3. Connect your local machine to repo (Git)
4. Make your first commit AFTER your first feature works

**What you need to know:**
- **Repository:** Project folder Git tracks
- **Commit:** Checkpoint/snapshot of your code
- **Push:** Upload commits to GitHub
- **Branch:** Separate working copy (Month 2 concept, not Day 1)
- **Private vs Public:** Private = only you see it

Don't worry about branches and pull requests yet. Commit to using GitHub from the start.

### Running Your App Locally

Ask your agent to run your app from CLI terminal or write a simple script:

```bash
npm start      # (JavaScript/Node)
python app.py  # (Python)
./run.sh       # (Custom script)
```

Then test in your browser on localhost:

```
http://localhost:3000
http://localhost:5000
```

**Why localhost?** You own your machine. Your agent has full access to your files, keys, and repo. No VPS setup friction. No "why doesn't it work in production" shock later.

---

## Phase 3: PRD & Task Generation (Hours 6-24)

This is where the 3-step method lives.

### Step 1: Create PRD (30-45 Minutes)

**Tool:** Use the `1-create-prd.md` template from https://github.com/amrhas82/agent-dev-suite

**How it works:**
1. Tell the agent your idea in casual language
2. Agent interviews you with 4-6 back-and-forth questions
3. Agent synthesizes answers into a formal PRD
4. PRD includes: problem statement, solution, MVP features, non-MVP features (backlog), acceptance criteria, success metrics

**Using Business Analyst output as guardrail:**
If you ran Business Analyst research first, use that output as input to Create PRD. Tell the agent: "Here's the research, make sure the PRD respects MVP bounds we identified."

This prevents scope creep before it starts.

**MVP examples (actual boundaries):**
- WhatsApp MVP: text messages work. Attachments, voice, groups = backlog.
- Note app: create note, save it, retrieve it. Sharing, collaboration, rich formatting = backlog.
- Task manager: add task, mark complete, delete task. Subtasks, reminders, priorities = backlog.

**Length of interview:** 30-45 minutes of back-and-forth. You can stop earlier if you feel you've captured everything.

**What if PRD suggests non-MVP features?**
Tell the agent: "This is too big for MVP" and it resets scope. Or reference your Business Analyst research and ask it to guardrail accordingly.

### Step 2: Generate Tasks (10 Minutes)

**Tool:** Use the `2-generate-tasks.md` template

**How it works:**
1. Agent reads your PRD
2. Agent breaks it into parent tasks (major features/phases)
3. Agent breaks parent tasks into subtasks (specific, implementable work)
4. Agent writes acceptance criteria for each subtask
5. Agent orders tasks logically: infrastructure first, UI last

**Order matters.** Wrong order: beautiful landing page → signup form → dashboard → realize authentication is broken.

Right order: data model (ugly, works) → authentication (basic, no styling) → core CRUD (create/read/update/delete) → end-to-end testing → UI styling.

**Your job:** Review, approve, adjust if needed.

### Step 3: Process Task List (30-60 Minutes per Feature, with Testing)

**Tool:** Use the `3-process-task-list.md` template

**How it works:**
1. Agent implements one subtask at a time
2. Agent tests that subtask locally (runs app, checks it works)
3. Agent commits to GitHub
4. **Agent asks permission to continue** (stop-check at each step)
5. You review output, approve or request changes
6. Repeat for all subtasks

You're not prompted every step automatically. Agent works through your list, but you retain control at each checkpoint.

---

## Phase 4: Execution & Testing (Hours 24-48)

### Real Timeline Breakdown

| Phase | Time | What Happens |
|---|---|---|
| **Idea Validation** | 1-2 hours | Business Analyst research, GO/NO-GO decision |
| **Tool Setup** | 15 min - 1 hour | Download, configure, test (scripts speed this up) |
| **PRD Interview** | 30-45 min | Agent asks questions, you answer, PRD synthesized |
| **Task Generation** | 10 minutes | Agent breaks PRD into tasks, orders them |
| **Execution + Testing** | 30-60 min per feature | Build, test end-to-end, commit |
| **Total Focused Work** | 3-5 hours | Spread across 2-4 calendar days |

**Simple projects:** 3-4 focused hours total.
**Complex projects:** 10+ focused hours across multiple days.

The "48 hours" is misleading. It's 48 real-time hours, but actual focused work is 10-15 hours split across multiple sessions with context resets.

### The Context Window Reality During Build

You will hit your context window limit (75% full) mid-project on larger features.

**What happens:**
1. Agent tells you context is filling (if CLI, `/context` shows you percentage)
2. Agent summarizes what's done, what's next, what works, what doesn't
3. You push code to GitHub
4. Start fresh chat, paste summary at top
5. Agent continues from last checkpoint

**Cost:** 2-3% of fresh context to re-establish understanding.
**Benefit:** Prevents 20-30% token waste from hallucinations.

Always worth it.

### Hallucination Detection During Build

Mid-context hallucinations are mild:
- Agent forgets to follow agreed order
- Agent says it fixed something, but didn't
- Agent suggests something already tried
- Easy to correct: 1-2 prompts to get back on track

**What you do:** Remind it what should happen, show code if needed, ask it to check its own work.

End-of-context hallucinations are severe (agent makes major mistakes, takes 30+ prompts to recover). This is why you reset proactively at 75%, not reactively at 95%.

### Testing End-to-End

Before you say "feature is done," test it end-to-end:
1. Run app locally
2. Open browser
3. Go through the user flow
4. Check database/backend actually persisted data
5. Test error cases (what if user enters bad data?)

The acceptance criteria (written during task generation) tell you exactly what "done" means.

Example: "User can send a note" is done when:
- User can type text in input field
- User can click send button
- Note appears in their note list
- Note persists if they refresh page
- Note is stored in database

---

## Phase 5: The Reset Cycle (Days 2-4+)

If you're building something bigger, you'll reset context multiple times.

**Real progression:**
- Day 1 (5 hours): Core features, hit 75%, reset
- Day 2 (5 hours): Additional features, hit 75%, reset
- Day 3+ (varied): Polish, bugfixes, deployment planning

### The 5-Hour Limit (Claude Code)

This isn't a limitation. It's a forcing function.

| Without Limit | With 5-Hour Limit |
|---|---|
| "One more prompt" spirals into 8-hour sessions | Forced break after 5 hours |
| Exhaustion and burnout | Come back energized |
| Difficult to find new solutions | Fresh context = fresh thinking |
| Higher hallucination rate | Lower hallucination rate |

Amr's experience: First thought it was annoying. Realized it was lifesaving. The pause prevented spirals and context pollution.

---

## The 48-Hour Checklist

By 48 real-time hours (or accumulated 10-15 focused hours), you should have:

- [ ] Tool set up and tested (CLI/Web/Plugin)
- [ ] GitHub account with first repo
- [ ] Business Analyst research (idea validated as GO) *[optional if idea is small]*
- [ ] PRD created via Create PRD template (30-45 min)
- [ ] Task list generated and reviewed (10 min)
- [ ] 50%+ of tasks completed
- [ ] Core functionality working (even if ugly)
- [ ] Multiple GitHub commits pushed
- [ ] Can explain your project architecture
- [ ] Acceptance criteria met for at least 2 features

**If you hit 8+:** On track.
**If you hit 5-7:** Still good, might need another focused session.
**If you hit <5:** Something blocked you. Debug it (tool setup? idea too big? not using templates?).

---

## Red Flags vs Green Flags

**Red flags:**
- Skipped templates, jumped straight to coding
- Built features not in PRD (scope creep)
- No GitHub commits
- Can't explain architecture
- Agent is doing things you don't understand
- Haven't tested end-to-end
- Been in same context window for 8+ hours

**Green flags:**
- Using templates systematically (Create PRD → Generate Tasks → Process Tasks)
- PRD and tasks guide your work
- Following task order
- Multiple commits pushed
- Testing end-to-end before moving to next feature
- Can explain why each file exists
- Reset context proactively at 75%

---

## The Uncomfortable Truth About "48 Hours"

The timeline in marketing says "build a landing page in hours." That's UI speed, not shipping speed.

Real timeline for simple project:
- Idea validation: 1-2 hours
- Setup: 15 min - 1 hour
- PRD interview: 30-45 min
- Task generation: 10 min
- Execution + testing: 1-2 hours per feature
- Context resets: 10 min per reset (rare in simple projects)

Total: 4-6 hours focused work across 2-4 days (or 1-2 weeks part-time).

If you've never built before, add 2-3 days for learning and unexpected context resets.

**Don't rush.** Balanced building (5-hour sessions with resets) beats marathon sessions that burn you out.

---

## Mini-Glossary: Section 2

**MVP (Minimum Viable Product):** The smallest set of features that solves the core problem. Text in WhatsApp (not voice, groups, attachments). Create/read/delete in task manager (not search, priorities, subtasks).

**Feature Creep:** Adding features because you enjoy building them or they sound good, not because they solve the core problem. Often confused with AI's "just add this" suggestions.

**Acceptance Criteria:** Specific, testable conditions that define when a feature is actually done. "Send note" is done when user can type, send, and retrieve it from database.

**PRD (Product Requirements Document):** Formal specification of what you're building, why, who it's for, what counts as MVP, what's in backlog. Prevents scope creep by freezing feature list upfront.

**Context Window:** AI's memory limit for a single chat. When full, AI starts hallucinating. Reset proactively at 75% to prevent issues.

**Continuation Doc:** Summary of project state (features done, current bugs, next steps) that bridges fresh context windows. Written by agent, reviewed by you.

**Guardrailing:** Constraining agent behavior to stay on-task. Happens naturally with templates (Create PRD, Generate Tasks) and Business Analyst research output.

**Vibecoding:** Unstructured, prompt-based building without planning. Fast to showcase, breaks under real-world use. Good for learning, bad for shipping.

**End-to-End Testing:** Simulating actual user flow: input data, verify it persists, test error cases. Not just "does the code run."

**GitHub:** Version control system. Repository = project folder, Commit = checkpoint, Push = upload to cloud, Branch = separate working copy.

**Localhost:** Your local machine running the app during development. http://localhost:3000. Faster iteration than deploying to VPS each time.

---

**Next: Section 3 - Model Landscape**

This section covered your first 48 hours and the 3-step workflow. Next, we dive into the AI models themselves: Western vs Chinese, pricing differences, and building a multi-model strategy that never locks you in.




---

## Section 3: Model Landscape - Understanding the 50/50 Framework

**Status**: Complete - Built from Collaborative Elicitation

I thought templates and structured approaches would solve everything. They don't. They solve about 50%. The other 50%? That's choosing the right mix of models, tools, and economics.

This is the 50/50 framework.

---

### The Realization: Same LLM, Different Experiences

Here's when it clicked: I switched from Replit (web) to Claude Code (CLI), and even though they could use the same underlying LLMs, the experience was completely different.

Replit had one persona: "show off and make beautiful UI." It went off track constantly.

But the real problem? **Replit intentionally hides your context window.** No warning when AI memory fills up. No visibility. You just spiral into hallucinations without knowing why.

CLI tools show you everything: `/context` command, token counts, what's actually happening.

That difference—hidden vs visible—changes everything.

#### The 50/50 Framework: Structure + Access

**The Car Analogy**

Think of building a product like a race through complex terrain:
- **The Engine**: Your LLM (Sonnet, Claude, etc.)—raw power and intelligence
- **The Driver**: Your tool/access method (Claude Code CLI, Droid, Plugin)—how you command the engine, manage context, invoke capabilities
- **The Navigator**: Your structure (simple prompts, subagents, clear instructions)—telling the driver where to go and what to do
- **The Road**: Your product/app—the actual destination and terrain you're navigating through

The navigator can have perfect directions and crystal-clear instructions. But without the right driver—without the ability to shift gears, manage fuel (context), call in pit crew (`@subagent-name`), check mirrors (`/context`), reset course (`/reset`), or invoke specialized tools (plugins, droids, skills)—the navigator's directions are useless.

**Your 50% (Structure): The Navigator with Clear Instructions**

Your structure is simple and undoubtedly clear:
- Simple prompts or subagents
- Clear roles and workflows
- Focused instructions to the assistant
- Well-defined tasks

The assistant knows exactly what direction to give.

**The Interface's 50% (Access): The Professional Driver**

But here's what actually matters: your tool (CLI vs Web vs Plugin, Droid vs Claude Code) is the driver that executes:

1. **Breaking down your instructions** into optimal chunks for the engine to digest
2. **Managing context** so the engine doesn't hallucinate from forgotten information
3. **Optimizing the sequence** of work—what to feed the engine first, what to feed next
4. **Choosing the best capabilities** available at each moment
5. **Shifting between modes**: invoking subagents (`@agent-name`), plugins, skills, droids, managing resets

In Replit (Web driver), capabilities are hidden:
- You can't invoke different agents (`@agent-name` doesn't exist)
- Context window is hidden (you don't know when fuel is running low)
- No `/reset` or similar recovery mechanisms
- No visibility into how instructions are being fed to the engine
- Limited or no access to plugins, skills, droids

In Claude Code CLI (CLI driver), you have full control:
- `@agent-name` lets you invoke specialists at the right moment
- `/context` shows exactly what's in memory
- `/reset` lets you refocus and recover
- Full access to plugins, skills, subagents, and droids
- You can see and adjust how the engine is being managed

**Why 50/50 Matters**

You can have the perfect navigator with crystal-clear instructions (50%), but without the right driver, you can't navigate complex terrain. The driver can't manage the engine's context. It can't invoke specialists. It can't recover from errors.

Conversely, a professional driver with confused navigator means spinning wheels. The best driver in the world can't execute on vague directions.

Both halves are necessary. The 50/50 framework isn't about good intentions—it's about having a clear navigator (your structure, your assistant) + a capable driver (your tool: CLI, Droid, Plugin) working in sync, navigating the road (your product) with a powerful engine.

---

### My Journey: Three Phases

| Phase | Tools | Workflow | Guardrailing | Cost | Result |
|---|---|---|---|---|---|
| **Manual PM** | DeepSeek → OneNote → Replit | Research on DeepSeek, plan in OneNote, spoon-feed Replit | 50% of my time | $50/day typical | Exhausting, incomplete projects |
| **Discovery** | Found 3-step method on YouTube | Create PRD → Generate tasks → Process | Curious but skeptical | - | Watched video, thought "this is a dream" |
| **Breakthrough** | 3-step + Claude CLI | Agent-driven planning, localhost, VPS access | 1-2% course correction | $20/month | Actually shipping |

**What changed with Claude CLI:**

- First time CLI (instead of web hiding everything)
- First time localhost (instead of Replit cloud)
- First time my agent could access VPS quickly and diagnose problems
- Could see the whole app, understand it, plan fixes, write MD files after every step

It was **much, much easier, faster, and more effective.**

---

### The Addiction Pattern

I was hooked on Replit. Addicted. Here's how it happened:

**The hook:** I thought I was 1 prompt away from finishing. Classic software engineering optimistic extrapolation: "At this rate, I'll finish in a week!"

**The dopamine:** UI appearing instantly. Every 30 seconds, something new, something beautiful.

**The progression:** Started at $200 limit. "Just one more prompt." Bumped to $300. Then $400. Then $1000 in $100 increments. Four weeks.

**The realization:** I realized my addiction and started placing limits: time limits, weekends off, forcing myself to stop. I realized this BEFORE switching to Claude. When Claude's 5-hour reset kicked in, I appreciated it even more—it was a natural limit.

---

### Access Methods Comparison

| Access Method | My Experience | What You See | What You Control | Guardrailing |
|---|---|---|---|---|
| **Web** (Replit) | CPU-hungry, annoying, limiting, stupid | Beautiful UI (10%) | Almost nothing | 50%+ |
| **CLI** (Claude, OpenCode) | Clean, light, fast, focused | Everything (90%) | Temperature, context, commands, agents | 1-2% |
| **Plugin** (Kilocode) | Nice, inline suggestions | Code + some context | Medium | 1-2% |

**What CLI shows that web hides:**

| Feature | CLI | Web |
|---|---|---|
| Context window | `/context` shows tokens & % | Hidden, no warning |
| Reset | `/reset` command | Can't or unclear |
| Commands running | Visible, scrollable | Hidden behind UI |
| Stop execution | Ctrl+C, instant | Refresh, unclear |
| Temperature | Config file, per-agent | Hidden or locked |
| Agent invocation | `@subagent_name` instant | Can't, one persona |
| Speed | Instant (text only) | Slow (rendering) |
| CPU usage | Minimal (TUI) | High (web interface) |

---

### The "UI Will Have Scaffolding" Delusion

I barely talked about backend on Replit. I thought **UI will naturally have scaffolding supporting it.**

I was so wrong.

When did I realize? **When I deployed to production and everything broke.**

| What I Thought I Knew | What I Actually Learned (For $1,000) |
|---|---|
| Move repo, run index.html, done | Docker images, containerization |
| UI appears = backend works | Frontend/backend are separate |
| Replit handles deployment | CI/CD pipelines, different modes |
| Code just runs | Cron jobs, backups, workflows |
| - | GitHub workflows, MD files, YAML configs |

**The production nightmare:**

Replit gave me scripts to place a **placeholder instead of the actual page.** Bugs kept creeping in. The agent would say "Oh, I added this, then that, then fixed this, then that."

I was determined not to be locked into Replit cloud. I've hated vendor lock-in since my first app 14 years ago when AWS ripped me off for an MVP that wasn't even working.

---

### The Localhost Win

I got my Replit project running on localhost with Claude CLI in **less than 10 minutes.**

Replit had failed to do this **maybe 10+ times.** It would fix something, break another. Ask for secrets it already had. Inefficient. Amnesia. Stupid.

---

### Western vs Chinese: The Truth-Telling Moment

Week 3, everything was breaking.

| Model | My Question | Response |
|---|---|---|
| **ChatGPT** | "Is this approach good?" | "Yes, this looks great!" |
| **Copilot** | "Should I restart?" | "You can keep going, just fix X, Y, Z..." |
| **DeepSeek** | Same questions | "Your architecture is masturbation. You have feature creep. You're focusing only on UI using dopamine to invite more spending on the 10%. You have very beautiful UI with no database working properly. You've overcomplicated things." |

**My reaction:** Disappointed but happy. DeepSeek told me the truth straight to my face.

I tried it many times with idea validation. Consistently straight: pros and cons, what was good or bad.

I liked its candidacy. **I restarted immediately.** Used the UI as a guide since I liked it, but rebuilt the backend properly.

**The lesson:**

| Model Type | Training Goal | When to Use |
|---|---|---|
| **Western** (ChatGPT, Claude, Gemini, Copilot) | User engagement - agreeable, verbose, supportive | Learning, morale boost, exploring ideas |
| **Chinese** (DeepSeek, GLM, Qwen) | Task completion - direct, critical, concise | Validation, reality checks, "tell me the truth" |

---

### The Persona Discovery

I discovered `@subagent_name` invocation when exploring the BMAD method on VS Code. They were invoking agents with `@`, `/`, or `*`.

I looked at Claude Code CLI options and found **subagents.** Then I adapted simple 3-step + BMAD to Claude and OpenCode. Added them to my open-source repo. Compacted and adapted them since I use them often.

**What personas changed:**

| Before (Replit) | After (CLI with Personas) |
|---|---|
| 50%+ time guardrailing | 1-2% course correction |
| "Don't do this" every prompt | Persona MD file defines role once |
| "Stick to plan" constantly | Agent knows its job |
| "No extra features" repeated | Constraints built into persona |
| One useless persona (show off UI) | 10+ specialized agents |

**Personas are game-changers** because they carve out agent attention and hone/invoke its skills for a certain amount of time.

---

### My BMAD Adaptation

| Component | Count | Purpose |
|---|---|---|
| **BMAD personas** | 10 | Complex, role-based, thorough planning |
| **3-step method** | 3 templates | Create PRD → Generate tasks → Process tasks |
| **Tasks library** | 22 | Templates that personas invoke as needed |

**Why I compacted BMAD:**

BMAD is verbose by nature with poor documentation. I asked Claude to compact it without losing context (to save on context when invoked). Kept detailed tasks as they are since they're templates.

**When I use which:**

| Approach | When | Why |
|---|---|---|
| **Vibecoding** | UI color changes, quick questions, one-off scripts | Fast, isolated, no planning needed |
| **3-step method** | Feature, small app, small fix | Elicitation convo, like a dev picking your brain |
| **BMAD personas** | Complex projects, thorough planning | Specialty agents for deep work |

**The rule:** If it touches more than one file, use 3-step. Create a branch. Plan first.

---

### Tools I've Actually Tried

| Tool | Ease | Cost | Effectiveness | Stability | My Notes |
|---|---|---|---|---|---|
| **Kilocode** | Easy | Average | Average | Stable | Plugin for PyCharm, inline suggestions |
| **Claude Code CLI** | Easy | Great ($20/mo) | Very effective | Stable* | Main tool, subagents/hooks/skills, *few bugs in unused features |
| **OpenCode** | Easy | Great (free+BYOK) | Less capable sometimes | Stable | Chinese LLMs, open-source, best of all worlds |
| **AmpCode** | Easy | Expensive | Effective | Stable | Organized, todo list, better recourse |
| **Droid** | Easy | Expensive ($20/20M tokens) | Effective | Stable | SWE focused, no personas, BYOK limited |

**"Less capable sometimes" (OpenCode):**

I've been lightly using it next to Claude (my main). It understands, but I don't fully trust it yet. Using it for research.

Not as holistic and opinionated as AmpCode when I asked it to reorganize my toolkit repo. Some LLMs are inefficient: Grok was bad, GLM was better. Some mistakes.

**Amp/Droid are "more SWE grade":**

More focused. Get their mistakes amazingly fast. Recourse is much easier than Replit's 15+ prompts to fix one thing.

**Why OpenCode won despite limitations:**

Open-source. Freedom over corporate lock-in. Great cost. Supports Chinese LLMs with comparable quality at fraction of price.

I'm leaning towards AmpCode or Droid replacing OpenCode for stability, but I appreciate open-source freedom.

---

### My Current Setup: $40/Month (Down from $1,000)

| Tool | Cost | Purpose | Why |
|---|---|---|---|
| **Claude Code CLI** | $20/month | Main tool, primary execution | Subagents, 5-hour reset (feature), structured |
| **OpenCode** | ~$20/mo equiv | Backup, research, free models | BYOK, Chinese LLMs, open-source |

**Hit Claude limit often?** Yes, but I'm not bothered. Long-term issues were being solved. All the frustrations I had with Replit were being solved with Claude even before I started using frameworks.

When I hit the limit, I turned to do other things or used OpenCode for other projects.

---

### The 5-Hour Reset: From Annoying to Lifesaver

| Timeline | My Perception |
|---|---|
| **First reaction** | "This is annoying. I want unlimited access." |
| **After a week** | "Wait, I haven't hit the limit yet. I've explored more, done research for 2 other projects, got more done with structure and elicitation." |
| **After a month** | "This is a lifesaver. It forces small wins instead of chasing 'one more prompt.'" |

**The sleep-on-it moment:**

One time I hit the mental limit on Replit. Decided to stop. In the morning, I had a completely new idea. Literally slept on it. Merged two features that were closely related and shared a lot of details.

The 5-hour reset forces this.

**Why it works:**

I get faster to what I want with structure and elicitation. Not jerking around with unstructured prompts (which providers love because they consume tokens and make profit but don't bring value).

---

### The Honeymoon Phase

I still think onboarding experiences are engineered: providers give you free credit and unmatched experience that doesn't repeat.

**Which tools did this:** Replit, AmpCode, Kilocode, Droid

I don't mind as long as quality doesn't degrade much.

---

### Free Tier Strategy

**Can beginners stay free for Month 1-2?** Yes, especially if:
- They don't know what they want yet
- Trying very small scripts
- Just researching

| Tool | Free Tier | Good For |
|---|---|---|
| **AmpCode CLI** | Good free tier | Exploration, smaller context |
| **Droid CLI** | Good free tier | Testing workflows |
| **Gemini CLI** | Good free tier | Learning, research |
| **OpenCode** | Free models built-in | Execution with Chinese LLMs |

Free tiers run out fast but give you a sense. Context window is smaller, but with subagents or structured personas, you can get a feel for it.

**My experience:** Started with Replit free. Once I saw UI coming up, I switched to paid immediately. Once I understood pay-as-you-go, I kept going (mostly seeing UI, barely talked about backend).

---

### The Key Takeaway

| Insight | What It Means |
|---|---|
| **50/50 framework** | Structure solves 50%, right tool mix solves other 50% |
| **Visibility matters** | CLI shows what web hides (context, tokens, temp) |
| **Personas eliminate guardrailing** | 50% overhead → 1-2% with MD files |
| **Western vs Chinese** | Both needed. Western for learning, Chinese for truth |
| **Free tier is viable** | Beginners can stay free Month 1-2 if strategic |
| **Natural limits prevent spirals** | 5-hour reset is a feature, not limitation |
| **Tool + framework together** | Good framework on bad tool still fails |
| **Open-source freedom** | Appreciate freedom over corporate lock-in |

The breakthrough wasn't finding a better framework. It was having the right tool (Claude CLI) with agent-driven planning (3-step method) instead of manual PM work.

**From → To:**
- $1,000/month → $40/month
- 50% guardrailing → 1-2% course correction
- Exhausted → Energized
- 0 shipped → Actually shipping

---

## The Hard Truth: AI Needs More Handholding Than You Think

This is where experience from real-world usage breaks through the marketing. Here are 4 critical takeaways from six months of pushing Claude Code to its limits on a 300k+ LOC project:

### The 4 Critical Takeaways

| # | The Reality | Why It Matters | The Remedy |
|---|---|---|---|
| **1** | **Models won't auto-use best practices** ("I'd literally use the exact keywords from skill descriptions. Nothing.") | AI doesn't read and retain documentation like humans. It won't follow guidelines without constant, explicit reminders. | Use personas and Skills with auto-activation hooks. Guardrailing drops from 50%+ to 1-2%. |
| **2** | **All models have amnesia** ("Claude is like an extremely confident junior dev with extreme amnesia, losing track easily.") | Across 30+ prompts, Claude forgets context, wanders off tangents, forgets decisions. You can't rely on memory. | Track progress externally (task files, context files, plan files). External docs preserve intent; chat history doesn't. |
| **3** | **Output quality depends on prompt quality** ("Results really show when I'm lazy with prompts at the end of the day.") | Bad prompt input = bad output. It's not the model failing; it's insufficient direction from you. | Be precise, avoid ambiguity, spend time crafting clear prompts. Re-prompt with feedback. Specificity = better output. |
| **4** | **Lead questions get biased answers** (Ask "Is this good?" → Claude says yes. Ask neutral → get honest feedback.) | Models are trained for agreement. They tell you what they think you want to hear. | Phrase questions neutrally: "What are potential issues?" instead of "Is this good?" Ask for alternatives, not confirmation. |

---

### How to Use This: Design Around These Realities

| Reality | Don't Do | Do This Instead |
|---|---|---|
| Won't auto-use practices | Write BEST_PRACTICES.md and expect compliance | Use personas/MD files + Skills with hooks |
| Has amnesia | Keep same chat open forever | Track externally, reset at 75%, use continuation docs |
| Output = input quality | Be lazy with prompts | Invest time in clarity and precision |
| Biased toward agreement | Ask leading questions for validation | Ask neutral questions for truth |

---

### Mini-Glossary: Section 3

**50/50 Framework:** Structured approaches solve ~50%, right tools/models/economics solve other 50%. Both necessary.

**Persona MD File:** Text file defining agent's role, expertise, constraints. Invoked with `@agent_name`. Drops guardrailing from 50%+ to 1-2%.

**5-Hour Reset:** Claude Code feature that pauses usage after 5 hours. Forces breaks, prevents spirals, enables fresh thinking. Feature, not limitation.

**Western Models:** ChatGPT, Claude, Gemini, Copilot. Trained for engagement. Agreeable, won't tell you to restart.

**Chinese Models:** DeepSeek, GLM, Qwen. Trained for task completion. Direct, tells you truth straight.

**SWE Grade:** Tools focused on engineering workflows (better recourse, faster mistake recovery). Examples: AmpCode, Droid.

**TUI (Text User Interface):** Terminal-based. Clean, light, fast. Focuses on 90% (backend) not 10% (UI).

**Vendor Lock-In:** Dependency on single provider. Can't switch easily. Learned from AWS. Solution: multi-tool strategy, open-source.

**BYOK (Bring Your Own Key):** Manage your own API keys via aggregators. Flexibility, prevents lock-in.

**Context Window Visibility:** CLI shows token usage (`/context`). Web hides it. Knowing when to reset prevents hallucinations.

---

## Section 4: Access Methods & Tools - Why Tool Choice Matters More Than You Think

**Status**: Complete - Built from Real Testing Across 6 Tools

You've chosen your model (Western, Chinese, or multi-model). Now the real question: **where are you actually going to work?**

This section covers the access methods (Web, CLI, Plugin), the tools available, and why **tool choice determines your trajectory more than model choice.**

---

## The Tool Landscape: What I Actually Tested

I tested 6 tools seriously. Here's the ranking from best to worst for sustainable building:

| Rank | Tool | Best For | Fatal Flaw | Price Model |
|---|---|---|---|---|
| **1** | **Claude Code CLI** | Serious builders, production work | Rare rendering bugs on agent editing | $20/month subscription |
| **2** | **Droid** | SWE personality focused, gets mistakes fast | Expensive, no subagents (massive limitation), BYOK available but limited | Usage-based (BYOK) |
| **3** | **OpenCode** | Free-tier sustainable work, open-source preference | Persona less effective than CC, feels primitive, but offers plenty of free LLMs | BYOK (usage-based, free models available) |
| **4** | **Ampcode** | SWE-focused work, organized approach | Expensive, no BYOK option | Usage-based (markup) |
| **5** | **Kilocode (PyCharm Plugin)** | Already using IDE, inline suggestions | Clunky interface, doesn't render naturally in IDE, feels weird | Usage-based |
| **6** | **Replit** | Learning UI design (not recommended) | Everything fails: high temp defaults, careless verification, no delivery focus, expensive ($50+/day), shows off UI over delivery | Usage-based ($50+/day) |

**Key insight:** It's not about the model (Sonnet in Replit vs Sonnet in Claude Code are completely different experiences). It's about:
- **What capabilities the tool gives you** (subagents, hooks, skills)
- **What it optimizes for** (delivery vs dopamine)
- **What it makes visible** (context usage, file changes, execution logs)

---

## What Actually Matters in a Tool: The 3+2 Framework

When choosing a tool, these matter most:

**Critical (decide if viable):**
1. **Price** - Subscription predictable, pay-as-you-go is dangerous
2. **Subagents/Personas** - Guardrailing drops from 50%+ to 1-2%
3. **Solid SWE Personality** - Not optimized for show-off, optimized for delivery

**Nice-to-Have (decide between tools):**
4. **To-do lists and clear actions** - Helps track progress
5. **Auto safeguards and rendering clarity** - Verifies changes before applying

**Temperature doesn't make the list.** Why? Because persona almost entirely replaces temperature. You've already defined bounds and limits in the persona. Temperature becomes irrelevant when the agent knows exactly what role it's playing.

---

## The Fatal Flaw of Replit: Persona Design, Not Model

Here's the uncomfortable truth: Replit used Sonnet (solid model). The problem wasn't the model. It was:

- **Persona design:** Optimized for "show off" not "delivery"
- **Prioritization:** UI visible instantly = dopamine. Infrastructure invisible = ignored.
- **Agent optimization:** Everything leans toward engagement (keep you prompting, keep you paying)
- **Trust erosion:** Doesn't verify changes. Does work without asking. Over-apologetic. Careless.

Even if Replit used Claude instead of Sonnet, the platform is still broken because **the tool itself is architected for the wrong goal.**

This is why **tool choice matters more than model choice.** A good tool with a mediocre model beats a bad tool with a great model.

---

## Access Methods: Web vs CLI vs Plugin

### Web (Replit, Google AI Studio, Claude Code web)

**What you see:**
- Beautiful UI rendering instantly
- Conversation interface
- Easy entry, minimal setup

**What you DON'T see:**
- Context window status (no `/context` equivalent)
- Temperature settings (hidden or locked)
- File changes in repo (if any)
- Token usage or costs
- Execution logs (if backend exists)
- Rendering of what agent actually does

**Guardrailing overhead:** 50%+ (you're constantly prompting to stay on track)

**Best for:** Learning concepts, UI-focused projects, first week exploration

**Worst for:** Understanding what's actually happening, serious multi-file projects, backend work

---

### CLI (Claude Code CLI, OpenCode, Ampcode, Droid)

**What you see:**
- `/context` shows token usage and percentage
- Subagent invocation with `@agent_name`
- File changes highlighted (color-coded)
- Execution logs in real-time
- Hooks and skills you can observe
- Full control over temperature and config
- Faster rendering (text-only, no UI overhead)

**Guardrailing overhead:** 1-2% (subagents handle most discipline)

**Best for:** Real projects, multi-file work, backend, VPS debugging, understanding what's happening

**Worst for:** Learning concepts (you need more context), initial setup friction

---

### Plugin (Kilocode, Cline)

**What you see:**
- Code suggestions inline in your IDE
- Local repo integration
- IDE tools (file explorer, git status)

**What you DON'T see (compared to CLI):**
- Rendering looks weird in IDE (not natural)
- Interface is heavier/clunkier
- Context visibility is limited
- Less transparent about what agent is doing

**Guardrailing overhead:** 1-2% (but interface friction is higher)

**Best for:** People already comfortable in PyCharm/VS Code who want inline help

**Worst for:** Clarity, learning, understanding what the agent is actually doing

---

## The Visibility Principle

Here's what separates tools: **visibility of what's actually happening.**

| Feature | Replit (Hides) | Claude Code CLI (Shows) | Outcome |
|---|---|---|---|
| **Context window** | Hidden (no warning) | `/context` shows % used | Web: you spiral unaware. CLI: you reset at 75% proactively |
| **File changes** | Not visible | Highlighted by repo (color-coded) | Web: don't know what touched. CLI: understand impact |
| **Execution logs** | Manual copy-paste needed | Real-time in terminal | Web: painful debugging. CLI: autonomous debugging |
| **Temperature** | Hidden or locked | In config.json | Web: can't control. CLI: can adjust if needed |
| **Cost tracking** | Hidden (burn money unaware) | Visible per session | Web: surprise bills. CLI: see spending |
| **Overall impact** | 50%+ guardrailing | 1-2% guardrailing | Web: constant prompting to stay on track. CLI: agent knows its role |

**Result:** This visibility alone solves most of the "AI amnesia" problem. You can't hallucinate invisibly. When you see what changed, what context is used, and what errors occurred, you immediately catch problems.

---

## The Infrastructure Visibility Problem (Takeaway #2 Integration)

From hooks.txt: "Claude is like an extremely confident junior dev with extreme amnesia."

**But here's the thing:** The amnesia isn't invisible in CLI tools. You can see it happening via `/context`.

| Scenario | Web Tool | CLI Tool |
|---|---|---|
| **What happens** | AI loses the plot mid-project | AI approaches 75% context |
| **When you notice** | 20 prompts later (too late) | Right away via `/context` |
| **What you do** | Spiral into hallucinations | Reset proactively |
| **Result** | Cascading errors, expensive recovery | Catch problem early |

**The key difference:** Visibility doesn't eliminate amnesia (that's a model limitation). But it prevents you from cascading into hallucinations. You catch the problem early.

---

## The 90% Infrastructure Reality

| Aspect | Web Tool (Replit) | CLI Tool (Claude Code) | Impact |
|---|---|---|---|
| **UI Visibility** | Beautiful, instant, dopamine-friendly | Boring, after core is done | Web seduces you, CLI forces truth |
| **Database State** | Hidden, hope-and-pray | Visible in config, tested locally | Web: break in production. CLI: catch locally |
| **Authentication** | Built but untested | Designed + tested + documented | Web: security theater. CLI: actually secure |
| **Error Handling** | Nonexistent (wasn't visible) | Must be planned before UI | Web: crash in prod. CLI: prevent crashes |
| **API Endpoints** | "Supposed to work" | Actually tested via localhost | Web: faith-based. CLI: verified |
| **File Structure** | Vague (saw UI, not code) | Clear (used 3-step, designed from database up) | Web: lost. CLI: architect |
| **Production Readiness** | Surprise disaster at 75% | Known-working at 75% | Web: $1,000 hole. CLI: shipping |

**The result:** When you use 3-step method in CLI, the PRD generation and task breakdown force you to talk about infrastructure. UI barely gets mentioned because you're designing from the database up, not from the button down.

If you start with web (UI focus), you're already in the trap. If you start with CLI, you're forced to think architecture first.

---

## Your Minimum Viable Setup

| Phase | What You Need | Why | When to Skip |
|---|---|---|---|
| **Starting Out** | Claude Code CLI OR OpenCode | Visibility + guardrailing built-in | None—start here |
| **Day 1** | 3-step method (PRD → Tasks → Execute) | Structured prevents spirals | Only if idea is trivial |
| **Foundation** | Subagents/personas (MD files) | 50% guardrailing → 1-2% | Never skip this |
| **Month 1-2** | Hooks and skills | Automate error checks | You'll add these when you see patterns |

**Translation:**
- Start with CLI + 3-step + personas. That's your whole setup.
- Don't add hooks/skills until Month 2 when you've built 2-3 projects.
- Only then automate the checks you find yourself repeating.

---

## The Upgrade Path: When to Switch

| Condition | Start With Web | Decision at 1-2 Weeks | Long-Term Strategy |
|---|---|---|---|
| **Never built before** | Yes (1 week max) | Switch to CLI after validation | CLI + structure for real projects |
| **Want fast UI results** | Yes (dopamine loop) | Switch to CLI once addiction fades | CLI prevents endless tinkering |
| **Testing if you like coding** | Yes (explore) | Switch if you do (you will) | CLI when serious |
| **Building real applications** | No (start CLI) | Stay CLI (better from Day 1) | Never leave |
| **Serious multi-file projects** | No (start CLI) | Stay CLI (web is limiting) | CLI + subagents permanent |
| **Need to understand what's happening** | No (start CLI) | Stay CLI (transparency is critical) | CLI forever |

**The honest take:** Never go back to web for serious work once you've used CLI with subagents. The 48% guardrailing difference is your life back.

---

## Temperature: The Footnote (Not The Main Event)

You asked about temperature. Here's the honest take:

**Temperature is a randomness parameter (0.0-2.0), not personality.** I confused it with model training for a long time. They're completely different things.

Web interfaces hide temperature entirely. CLI tools expose it in config.json. But here's the real insight: **if you've defined a clear persona, temperature becomes noise.** The persona MD file already controls what the agent will and won't do. Temperature tuning is overthinking it once you have a solid persona.

Here's when temperature actually matters:

| Scenario | Temperature Matters? | Why/Why Not | Better Solution |
|---|---|---|---|
| **Unstructured vibecoding** | Yes (sometimes) | Need randomness for creative exploration | Just use vibecoding—it's exploratory by nature |
| **Using structured prompts** | No (basically never) | 3-step method + persona defines bounds → temperature is noise | Define persona first (drops guessing from 50% to 1-2%) |
| **Persona-driven agents** | No (almost never) | Agent knows its role, limits, constraints via MD file → temp becomes irrelevant | Deploy persona MD file once, never tune temp again |
| **Trying to fix "lazy" outputs** | No (wrong solution) | Bad output = bad prompt, not temperature | Rewrite prompt with precision, ask for specifics |
| **Creative roles** (copywriting, brainstorming) | Maybe (rarely) | If you want surprising results, use 1.2-1.5 | Build persona that defines "creative" constraints |
| **Deterministic roles** (code, documentation) | No (bad idea) | Code changes should be predictable | Use 0.3-0.5 AND define persona |

**The verdict:** If you've defined a clear persona and you're using structured prompts (3-step method), temperature tuning is overthinking it. You're already controlling randomness via persona definition.

If someone asks "should I use temperature 0.5 or 0.7?", the real answer is: **"Define your persona better first. Then temperature won't matter."**

---

## How Section 4 Addresses Key Experience Takeaways

This section reinforces critical insights from real-world usage:

| Takeaway | The Problem | How Section 4 Solves It |
|---|---|---|
| **#2: All models have amnesia** | Claude forgets context, wanders off, makes contradictory suggestions | CLI's `/context` shows when memory fills → you reset proactively instead of spiraling invisibly |
| **#5: Sometimes you fix it yourself** | You need to step in when agent goes wrong | CLI highlights file changes (color-coded) → you understand impact → search repo → ask agent to fix precisely |
| **#9: Claude doesn't catch mistakes** | AI doesn't verify its own work | CLI + hooks automate error checking (build, Prettier, linting, reminders) → failures caught immediately |
| **#6: Outputs are stochastic** | Same prompt gives different results | Persona (defined via MD file) replaces temperature tuning → consistent, reproducible outputs |

**Key insight:** Tool visibility and automation prevent cascading failures. Web tools hide everything. CLI tools show everything, letting you intervene early.

---

## The Tool Choice Paradox

**You can build with any tool.** Replit works. Web works. OpenCode works.

**But you'll spend:**
- 50%+ guardrailing in web tools (constantly telling it to stay on track)
- 1-2% course correction in CLI tools (agent knows its role)

**That 48% difference is your life back.**

It's not about the model. It's about the tool giving you visibility, control, and automation.

---

## Mini-Glossary: Section 5

**CLI (Command Line Interface):** Text-based terminal tool. Faster rendering, full control, shows everything. Steeper learning curve but more powerful.

**Web Interface:** Browser-based. Easy entry, beautiful rendering, hides complexity. Less control, more distraction.

**Plugin/IDE Integration:** Agent runs inside your code editor (PyCharm, VS Code). Local repo access but rendering is clunky.

**Subagent:** AI assistant with defined role (Business Analyst, Code Executor, etc.). Invoked with `@agent_name`. Guardrails behavior.

**Persona MD File:** Text file defining agent's role, expertise, constraints, output format. Replaces need for constant guardrailing.

**BYOK (Bring Your Own Key):** You provide your own API keys via aggregator. Flexibility, prevents vendor lock-in.

**Guardrailing Overhead:** Time spent repeating instructions to keep AI on track. 50%+ in web tools, 1-2% in CLI with subagents.

**Visibility:** Information you can see (context usage, file changes, costs, logs). CLI shows everything. Web hides most.

---

---

## Section 5: Approaches Spectrum - Vibecoding vs 3-Step vs BMAD

**Status**: Complete - Built from Collaborative Elicitation with Real Project Data

---

### The Core Reality

You have three fundamentally different approaches to building with AI agents. They're not better or worse—they're tools for different problems.

The mistake most beginners make: thinking **all three are equally viable for all projects.** They're not.

This section is about understanding when each works, when it fails, and the actual costs (in time, money, and sanity) of picking the wrong one.

---

### Three Approaches: At a Glance

| Approach | Best For | Worst For | Time to "Working" | Guardrailing Overhead | Real Token Usage | Mental Model |
|---|---|---|---|---|---|---|
| **Vibecoding** | UI changes, 1-off fixes, learning, things describable in <3 bullet points | Backend logic, multi-file coordination, architecture decisions | 30 min - 2 hours (or spiral) | 50%+ (constant course correction) | Unknown (tools hide it), spirals waste 50% | "I'll ask and they'll build it" |
| **3-Step (Structured)** | Real features, anything touching 2+ files, architecture-heavy work, production systems | Quick one-line UI tweaks, pure exploratory work | 1-3 hours total (including planning) | 1-2% (persona + clarity does the work) | 2-5M per feature (visible, predictable) | "We plan together, then execute systematically" |
| **BMAD (Full Agentic)** | Complex projects, teams, thorough pre-planning, post-MVP roadmaps | Quick fixes, simple features, when you already know exactly what you want | 4-6 hours initial, then 2-3 per feature | <1% (multiple specialized agents) | 5-10M per feature (thorough) | "I have different agents for different roles" |

---

### The Vibecoding Reality: When It Works, When It Fails

#### What Vibecoding Actually Is

Vibecoding is unstructured prompting. You have an idea. You describe it loosely. The AI builds it. You see results in seconds. You refine. You repeat.

It looks like: **"Build me a button that changes color" → sees button → "make it blue" → sees blue button → done.**

It feels productive because results are visible and immediate.

#### When Vibecoding Works

**Vibecoding works for:**
- **UI changes** (button colors, spacing, layouts, icon swaps)
- **Ready-made components** (adding existing UI libraries, styling frameworks)
- **One-off fixes** (a specific bug you understand and can describe clearly)
- **Learning** (exploring what code does, understanding concepts)
- **Anything you can describe in fewer than 3 bullet points**

**Real example:** URL shortener for maps (Amr's project). Simple, 1-pager, one table. Vibecoding worked fine for the UI. Problem was: spent 3x time fixing bugs that should have been caught upfront (testing, database connection validation, error handling).

**Minimum viable vibecoding:** Code doesn't have to be perfect. Just testable. You can see it runs, data flows, errors surface. "Good enough to validate the idea."

#### When Vibecoding Fails

Vibecoding fails the moment you can't SEE the problem.

**When vibecoding fails:**
- **Backend logic** - You can't see database connections, API calls, authentication flow. Problem is invisible.
- **Multi-file coordination** - Feature requires changes in 3+ files. Vibecoding tells agent "add this," agent changes file A, breaks file B, you don't see it.
- **Architecture decisions** - "Should we use Redis or in-memory caching?" Vibecoding can't handle this—it needs thinking, not coding.
- **Testing & validation** - "Is this secure?" "Will this scale?" Vibecoding can't validate what's invisible.

**The failure pattern:** Vibecoding creates beautiful UIs on broken foundations. You deploy. Production breaks. You discover the infrastructure doesn't exist, was built wrong, or was never tested.

**Real example:** Unified API project (Amr's second attempt). Started with vibecoding. UI got beautiful. Deployment broke everything. Why? No scaffolding—database wasn't connected to frontend, APIs didn't exist, Docker images didn't work. All invisible while building UI.

#### The Spiral Detection Point

**How do you know vibecoding is failing?**

When prompts go from describing features to explaining what you've already asked.

| Prompt # | Type | What You're Saying |
|---|---|---|
| **1** | Feature | "Add authentication" |
| **2** | Feature | "Add a login button" |
| **3** | Explanation | "The database isn't connected, fix that" |
| **4** | Explanation | "Why isn't the token persisting? Check this..." |
| **5** | Clarification | "I said token, not cookie..." |
| **6+** | Spiral | Re-explaining what you've already asked |

You've moved from building to explaining. That's the signal: vibecoding is done. Time to stop, restart with structure.

---

### The 3-Step Method: The Breakthrough

#### What 3-Step Is

3-step is structured planning + execution:

1. **Create PRD** (30-45 min) - Interview yourself about what you're building, why, who it's for, what MVP means
2. **Generate Tasks** (10 min) - Break PRD into actionable subtasks in logical order
3. **Process Task List** (30-60 min per feature) - Execute one task, test it, commit it, move to next

The agent sees the WHOLE picture before writing code. Not: "build this." But: "here's the problem, here's the user journey, here's what success looks like, here's what's in MVP vs backlog."

#### Real Numbers: Vibecoding vs 3-Step

| Metric | Vibecoding (Replit) | 3-Step (Droid) |
|---|---|---|
| **Scope** | Arabic TTS project | Same Arabic TTS project |
| **Approach** | Unstructured prompting | Research + 3-step |
| **Time** | 1 week sporadic | 7 hours focused (5-hour window) |
| **Tokens** | Unknown (tool hides) | 30M tokens (visible) |
| **Cost** | $50 every other day = $300/week | $50/week (fixed) |
| **Cost breakdown** | ~50% spirals, rework, correction | <5% deviation from plan |
| **Outcome** | Stalled, hated it | Organized, efficient, "beyond awe" |
| **Authentication alone** | 10+ hours (spirals) | 1 hour (planned) |
| **Tokens for auth alone** | ~15M wasted (estimated) | 1-2M (actual) |

**Key insight:** Same scope, 7x faster, 6x cheaper, token-efficient, actually works.

#### Why 3-Step Works

**The structure handles the guardrailing:**

| What Vibecoding Requires | What 3-Step Provides |
|---|---|
| You explain what you want | PRD defines it once, clearly |
| Agent deviates (5 out of 10) | Persona + task list keeps agent on track |
| You catch deviations mid-code | Acceptance criteria define "done" upfront |
| You re-explain constantly | Plan eliminates need for re-explanation |
| Testing is afterthought | Testing is part of each task |
| You remember context | Documented in PRD/tasks/acceptance criteria |
| Agent forgets decisions | External documentation (not chat history) |

**Result:** Guardrailing drops from 50% to 1-2%.

#### The Mental Shift

Before 3-step (Manual PM): You researched (DeepSeek), planned (OneNote), executed (Replit). But the agent couldn't see the research or plan. You had to copy-paste relevant bits into each prompt. The agent would suggest things that contradicted your notes. Validation was hard. You spiraled.

After 3-step: One agent sees everything—the repo, the deployment, the documentation, the full picture. It makes a research-based plan. You approve. It breaks work into clear tasks with acceptance criteria. You execute systematically. No spirals because you're not rediscovering the same problems.

**What changed in communication:**
- Less prompting (not more)
- More specificity (not fewer details)
- Structured guardrails (not constant course correction)
- Thinking together (not explaining alone)

#### Critical Feature: Testing is Built-In

The reason 3-step's guardrailing drops to 1-2% is that **testing is part of every task.**

Not: "build this feature"
But: "build this feature, test it locally, commit it, describe what works/doesn't, get approval to continue"

Agent can't just claim it's done. It has to PROVE it's done. That's the guardrail.

#### Vibecoding Included in 3-Step

**Important:** 3-step includes vibecoding for the UI layer.

- Core features: 3-step (design, test, validate)
- UI polish: vibecoding (colors, spacing, library integration)
- Critical logic: 3-step (auth, database, APIs)

You don't do 3-step for everything. You do 3-step for things that matter architecturally. You vibecode the rest.

---

### The Decision Tree: Vibecoding or 3-Step?

Here's the actual decision criteria Amr uses:

| Question | Answer | Decision |
|---|---|---|
| **Can you describe it in <3 bullet points?** | Yes | Maybe vibecoding (if UI only) |
| **Does it touch database, APIs, auth, or multiple files?** | Yes | 3-Step mandatory |
| **Is testing built-in to your description?** | No | 3-Step mandatory |
| **Are you trying to validate an idea?** | Yes | Vibecoding OK (then 3-step for real build) |
| **Is this critical infrastructure?** | Yes | 3-Step mandatory |

**Real examples:**

| Feature | Bullet Points | Touches Infrastructure | Decision | Why |
|---|---|---|---|---|
| Change button color | 1 | No | Vibecoding | UI only, no architecture |
| Add dropdown menu | 1-2 | No | Vibecoding | UI only |
| Add authentication | 5+ | Yes (tokens, database, validation) | 3-Step | Needs design upfront |
| Add dark mode toggle | 2 | Yes (multiple files) | 3-Step | Multi-file coordination |
| Add error handling | 3+ | Yes | 3-Step | Architecture decision |
| Fix styling bug | 1 | No | Vibecoding | Isolated, visible |

**Features ALWAYS worth 3-step (even if "simple"):**
- Authentication
- Database schema changes
- API endpoints
- Data validation
- Error handling
- Anything touching multiple files

---

### BMAD: When Full Agentic Workflows Make Sense

#### What BMAD Is (And Isn't Needed For)

BMAD (Business Analyst → PM → Architect → Developer) is multiple specialized agents, each with a role.

**Important distinction:** Droid doesn't have subagents, but it has **built-in SWE full-stack team personality.** Amr doesn't need BMAD for Droid because:
- Droid already thinks like a full-stack engineer
- 3-step method covers all gaps
- No need to invoke Business Analyst, PM, QA, PO separately

Amr uses:
- Business Analyst persona: When researching ideas or validating assumptions (before PRD)
- 3-Step method: For all actual execution
- Droid's built-in SWE team: Handles the "thinking" that would normally be BMAD agents

#### When to Use Full BMAD

**Use BMAD when:**
- Project is 20+ features with complex dependencies
- Team-based work (multiple humans + AI agents)
- Need pre-MVP roadmap planning
- Tool doesn't have built-in SWE persona (like Replit)

**Don't use BMAD when:**
- Feature is small (<5 files)
- You already know exactly what you want
- Rapid iteration (BMAD adds overhead)
- Tool has strong built-in persona (like Droid)
- You're still learning

#### The Droid Advantage: SWE Team Built-In

| Tool | Subagents? | Built-in Personality | BMAD Needed? |
|---|---|---|---|
| **Droid** | No, but invocable via prompts | Full SWE full-stack team | No (3-step covers it) |
| **Claude Code** | Yes, customizable personas | Medium (depends on setup) | Yes (if you want it) |
| **Replit** | No | Show-off UI focus | Yes (to compensate) |
| **OpenCode** | Yes | Generic | Maybe |

Droid's personality eliminates the need for multiple agents. 3-step + Droid's built-in thinking = BMAD equivalent.

---

### Framework + Tool Fit: Why Tool Matters MORE Than Model

#### The Critical Truth: Same Model, Different Results

**Both Replit and Droid use Sonnet. Results are day and night different.**

| Aspect | Replit | Droid | Difference |
|---|---|---|---|
| **Model** | Sonnet | Sonnet | Same |
| **Persona** | Show-off, UI-focused | SWE full-stack team | Different philosophy |
| **Localhost access** | No - can't run locally | Yes - runs on same machine | Droid can debug independently |
| **VPS access** | No - scripts go back and forth | Yes - direct access | Droid solves problems autonomously |
| **Token visibility** | Hidden (only see cost) | Visible (30M per session) | Droid: traceable spending |
| **3-Step effectiveness** | Broken by tool limitations | Exceptional | Tool enables framework |
| **Guardrailing overhead** | 50%+ (tool fights you) | 1-2% (tool helps you) | Tool choice determines outcome |

**The real lesson:** Tool choice matters more than model choice.

#### Why Localhost + VPS Access Matters

This is the game-changer.

**Replit approach:**
- You: Write feature request
- Replit: Builds in Replit cloud
- You: Test on Replit (not real environment)
- You: Deploy to VPS manually
- VPS: Things break
- You: Copy errors to Replit
- Replit: Guesses at fix without seeing real problem
- Repeat: 15-20 cycles per issue

**Droid/Claude Code approach:**
- You: Write feature request
- Agent: Runs localhost on same machine
- You: Test locally (real environment)
- Agent: Can access VPS directly (same machine has access)
- VPS: Problem appears
- Agent: Debugs with full visibility
- Agent: Fixes and tests
- Done: 1-2 cycles per issue

**Real story from Amr:**
- Unified API on Replit: Broken at deployment, exhausting copy-paste cycles
- Same project logic on Claude Code with 3-step: "Magic"—agent saw everything, understood architecture, planned fixes holistically

---

### Guardrailing Overhead: Why 1-2% vs 50%

#### What Guardrailing Actually Is

Guardrailing = comparing agent output to what you asked, catching deviations, course-correcting.

| Scenario | Replit Vibecoding | 3-Step with Persona |
|---|---|---|
| **Agent goes off-task** | 5 out of 10 times | 0-1 times per feature |
| **How you fix it** | "No, not that, this" | Check task list, give feedback once |
| **Time spent correcting** | 50% of session | 1-2% of session |
| **Why it works better** | Agent has clear constraints | Persona + task list define role |

#### Why Personas Drop Guardrailing to 1-2%

A persona MD file says: "You are a full-stack SWE. Your job is: read the repo, understand the architecture, implement tasks from the list, test locally, commit, then ask for approval."

That one file handles 95% of guardrailing.

Without it (vibecoding): "Build this. No wait, not that. Do this instead. Remember what I said before? Don't change that. Test it. Did you test it? Show me the test. What about error handling? Add error handling..."

---

### Real Projects: What Succeeds, What Fails

#### Project 1: URL Shortener for Maps (Vibecoding)

| Aspect | Details |
|---|---|
| **Idea** | Simple: paste URL, get shortened link, show geolocation on 15 map apps |
| **Structure** | 1-pager, one table, straightforward |
| **Approach** | Vibecoding |
| **What worked** | UI appeared quickly, basic functionality visible |
| **What failed** | Spent 3x time fixing infrastructure bugs that should have been caught upfront |
| **Lesson** | Even "simple" projects benefit from thinking about testing and database upfront |

#### Project 2: Unified API (Three Attempts)

**Attempt 1 - Vibecoding (Replit):**
| Metric | Value |
|---|---|
| **Time** | 3+ weeks |
| **Cost** | $1,000+ |
| **Outcome** | Beautiful UI, completely broken infrastructure, not shipped |
| **Problem** | No scaffolding—database wasn't connected, endpoints didn't exist, Docker images failed |
| **Root cause** | Vibecoding focused on visible UI, ignored invisible infrastructure |

**Attempt 2 - Manual PM (DeepSeek → OneNote → Replit):**
| Metric | Value |
|---|---|
| **Time** | Several weeks |
| **Cost** | Several hundred dollars |
| **Outcome** | 60% stable, still incomplete |
| **Problem** | DeepSeek couldn't see the repo, had to copy-paste between tools, too many manual fixes |
| **Root cause** | Tool limitation—agent didn't have full context, couldn't access VPS |

**Attempt 3 - 3-Step (Claude Code or Droid - planned):**
| Metric | Expected |
|---|---|
| **Time** | 10-15 hours focused work |
| **Cost** | $50-100 |
| **Outcome** | Working, tested, documented |
| **Advantage** | Agent sees repo, runs localhost, accesses VPS, understands architecture |
| **Difference** | Tool enables framework |

#### The Pattern

**What succeeds:**
- Thoroughly planned with clear goals and acceptance criteria
- One thing at a time (not jumping around)
- Testing embedded, not afterthought
- Infrastructure and UI designed together, not UI-first
- Agent has full visibility (localhost, VPS, repo, documentation)

**What fails:**
- Vibecoding complex features
- Thinking UI equals progress
- Skipping architecture decisions
- Tool that hides visibility (can't run localhost, can't access VPS)
- Believing "AI will figure it out"

---

### The Decision Framework: Approach + Tool Fit

| Scenario | Best Approach | Best Tool | Why |
|---|---|---|---|
| **Learning / exploring ideas** | Vibecoding | Web (Claude.ai, DeepSeek) | Fast, visible, no setup |
| **Simple UI change** | Vibecoding | CLI or Web | Either works |
| **Real feature** | 3-Step | CLI (Claude Code, Droid) | Visibility + infrastructure access |
| **Complex project** | 3-Step + BMAD research | CLI (Claude Code, Droid) | Full planning + full visibility |
| **Team-based work** | BMAD + 3-Step | Claude Code | Subagents + customizable personas |

**The rule:** Don't use web tools for serious multi-file work. Don't vibecode architecture. Don't expect tool limitations to disappear with better prompting.

---

### Mini-Glossary: Section 5

**Vibecoding:** Unstructured, prompt-based building without upfront planning. Fast initially for visible work (UI), scales poorly for invisible work (backend).

**3-Step Method:** Structured approach - Create PRD (interview, goals, scope), Generate Tasks (break down into ordered subtasks), Process Task List (execute, test, commit, approve).

**PRD (Product Requirements Document):** Formal specification of what you're building, why, who it's for, what's MVP vs backlog, success criteria.

**Acceptance Criteria:** Specific, testable conditions defining when a task is actually done. "User can send message" is done when: input works, message sends, persists in database, shows on screen.

**Task/Subtask:** Concrete piece of work from PRD. Task: "Implement authentication." Subtask: "Create user schema," "Build login endpoint," "Test token flow."

**Persona MD File:** Text file defining agent's role, constraints, output format. Replaces need for constant guardrailing.

**BMAD (Business Analyst → PM → Architect → Developer):** Full agentic workflow with multiple specialized roles. Comprehensive planning before execution. Often unnecessary if tool has built-in SWE personality.

**Guardrailing Overhead:** Time spent repeating instructions, course-correcting, explaining what you already asked. 50%+ with vibecoding on limited tools, 1-2% with 3-step + personas on capable tools.

**Spiral Detection:** Moment when prompts shift from building features to explaining what you've already asked. Signal to stop vibecoding and restart with structure.

**Manual PM:** Planning outside AI (notes, research, documentation), then executing via AI. Works but creates friction if tool can't see the plan and repo.

**Context Reset:** Starting fresh chat with summary doc when context window fills. Costs 2-3% of tokens but prevents 20-30% hallucination waste.

**Localhost:** Running app on your local machine during development (http://localhost:3000). Enables testing before VPS deployment.

**VPS Direct Access:** Agent can connect to and debug on your actual production server. Tool advantage: eliminates copy-paste cycles, enables autonomous debugging.

---

**Next: Section 6 - Context Windows**

You now understand how to approach building (vibecoding vs 3-step vs BMAD). Next section: the invisible constraint that stops most builders—context windows, how they fill, when they break, and how to manage them proactively.

