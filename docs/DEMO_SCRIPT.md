# 6–8 Minute Screen-Recording & Project Demo Script

**Project**: Conversational Grocery Ordering Using Zepto MCP Server  
**Presenter**: Prativesh Sharma  
**Target Duration**: 6 to 8 minutes  

---

## Recording Checklist & Pre-Flight Setup
- [ ] Close personal tabs, messaging applications, and background notifications.
- [ ] Open VS Code with the `zepto-mcp-assistant` folder.
- [ ] Open Claude Desktop and confirm the hammer icon indicates `zepto` server connected.
- [ ] Have PowerShell ready in the terminal pane.
- [ ] Screen resolution set to 1920x1080 (1080p) or 1280x720 (720p).

---

## Detailed Minute-by-Minute Script

### Minute 0:00 – 1:00 | Screen 1: Introduction & High-Level Architecture
- **Display On Screen**: Title slide or GitHub Repository README in browser/editor.
- **Presenter Dialogue**:
  > *"Hello everyone! My name is Prativesh Sharma. Today, I am excited to present my project: Conversational Grocery Ordering using the Model Context Protocol (MCP) and an AI Assistant.*
  > 
  > *Ordering groceries online usually involves clicking through dark store locations, browsing catalogues, managing carts, and verifying payment methods. In this project, I integrated Claude Desktop with Zepto's live e-commerce ecosystem via the open Model Context Protocol.*
  > 
  > *This allows a user to order groceries naturally through conversation, while ensuring autonomous error recovery, cost transparency, and strict human confirmation safeguards before any money is spent."*

### Minute 1:00 – 2:15 | Screen 2: System Configuration & MCP Bridge
- **Display On Screen**: Open `claude_desktop_config.example.json` and terminal.
- **Action**: Show how Claude Desktop connects to the Zepto server.
- **Presenter Dialogue**:
  > *"Let's look at how the connection is established. Claude Desktop communicates with external tools using standard JSON-RPC.*
  > 
  > *In the configuration, we define the Zepto server using `mcp-remote`, an open-source bridge that translates local standard I/O into encrypted Server-Sent Events (SSE) directed to Zepto's secure endpoint at `mcp.zepto.co.in/mcp`.*
  > 
  > *When Claude boots, it negotiates capabilities and dynamically discovers 8 distinct tools: order history retrieval, past items ranking, address listing, store selection, product catalog search, cart mutations, payment methods, and order creation."*

### Minute 2:15 – 3:30 | Screen 3: Live Verification & Order History Retrieval
- **Display On Screen**: Claude Desktop application window. Click the tool icon (hammer).
- **Action**: Show tool list in Claude UI. Type: *"Show me my past Zepto orders."*
- **Presenter Dialogue**:
  > *"Here inside Claude Desktop, you can see the connected MCP tools. Let's start with a query: 'Show me my past Zepto orders.'*
  > 
  > *Claude immediately invokes `list_order_history`. The server responds with 8 past orders. Notice how the raw amounts from the API are provided in paise—for example, 20800 paise—which Claude converts into ₹208 for readable presentation.*
  > 
  > *Next, if we ask Claude something outside its toolset—such as 'Rate my last order'—Claude recognizes that no rating tool exists. Instead of hallucinating, it transparently directs the user to the mobile app."*

### Minute 3:30 – 5:00 | Screen 4: Intent Disambiguation & Autonomous Error Recovery
- **Display On Screen**: Claude Desktop chat interface.
- **Action**: Submit natural language prompt: *"make order to me ... dairy milk roast almond chocolate price 49"*
- **Presenter Dialogue**:
  > *"Now comes the core demo: an informal purchase prompt: 'make order to me ... dairy milk roast almond chocolate price 49'.*
  > 
  > *First, Claude calls `get_past_order_items`. It finds that 'Cadbury Dairy Milk Roast Almond Chocolate Bar Pack' is the user's most frequently ordered chocolate, appearing in 13 past orders.*
  > 
  > *Next, Claude attempts to execute `search_products`. But watch this: the API returns an error: 'Store not selected'. In a traditional script, this would crash.*
  > 
  > *However, our MCP workflow demonstrates autonomous error recovery: Claude recognizes that catalog search depends on an active dark store, which depends on a delivery address. It immediately calls `list_saved_addresses`, finds the saved 'Home' address, calls `select_saved_address`, binds the store, and retries the search successfully! It matches the exact 36g ₹49 SKU."*

### Minute 5:00 – 6:30 | Screen 5: Cart Management, Fee Disclosure & Two-Phase Confirmation
- **Display On Screen**: Claude Desktop response showing price breakdown and options.
- **Action**: Show Claude adding item to cart, retrieving fees, and asking for Cash on Delivery confirmation.
- **Presenter Dialogue**:
  > *"Once the product is identified, Claude calls `update_cart` with quantity 1. Then it invokes `get_payment_methods`.*
  > 
  > *Here is our critical safety safeguard: Claude does not place the order automatically. It reveals the item price of ₹49, plus a ₹30 delivery fee, totalling ₹79. It informs the user that Cash on Delivery is available and explicitly asks for approval.*
  > 
  > *When the user selects Cash on Delivery, the `create_order` tool is first invoked with `confirm: false`. This creates a non-destructive preview. Once the preview matches the agreed total, it executes `create_order` with `confirm: true`.*
  > 
  > *The order is placed with status `INITIATED`, completing the transaction safely."*

### Minute 6:30 – 7:30 | Screen 6: Repository Structure, Documentation & Future Scope
- **Display On Screen**: VS Code file tree (`README.md`, `ARCHITECTURE.md`) and GitHub repository page.
- **Presenter Dialogue**:
  > *"To summarize: this project demonstrates that conversational commerce is not just about LLM text generation—it requires reliable protocol standards, dependency management, error recovery, and robust safety controls.*
  > 
  > *The entire repository is structured with clean configuration examples, an architectural specification, and reproducible documentation.*
  > 
  > *Future enhancements include automated spending analytics and multi-item recipe bundling.*
  > 
  > *Thank you for watching! The code and architecture details are available on GitHub."*
