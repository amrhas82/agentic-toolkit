# Vibecoding 101 Guide

**Status**: 🔄 Being Rebuilt - Sections 0-7

A comprehensive guide for non-coders and vibecoders on building software with AI agents.

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



