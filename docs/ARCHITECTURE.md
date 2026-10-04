# System Architecture & Technical Specifications

This document describes the architectural design, protocol interfaces, data flow, and safety mechanisms governing the **Zepto MCP Server Integration** with **Claude Desktop**.

---

## 1. High-Level Architecture

The system bridges an AI Desktop Assistant to Zepto's live quick-commerce infrastructure using the open **Model Context Protocol (MCP)** specification.

```
+-------------------------------------------------------------------------+
|                               HOST CLIENT                               |
|                                                                         |
|   +-----------------------+              +--------------------------+   |
|   |   Anthropic Claude    | <--- stdio - |   mcp-remote Proxy       |   |
|   |   Desktop App         | --- JSONRPC> |   (Node.js / npx)        |   |
|   +-----------------------+              +--------------------------+   |
+-------------------------------------------------------|-----------------+
                                                        |
                                                  HTTPS / SSE
                                              (Encrypted Stream)
                                                        |
                                                        v
                                           +--------------------------+
                                           |   Zepto MCP Server       |
                                           |   (mcp.zepto.co.in/mcp)  |
                                           +--------------------------+
                                                        |
                                                 Internal Service
                                                    APIs / Auth
                                                        |
                                                        v
                                           +--------------------------+
                                           |   Zepto Production Core  |
                                           |   - Dark Store Routing   |
                                           |   - Catalog / Inventory  |
                                           |   - Cart / Checkout      |
                                           +--------------------------+
```

---

## 2. Component Breakdown

1. **User Client (Claude Desktop)**:
   - Evaluates conversational intent and context.
   - Discovers MCP tools exposed by the configured server.
   - Formulates JSON-RPC tool invocation payloads.
   - Synthesizes tool execution results into natural language responses.
   - Enforces human confirmation before executing transactional calls.

2. **Transport Adapter (`mcp-remote`)**:
   - Spawns as a child process via `cmd.exe /c npx -y mcp-remote https://mcp.zepto.co.in/mcp`.
   - Binds to `stdin` and `stdout` for local communication with Claude Desktop.
   - Marshals requests and responses across a secure Server-Sent Events (SSE) / HTTP streaming connection with the remote endpoint.

3. **Remote MCP Server (`https://mcp.zepto.co.in/mcp`)**:
   - Exposes standardized tool definitions conforming to the MCP specification.
   - Validates input schemas and coordinates state with user account sessions.
   - Interacts with Zepto microservices for catalog searches, cart operations, and order placement.

---

## 3. Tool Specifications & Contracts

The server provides 8 distinct tools utilized throughout the grocery ordering lifecycle:

| Tool Name | Parameters | Returns | Primary Role |
| :--- | :--- | :--- | :--- |
| `list_order_history` | None | Array of order objects (`orderCode`, `status`, `totalAmountInPaise`, `items[]`) | Reads recent orders; enables personalized history analysis. |
| `get_past_order_items` | None | Array of past items ordered by frequency | Discovers high-affinity items to resolve ambiguous natural language requests. |
| `list_saved_addresses` | None | Array of saved addresses (`addressId`, `label`, `city`, etc.) | Retrieves pre-configured delivery coordinates. |
| `select_saved_address` | `addressId` (string) | Selection status and bound store details | **Critical Dependency**: Locks serving dark store required for catalog search. |
| `search_products` | `query` (string) | Array of matched products with price, size, and SKU IDs | Queries live inventory within the selected dark store. |
| `update_cart` | `variantId`, `storeProductId`, `quantity`, `priceInPaise`, `deviceId` | Updated cart summary and line items | Mutates user cart state. |
| `get_payment_methods` | None | Available payment modes, delivery fee, and bill breakdown | Fetches payable total and supported settlement methods (COD, Web Link, Wallet). |
| `create_order` | `paymentMethod`, `addressId`, `confirm` (boolean) | Order status and invoice summary | Two-phase checkout execution (Preview vs Placement). |

---

## 4. End-to-End Request & Recovery Sequence

```
User               Claude Desktop           mcp-remote Bridge           Zepto Remote Server
 |                       |                          |                            |
 |--- "What did I order?"|                          |                            |
 |                       |--- list_order_history -->|--------------------------->|
 |                       |<-- 8 past orders --------|<---------------------------|
 |<-- Displays summary --|                          |                            |
 |                       |                          |                            |
 |--- "Order Dairy Milk -|                          |                            |
 |    Roast Almond (49)" |                          |                            |
 |                       |--- get_past_order_items->|--------------------------->|
 |                       |<-- Top item: 13 orders --|<---------------------------|
 |                       |                          |                            |
 |                       |--- search_products ----->|--------------------------->|
 |                       |<-- [Error: Store not set]|<-- Fails (Missing Store)---|
 |                       |                          |                            |
 |                       |=== [AUTONOMOUS RECOVERY] =============================|
 |                       |--- list_saved_addresses->|--------------------------->|
 |                       |<-- Address "home" -------|<---------------------------|
 |                       |--- select_saved_address->|--------------------------->|
 |                       |<-- Store Context Set ----|<---------------------------|
 |                       |=======================================================|
 |                       |                          |                            |
 |                       |--- search_products (retry)->-------------------------->|
 |                       |<-- 10 products (Rs. 49) -|<---------------------------|
 |                       |                          |                            |
 |                       |--- update_cart (qty: 1)->|--------------------------->|
 |                       |<-- Cart updated ---------|<---------------------------|
 |                       |                          |                            |
 |                       |--- get_payment_methods ->|--------------------------->|
 |                       |<-- Total: Rs. 79 (Fee 30)|<---------------------------|
 |                       |                          |                            |
 |<-- Discloses charges, |                          |                            |
 |    asks for approval -|                          |                            |
 |                       |                          |                            |
 |--- Selects Option 1 --|                          |                            |
 |    (Cash on Delivery) |                          |                            |
 |                       |--- create_order(preview)->--------------------------->|
 |                       |<-- Order preview ready --|<---------------------------|
 |                       |                          |                            |
 |                       |--- create_order(confirm)->--------------------------->|
 |                       |<-- Status: INITIATED ----|<---------------------------|
 |<-- Confirms Order ----|                          |                            |
```

---

## 5. Security and Transaction Safety Safeguards

1. **Non-Destructive Previews (`confirm: false`)**:
   Transactional endpoints enforce explicit approval stages. The order is first queried with `confirm: false` to verify pricing, delivery fees, and delivery destination before real submission.
2. **Human-in-the-Loop Consent**:
   The model halts autonomous progression when money is involved. It discloses the item price (₹49), the service/delivery fee (₹30), and the net payable amount (₹79) before asking the user for confirmation.
3. **Data Scrubbing**:
   Raw customer identification details, precise GPS coordinates, phone numbers, and payment tokens are handled within encrypted transport streams and never committed into public repository files.
