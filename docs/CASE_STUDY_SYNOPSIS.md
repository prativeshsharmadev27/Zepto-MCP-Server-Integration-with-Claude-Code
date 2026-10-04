# Case Study & Project Synopsis: Conversational Grocery Ordering

**Author**: Prativesh Sharma  
**Academic Year**: 2026  
**Subject**: Mini Project Case Study — Tool-Enabled Large Language Models via Model Context Protocol  

---

## 1. Abstract & Motivation
Quick-commerce platforms such as Zepto deliver groceries within minutes. Concurrently, Large Language Models (LLMs) have progressed from conversational generative text to autonomous action execution via external tool use. 

This case study documents an empirical, live evaluation of an AI assistant (Claude Desktop) integrated with the live Zepto platform via the open **Model Context Protocol (MCP)**. It evaluates whether an LLM can safely guide an informal purchase request through the full commerce lifecycle—including error recovery, cost transparency, and strict financial consent.

---

## 2. Research Objectives
1. Connect Claude Desktop to a production e-commerce backend using the standard MCP protocol.
2. Ground loose, ambiguous natural language requests in personal purchasing history.
3. Observe and evaluate autonomous error recovery for API dependencies (dark store binding).
4. Enforce strict human-in-the-loop controls prior to financial commitment.
5. Identify platform limitations and future enhancement opportunities.

---

## 3. Sequence of Tool Invocations

The live session recorded **10 tool calls across 8 distinct tools**:

| Call # | Tool Invoked | Parameters / Payload | Outcome & Result |
| :---: | :--- | :--- | :--- |
| **1** | `list_order_history` | *None* | Retrieved 8 historical orders (7 delivered, 1 cancelled). |
| **2** | `get_past_order_items` | *None* | Retrieved 40 unique past products; *Cadbury Dairy Milk Roast Almond* ranked #1 (13 orders). |
| **3** | `search_products` | `"Cadbury Dairy Milk Roast Almond"` | **Failed with error**: `"Store not selected"`. |
| **4** | `list_saved_addresses` | *None* | Retrieved user's saved addresses; found label "Home". |
| **5** | `select_saved_address` | `addressId: "home-addr-id"` | Selected address; automatically bound nearest dark store context. |
| **6** | `search_products` | `"Cadbury Dairy Milk Roast Almond"` | **Succeeded (Retry)**; 10 results returned; matched 36g SKU @ ₹49. |
| **7** | `update_cart` | `quantity: 1, price: 4900` | Added 1 unit to cart. |
| **8** | `get_payment_methods` | *None* | Total calculated as ₹79 (Item ₹49 + Delivery ₹30). COD and Web Link available; Wallet balance ₹0. |
| **9** | `create_order` | `confirm: false, paymentMethod: "COD"` | **Non-destructive preview generated**; verified ₹79 total to Home address. |
| **10** | `create_order` | `confirm: true, paymentMethod: "COD"` | **Order placed**; returned status `INITIATED`. |

---

## 4. Key Engineering Insights

### 4.1 Dependency Self-Healing
E-commerce APIs often enforce hidden state dependencies. Catalog availability is dark-store-specific, and dark-store assignment depends on delivery coordinates. The MCP client detected the failure `"Store not selected"`, traced the prerequisite back to `list_saved_addresses`, and resolved the dependency without human intervention.

### 4.2 Disambiguation via Purchase Frequency
When presented with the informal prompt:
> *"make order to me ... dairy milk roast almond chocolate price 49"*

Searching for "Dairy Milk" in a grocery catalogue returns dozens of variants (Silk, Fruit & Nut, Crackle, large gift packs). Querying historical order frequency revealed that the user had ordered the 36g Roast Almond bar 13 times. This grounded the LLM's parameter selection and prevented product mismatches.

### 4.3 Two-Phase Safety Commit
Purchasing involves real financial transactions. The `create_order` tool incorporates a two-stage contract:
1. `confirm: false` generates an immutable bill preview.
2. The agent pauses to disclose all fees (including auxiliary delivery charges).
3. `confirm: true` is only transmitted following explicit user consent.

---

## 5. Security and Data Protection
* **Data Minimization**: Personal identifiable information (phone numbers, full postal addresses, and raw order IDs) is excluded from version-controlled files.
* **Ephemeral Credentials**: MCP sessions execute in real-time over encrypted TLS tunnels without storing permanent tokens in static files.
* **Injection Defense**: Remote tool outputs are treated by the LLM as structured data, mitigating indirect prompt injection risks.
