● Great question! Here are the best practices for UI development with me:

  How Developers Work with Claude Code for UI

  1. Screenshots are Key 🖼️

  - Take a screenshot of the current UI and share it with me
  - I can see images and analyze visual layouts
  - Point out what needs to change: "Make this button bigger", "Move the form to the left"

  2. Describe Component Location

  "In the CreatePin page, the submit button at the bottom..."
  "The header navigation bar needs a dark mode toggle on the right side"
  "The map component in PinView.tsx needs..."

  3. Reference Existing Code

  "In client/src/pages/Home.tsx:45, change the hero text color to blue"
  "The Card component in client/src/components/ui/card.tsx needs rounded corners"

  4. Use Browser DevTools

  - Share element selectors: "The div with class 'pin-form-container'"
  - Share computed styles: "This element is using padding: 1rem but needs 2rem"

  5. Iterative Development Flow

  You: "Add a delete button to the pin card"
  Me: *adds button*
  You: *runs dev server, sees it*
  You: "Move it to the top-right corner and make it red"
  Me: *updates positioning and color*
  You: *screenshot* "Perfect, but smaller icon"
  Me: *adjusts size*

  Best Practices

  ✅ Effective Communication

  "In the PinForm component, the email input field needs:
  - Placeholder text: 'your@email.com'
  - Gray border
  - Full width
  - Add validation error text in red below"

  ✅ Component-Level Changes

  "The PinCard component (client/src/components/PinCard.tsx):
  - Add a copy button next to the shortcode
  - Use the shadcn Button component
  - Icon should be from lucide-react"

  ✅ Layout Changes with Context

  "The CreatePin page has a 2-column layout.
  The left column has the form, right has the map.
  Make it stack vertically on mobile (use Tailwind md: breakpoint)"

  ❌ Less Effective

  "Make it look better" (too vague)
  "Fix the UI" (which part?)
  "Update the styles" (what styles, where?)

  My Capabilities for UI Work

  I can:
  - Read screenshots you share (PNG, JPG, etc.)
  - Understand Tailwind classes and apply them correctly
  - Use your component library (shadcn/ui, custom components)
  - Follow design systems (spacing, colors from your theme)
  - Implement responsive designs (mobile/tablet/desktop breakpoints)
  - Add animations (Tailwind transitions, Framer Motion)

  Recommended Workflow

  1. You: "I want to add a user profile dropdown in the header"
  2. Me: *Searches for header component, proposes changes*
  3. You: Run dev server → See changes
  4. You: *Screenshot* "The dropdown is too wide"
  5. Me: *Adjusts width*
  6. You: "Perfect!"

  For Complex UI Changes

  Use this format:
  Component: client/src/components/Header.tsx
  Current state: [screenshot or description]
  Desired state: [screenshot, mockup, or detailed description]
  Specific changes:
  - Add profile icon button (right side)
  - Dropdown with: Profile, Settings, Logout
  - Use shadcn DropdownMenu component
  - Match existing button styling

  Pro tip: The more specific you are about location (file path, line numbers, component names) and desired outcome, the faster and more accurate I can be!
