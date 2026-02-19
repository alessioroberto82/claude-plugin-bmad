#!/bin/bash
# BMAD — Dependency Update Script
# Updates all BMAD ecosystem components in one shot.
#
# Usage: bash update-deps.sh
#
# Components managed:
#   - Claude plugins (marketplace + installed)
#   - npm global packages (bmad-mcp)
#   - cupertino binary (via homebrew tap mihaelamj/tap)
#   - bmad plugin (git pull if remote exists)

set -euo pipefail

echo "=== BMAD Dependencies Update ==="
echo ""

# 1. Plugin marketplace — update indexes
echo "→ Updating marketplace indexes..."
claude plugin marketplace update claude-plugins-official 2>/dev/null || echo "  ⚠ claude-plugins-official: update failed (may not be registered)"
claude plugin marketplace update swiftui-expert-skill 2>/dev/null || echo "  ⚠ swiftui-expert-skill: update failed"
claude plugin marketplace update thedotmack 2>/dev/null || echo "  ⚠ thedotmack: update failed"
echo ""

# 2. Plugins — update installed ones
echo "→ Updating plugins..."
claude plugin update swift-lsp@claude-plugins-official 2>/dev/null || echo "  ⚠ swift-lsp: update failed"
claude plugin update swiftui-expert@swiftui-expert-skill 2>/dev/null || echo "  ⚠ swiftui-expert: update failed"
claude plugin update claude-mem@thedotmack 2>/dev/null || echo "  ⚠ claude-mem: update failed"
claude plugin update Notion@claude-plugins-official 2>/dev/null || echo "  ⚠ Notion: update failed"
# code-review, feature-dev, github auto-update (Anthropic official)
echo ""

# 3. npm globals
echo "→ Updating npm global packages..."
npm install -g bmad-mcp 2>/dev/null && echo "  bmad-mcp: updated" || echo "  ⚠ bmad-mcp: update failed (try with sudo)"
echo ""

# 4. cupertino — update via homebrew tap (https://github.com/mihaelamj/cupertino)
echo "→ Cupertino (Apple docs MCP server):"
if command -v brew &> /dev/null; then
    # Ensure tap is registered
    brew tap mihaelamj/tap 2>/dev/null || true
    echo "  Upgrading via homebrew..."
    brew upgrade cupertino 2>/dev/null && echo "  cupertino: upgraded" || echo "  cupertino: already up-to-date (or not installed via brew)"
fi
if command -v cupertino &> /dev/null; then
    VERSION=$(cupertino --version 2>/dev/null || echo "unknown")
    echo "  Version:  $VERSION"
    echo "  Location: $(which cupertino)"
else
    echo "  ⚠ Not installed — run: brew tap mihaelamj/tap && brew install cupertino"
fi
echo ""

# 5. bmad plugin (if it has a remote)
BMAD_DIR=~/Documents/claude-plugin-bmad
if [ -d "$BMAD_DIR/.git" ]; then
    REMOTE=$(cd "$BMAD_DIR" && git remote -v 2>/dev/null | head -1)
    if [ -n "$REMOTE" ]; then
        echo "→ Updating bmad plugin..."
        (cd "$BMAD_DIR" && git pull)
    else
        echo "→ bmad: local only (no remote configured)"
    fi
else
    echo "→ bmad: not a git repository"
fi

echo ""
echo "=== Update complete ==="
