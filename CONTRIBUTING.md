# Contributing to Zepto MCP Assistant

Thank you for your interest in contributing to this project!

## How to Contribute

1. **Fork the Repository**:
   Click the **Fork** button on the top right of the GitHub page.

2. **Clone your Fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/zepto-mcp-assistant.git
   cd zepto-mcp-assistant
   ```

3. **Create a Feature Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Test Your Changes**:
   Ensure all configuration schemas conform to the [Model Context Protocol Specification](https://modelcontextprotocol.io). Test connection locally using:
   ```bash
   npm run test:bridge
   ```

5. **Commit & Push**:
   ```bash
   git commit -m "feat: add descriptive feature summary"
   git push origin feature/your-feature-name
   ```

6. **Submit a Pull Request**:
   Open a PR against the `main` branch with a clear description of the problem solved.

## Guidelines
- **Security**: Never commit personal API tokens, private local paths, or unmasked personal order details.
- **Documentation**: Update `README.md` and `docs/ARCHITECTURE.md` for any changes to tool schemas or workflows.
