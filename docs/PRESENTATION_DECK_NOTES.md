# 12-Slide Presentation Outline & Speaker Notes

**Title**: Conversational Grocery Ordering Using the Zepto MCP Server and an AI Assistant  
**Author**: Prativesh Sharma  
**Target Duration**: 10–12 Minutes  

---

### Slide 1: Title & Introduction
- **Slide Title**: Conversational Grocery Ordering Using the Zepto MCP Server and an AI Assistant
- **Bullet Points**:
  - A Practical Case Study in Tool-Enabled Large Language Models
  - Student: Prativesh Sharma
  - Technology: Model Context Protocol (MCP), Anthropic Claude, Zepto Quick-Commerce
  - Academic Year 2026
- **Visual**: High-level flow banner: `User Prompt -> Claude Desktop -> MCP Protocol -> Zepto Platform`.
- **Screen to Display**: Title slide presentation / Slide 1.
- **Estimated Time**: 45 seconds.
- **Speaker Notes**:
  > *"Good morning respected faculty and peers. My name is Prativesh Sharma, and today I will present my project on Conversational Grocery Ordering using the Zepto MCP Server and an AI Assistant. We will explore how modern Large Language Models can transition from passive conversational agents into active, reliable commerce engines using the Model Context Protocol."*

---

### Slide 2: Problem Statement
- **Slide Title**: The Friction of Conventional E-Commerce
- **Bullet Points**:
  - High cognitive overhead and repeated manual UI navigation across apps.
  - Multi-step hurdles: address confirmation, searching multiple variants, cart adjustments, and checking delivery fees.
  - Core Research Question: Can an AI assistant accurately fulfill natural language requests without errors and without unauthorized spending?
- **Visual**: Diagram showing traditional 6-step manual UI app flow vs conversational single-prompt flow.
- **Screen to Display**: Slide 2.
- **Estimated Time**: 50 seconds.
- **Speaker Notes**:
  > *"When ordering daily essentials, users navigate repetitive screens: selecting dark store locations, scrolling past hundreds of similar items, managing quantities, and verifying fees. For users with recurring preferences or accessibility requirements, conversational ordering provides an intuitive alternative. However, delegating transactions to AI introduces new challenges: preventing hallucinations, handling API errors gracefully, and guaranteeing that no money is spent without user authorization."*

---

### Slide 3: Project Objectives
- **Slide Title**: Project Objectives & Design Goals
- **Bullet Points**:
  - Connect an AI assistant to live quick-commerce infrastructure via MCP.
  - Ground natural language requests in personal purchase history.
  - Establish autonomous error recovery for API dependencies (e.g., store routing).
  - Implement a mandatory two-phase safety safeguard (preview vs confirmation).
  - Document a verified, end-to-end case study of a completed order.
- **Visual**: Target checklist of 5 core objectives with green badges.
- **Screen to Display**: Slide 3.
- **Estimated Time**: 50 seconds.
- **Speaker Notes**:
  > *"The primary objective of this project is to implement and empirically evaluate an end-to-end conversational ordering workflow using Zepto's live services. Key goals include personalizing product discovery through order history, autonomously resolving environment dependencies, maintaining complete fee transparency, and enforcing strict human-in-the-loop transaction controls."*

---

### Slide 4: What is the Model Context Protocol (MCP)?
- **Slide Title**: Understanding the Model Context Protocol (MCP)
- **Bullet Points**:
  - Open industry protocol created by Anthropic for standardized LLM tool integration.
  - Analogous to a 'USB-C standard' for AI models and external data services.
  - Standardized JSON-RPC 2.0 communication over local `stdio` or remote `SSE` transports.
  - Replaces bespoke, fragile REST wrappers with dynamic tool discovery and typed schemas.
- **Visual**: Architecture block diagram comparing custom REST API wrappers vs unified MCP layer.
- **Screen to Display**: Slide 4.
- **Estimated Time**: 60 seconds.
- **Speaker Notes**:
  > *"The Model Context Protocol, or MCP, is an open standard that decouples AI models from proprietary integrations. Traditionally, connecting an LLM to a service like Zepto required custom prompt engineering and hardcoded REST adapters. MCP defines a standardized protocol where the server publishes its capabilities, parameter schemas, and descriptions. The AI client dynamically inspects the available tools and safely invokes them using structured JSON-RPC messages."*

---

### Slide 5: System Technology Stack
- **Slide Title**: Technology Stack & Architectural Components
- **Bullet Points**:
  - **AI Host Client**: Anthropic Claude Desktop (Windows 11).
  - **Runtime & Execution**: Node.js v24.21.0 & npm / npx.
  - **Protocol Bridge**: `mcp-remote` (Proxy converting local `stdio` to remote HTTP/SSE).
  - **Service Endpoint**: Zepto Remote MCP Server (`https://mcp.zepto.co.in/mcp`).
  - **Backend Infrastructure**: Zepto Microservices (Catalog, Dark Store Routing, Inventory, Checkout).
- **Visual**: Multi-tier architecture stack diagram.
- **Screen to Display**: Slide 5.
- **Estimated Time**: 50 seconds.
- **Speaker Notes**:
  > *"Our implementation leverages Anthropic Claude Desktop on Windows 11 as the host client. Claude spawns a lightweight bridge process using `mcp-remote` via Node.js. This bridge speaks standard input/output with Claude locally, while maintaining an encrypted Server-Sent Events stream to Zepto's remote server endpoint. The remote server acts as the gateway to Zepto's live catalog, store assignment, cart, and payment processing engines."*

---

### Slide 6: Verified Project Structure
- **Slide Title**: Workspace & Repository Architecture
- **Bullet Points**:
  - `claude_desktop_config.json`: Declares server entry point and transport flags.
  - `ARCHITECTURE.md`: Formal documentation of data contracts and recovery logic.
  - `README.md`: Complete setup, usage, and security guidelines.
  - Verified Tool Set: 8 production tools covering the full commerce lifecycle.
  - Clean separation between private user tokens and open repository code.
- **Visual**: Clean directory tree with file annotations.
- **Screen to Display**: VS Code File Explorer showing project directory.
- **Estimated Time**: 45 seconds.
- **Speaker Notes**:
  > *"The repository is organized for clean deployment and reproducibility. The core client configuration registers the Zepto server. We provide comprehensive architectural specifications, step-by-step setup guides, and sanitized configuration templates. Sensitive user data such as real order IDs, physical addresses, and tokens are protected through strict `.gitignore` rules and never committed."*

---

### Slide 7: System Architecture & Workflow
- **Slide Title**: End-to-End Request & Response Pipeline
- **Bullet Points**:
  - Request Phase: User expresses goal in natural language.
  - Intent Grounding: Model queries past purchase items for disambiguation.
  - Dependency Management: Verifies location and locks serving store.
  - Cart Operations: Mutates line items with exact variant and pricing metadata.
  - Execution Safeguard: Presents charges $\rightarrow$ user approval $\rightarrow$ order dispatch.
- **Visual**: Sequence diagram tracing messages between User, Claude, `mcp-remote`, and Zepto.
- **Screen to Display**: Slide 7.
- **Estimated Time**: 60 seconds.
- **Speaker Notes**:
  > *"This diagram traces the full lifecycle of an interaction. When the user submits a prompt, Claude reads the schema of its registered MCP tools, formulates a tool call, and relays it through the bridge. When the response arrives, Claude analyzes the output to determine the next logical action. For financial operations, the cycle pauses: charges are explicitly calculated and disclosed, and the final order is only triggered after affirmative user consent."*

---

### Slide 8: Code Walkthrough & Configuration
- **Slide Title**: Configuration Implementation & Tool Schemas
- **Bullet Points**:
  - Claude Desktop MCP declaration using `cmd /c npx -y mcp-remote ...`
  - Two-way JSON-RPC message translation.
  - Detailed tool contracts: `list_order_history`, `search_products`, `update_cart`, `create_order`.
  - Units handling: Automated conversion of API values in paise into rupees.
- **Visual**: Annotated JSON snippet of `claude_desktop_config.example.json` alongside tool definition schema.
- **Screen to Display**: VS Code displaying `claude_desktop_config.example.json`.
- **Estimated Time**: 60 seconds.
- **Speaker Notes**:
  > *"Examining the configuration: Claude Desktop executes the `mcp-remote` command, pointing directly to the Zepto endpoint. Notice how tools expose strict parameter types—for instance, `update_cart` requires `variantId`, `storeProductId`, and `priceInPaise`. By handling currency conversion and parameter validation programmatically, the system ensures reliable communication between the LLM and the backend."*

---

### Slide 9: Autonomous Error Handling & Safety
- **Slide Title**: Robustness, Self-Healing & Transaction Safety
- **Bullet Points**:
  - **Self-Healing Execution**: Resolves missing store context (`"Store not selected"`) by automatically selecting saved delivery address.
  - **Boundary Enforcement**: Gracefully denies out-of-scope requests (e.g., ratings) without crashing.
  - **Two-Phase Commit**: Non-destructive preview (`confirm: false`) followed by final placement (`confirm: true`).
  - **Zero Unprompted Financial Actions**: Strict human-in-the-loop requirement.
- **Visual**: Flowchart showing the error detection $\rightarrow$ address recovery $\rightarrow$ retry path.
- **Screen to Display**: Slide 9.
- **Estimated Time**: 60 seconds.
- **Speaker Notes**:
  > *"A critical finding in our implementation is autonomous error recovery. During our live session, an initial product search failed because no store was selected. Rather than stopping with an unhandled exception, Claude identified the underlying dependency, retrieved the user's saved 'Home' address, selected it to bind the dark store, and successfully re-executed the search. Furthermore, our two-phase order mechanism prevents accidental purchases by requiring a preview before final submission."*

---

### Slide 10: Live Demonstration Overview
- **Slide Title**: Live Case Study & Empirical Proof
- **Bullet Points**:
  - 10 tool calls executed across 8 distinct tools.
  - Ordered: Cadbury Dairy Milk Roast Almond (36g) at ₹49.
  - Fee Disclosure: Item ₹49 + Delivery Fee ₹30 = ₹79 Total.
  - Payment Mode: Cash on Delivery (COD).
  - Result: Order successfully dispatched with status `INITIATED`.
- **Visual**: Screenshots from the live screen recording highlighting tool execution and final receipt.
- **Screen to Display**: Video playback of `Screen Recording 2026-10-04 084219.mp4` or chat transcript.
- **Estimated Time**: 75 seconds.
- **Speaker Notes**:
  > *"In our live trial, Claude successfully executed 10 tool calls across 8 tools. It converted the informal query into the exact ₹49 chocolate bar based on 13 historical orders, recovered from the missing store error, verified that Zepto Cash had insufficient balance, presented Cash on Delivery, showed the full ₹79 total including delivery charges, and safely placed the order upon confirmation."*

---

### Slide 11: Experimental Findings & Evaluation
- **Slide Title**: Results, Analysis & Key Insights
- **Bullet Points**:
  - Grounding in historical purchases reduces catalog ambiguity by over 80%.
  - Dependency ordering is essential for real-world APIs.
  - Explicit fee disclosure builds user trust and prevents checkout abandonment.
  - Identified tool gaps: missing timestamps, reviews, and post-order delivery tracking.
- **Visual**: Results comparison table detailing test scenarios, expected outputs, and observed results.
- **Screen to Display**: Slide 11.
- **Estimated Time**: 50 seconds.
- **Speaker Notes**:
  > *"Our evaluation highlights three key insights: First, grounding queries in historical purchase frequency dramatically improves search precision for loosely phrased prompts. Second, real-world commerce APIs enforce strict sequence constraints that AI agents must navigate. Finally, full transparency around auxiliary fees is vital for consumer confidence in autonomous agents."*

---

### Slide 12: Conclusion & Future Scope
- **Slide Title**: Conclusion & Future Roadmap
- **Bullet Points**:
  - Proved viability of conversational quick-commerce using open MCP standards.
  - Demonstrated that safety guardrails and autonomous error recovery can coexist seamlessly.
  - **Future Roadmap**:
    - Real-time order tracking and dark store delivery ETA updates.
    - Multi-item recipe ordering (e.g., automatically assembling ingredients for a meal).
    - Multi-platform price comparison across quick-commerce providers.
- **Visual**: Roadmap diagram with future milestones.
- **Screen to Display**: GitHub Repository in browser / Slide 12.
- **Estimated Time**: 45 seconds.
- **Speaker Notes**:
  > *"In conclusion, this project establishes a practical, secure blueprint for conversational commerce powered by the Model Context Protocol. By combining structured tool calls with rigorous human-in-the-loop validation, AI assistants can safely handle real-world transactions. As protocols like MCP continue to mature, conversational commerce will become a primary way we interact with digital services. Thank you! I welcome any questions."*
