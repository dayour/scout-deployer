---
name: "persistent-powershell"
description: "Create and manage long-lived PowerShell work sessions for parallel command execution, coding agents, service probes, and reusable terminal workflows."
---

Use this skill when the user asks for persistent PowerShell sessions, long-running terminals, parallel command execution, coding-agent shells, background process orchestration, or reusable Windows command workflows.

Preferred patterns:
1. For an interactive session that the assistant can continue using in the current conversation, start a PowerShell tool call with mode='async' and a stable shellId. Keep the process attached so write_powershell/read_powershell can send commands and retrieve output.
2. For processes that must survive assistant/session shutdown, start them detached with mode='async' and detach=true, then capture PID/log paths. Detached processes cannot be controlled by write_powershell; manage them later by PID and log files.
3. For long analyses, run a persistent attached shell with helper functions loaded and a workspace directory under the session files folder.
4. Keep long command output in files and print compact summaries to the terminal.
5. For Windows, use Windows paths with backslashes.

Recommended bootstrap for a persistent attached shell:
- Set a session label variable, e.g. `$env:SCOUT_SHELL_ROLE='analysis'`
- Set a workspace variable, e.g. `$env:SCOUT_WORKDIR="$env:USERPROFILE\.copilot\session-state\<session-id>\files\persistent-shell"`
- Create helper functions: Invoke-LoggedCommand, Start-DetachedCommand, Test-HttpEndpoint, New-McpInitializePayload.
- Keep the shell alive and ready for write_powershell follow-up commands.

Set `KNOWLEDGE_GRAPH_HOST` before using these endpoint templates:
- txt2kg UI/API base: `http://<KNOWLEDGE_GRAPH_HOST>:3001`
- triples API: `http://<KNOWLEDGE_GRAPH_HOST>:3001/api/graph-db/triples`
- DarbotDB: `http://<KNOWLEDGE_GRAPH_HOST>:8529`
- DarbotDB query API: `http://<KNOWLEDGE_GRAPH_HOST>:8530`
- QMD MCP: `http://<KNOWLEDGE_GRAPH_HOST>:8181/mcp`
- QMD health: `http://<KNOWLEDGE_GRAPH_HOST>:8181/health`

Safety:
- Do not use destructive process-kill commands by name. Stop detached processes by specific PID only.
- Do not overwrite user files. Write logs/artifacts under the session workspace unless the user specifies otherwise.
