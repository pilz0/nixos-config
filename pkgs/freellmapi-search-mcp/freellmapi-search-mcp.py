# Minimal stdio MCP server exposing FreeLLMAPI's POST /v1/search as a `web_search` tool.
import json
import os
import sys
import urllib.request

BASE_URL = os.environ.get("FREELLMAPI_BASE_URL", "https://freellmapi.freifick.net").rstrip("/")
KEY_FILE = os.environ["FREELLMAPI_API_KEY_FILE"]

TOOL = {
    "name": "web_search",
    "description": "Search the web via FreeLLMAPI. Returns titles, URLs and content snippets.",
    "inputSchema": {
        "type": "object",
        "properties": {
            "query": {"type": "string", "description": "Search query"},
            "max_results": {"type": "integer", "minimum": 1, "maximum": 20, "default": 5},
        },
        "required": ["query"],
    },
}


def search(query, max_results=5):
    with open(KEY_FILE) as f:
        key = f.read().strip()
    req = urllib.request.Request(
        f"{BASE_URL}/v1/search",
        data=json.dumps({"query": query, "max_results": max_results}).encode(),
        headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=60) as r:
        data = json.load(r)
    return "\n\n".join(
        f"## {x.get('title', '')}\n{x.get('url', '')}\n{x.get('content', '')}"
        for x in data.get("results", [])
    ) or "No results."


def handle(msg):
    method = msg.get("method")
    if method == "initialize":
        return {
            "protocolVersion": msg["params"].get("protocolVersion", "2025-06-18"),
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "freellmapi-search", "version": "1"},
        }
    if method == "tools/list":
        return {"tools": [TOOL]}
    if method == "tools/call":
        args = msg["params"].get("arguments", {})
        try:
            text, err = search(args["query"], args.get("max_results", 5)), False
        except Exception as e:
            text, err = f"Search failed: {e}", True
        return {"content": [{"type": "text", "text": text}], "isError": err}
    if method == "ping":
        return {}
    raise KeyError(method)


for line in sys.stdin:
    msg = json.loads(line)
    if "id" not in msg:
        continue  # notification
    try:
        reply = {"jsonrpc": "2.0", "id": msg["id"], "result": handle(msg)}
    except KeyError:
        reply = {"jsonrpc": "2.0", "id": msg["id"], "error": {"code": -32601, "message": "Method not found"}}
    print(json.dumps(reply), flush=True)
