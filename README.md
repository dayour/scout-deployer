# ScoutDeployer

Deploy Microsoft Scout to Windows cluster nodes and provision skills, connectors, 
MCP tools, permissions, memory, extensions, session history, and automations — all over SSH via PuTTY.

GENERICIZED — Configure your tenant via `.env` file for multi-tenant/multi-fleet deployments.

## Quick Start

1. Copy `.env.template` to `.env` and configure your tenant details
2. Run `.\ScoutDeployer.ps1` or `ScoutDeployer.cmd`
3. Enter target machine IP and credentials when prompted

## Configuration

All deployment settings are configurable via environment variables. Create a `.env` file 
from the template to customize for your tenant:

```powershell
# Copy template and edit
cp .env.template .env
notepad .env
```

### Key Configuration Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `SCOUT_TENANT_NAME` | Your organization name | Contoso |
| `SCOUT_TENANT_ID` | Entra tenant GUID | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| `SCOUT_DOMAIN` | Primary domain | contoso.com |
| `SCOUT_LICENSED_USER` | User with M365 Copilot license | admin@contoso.com |
| `SCOUT_PRIMARY_NODE_IP` | First deployment target | Configured in `.env` |
| `SCOUT_TARGET_USER` | Admin account on target nodes | administrator |
| `SCOUT_SYSTEM_NAME` | Friendly name for this fleet | Contoso Scout Cluster |

See `.env.template` for all available configuration options.

### Viewing Current Configuration

```powershell
.\ScoutDeployer.ps1 -ShowConfig
```

This displays all active configuration values without running deployment.

## Tenant

Configure in `.env` file — defaults shown from template:

| Field          | Environment Variable      | Default Example                          |
|----------------|---------------------------|------------------------------------------|
| Tenant name    | `SCOUT_TENANT_NAME`       | Contoso                                  |
| Tenant ID      | `SCOUT_TENANT_ID`         | 00000000-0000-0000-0000-000000000000     |
| Domain         | `SCOUT_DOMAIN`            | contoso.com                              |
| Licensed user  | `SCOUT_LICENSED_USER`     | admin@contoso.com                        |
| Scout version  | `SCOUT_VERSION`           | 0.22.333                                 |

## Fleet nodes

Configure via `SCOUT_PRIMARY_NODE_IP`, `SCOUT_PRIMARY_NODE_NAME`, and `SCOUT_ADDITIONAL_NODES` in `.env`.

Keep fleet hostnames and network addresses in the local `.env` file rather than repository documentation.

## Prerequisites

- PuTTY (`plink.exe` / `pscp.exe`) at `C:\Program Files\PuTTY\` (or configured via `PUTTY_DIR`)
- SSH key authorized on every target node (configured via `SCOUT_SSH_KEY_PATH`)
- Target user account is a local Administrator on every target node (configured via `SCOUT_TARGET_USER`)
- Scout installer at the configured path (`SCOUT_INSTALLER_PATH`)
- Node.js 18+ (for `npx` usage only)
- `.env` file with your tenant configuration (copy from `.env.template`)

## Usage

### Double-click (simplest)

```
ScoutDeployer.cmd
```

Opens a console window, prompts for the target machine and account password,
then runs the full deployment interactively.

### PowerShell direct

```powershell
.\ScoutDeployer.ps1
# With explicit parameters:
.\ScoutDeployer.ps1 -InstallerPath "C:\path\to\Setup.exe"
```

### npx (from any directory after npm link / npx path)

```
npx scout-deployer
npx scout-deployer --installer "C:\Downloads\MicrosoftScout-Windows-0.22.333-x64-Setup.exe"
npx scout-deployer --target scout-node.contoso.com --log-dir "C:\Logs\scout"
```

#### All npx flags

| Flag             | PowerShell param        | Default                                   |
|------------------|------------------------|-------------------------------------------|
| `--installer`    | `-InstallerPath`        | `%USERPROFILE%\Downloads\MicrosoftScout-Windows-0.22.333-x64-Setup.exe` |
| `--password`     | `-TargetPassword`       | prompted when omitted; console output is redacted |
| `--putty-dir`    | `-PuTTYDir`             | `C:\Program Files\PuTTY`                  |
| `--log-dir`      | `-LogDir`               | `<script-dir>\Logs\`                      |
| `--skills`       | `-LocalSkillsRoot`      | `%USERPROFILE%\.copilot\skills`            |
| `--memory`       | `-LocalMemoryRoot`      | `%USERPROFILE%\.copilot\memory`            |
| `--sessions`     | `-LocalSessionRoot`     | `%USERPROFILE%\.copilot\session-state`     |
| `--connectors`   | `-LocalConnectorsRoot`  | `<script-dir>\connectors\`                |
| `--mcp`          | `-LocalMcpManifestsRoot`| `<script-dir>\mcp-manifests\`             |
| `--automations`  | `-LocalAutomationsRoot` | `<script-dir>\automations\`               |
| `--extensions`   | `-LocalExtensionsList`  | `<script-dir>\extensions.txt`             |

## Phase 2 provisioning menu

After the binary is installed, an interactive menu offers:

```
[1] Skills         — Deploy ~/.copilot/skills/ to each user profile
[2] Connectors     — Deploy connector manifest JSONs
[3] Tools (MCP)    — Register MCP server manifests (odr.exe or manifest drop)
[4] Permissions    — Apply HKLM Scout policy keys + .copilot ACLs
[5] Memory         — Deploy copilot-memory plugin data
[6] Extensions     — Install VS Code extensions list
[7] Session History — Archive and restore Copilot session-state
[8] Automations    — Deploy scheduled tasks, startup scripts, runbooks
[A] All above
[S] Skip
```

## Logs

Every run writes a timestamped log to `Logs\ScoutDeployer_<YYYYMMDD_HHmmss>.log`.
Format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] message`
Levels: STEP, OK, WARN, ERROR, INFO, DEBUG

## Provisioning a new node

Two steps are required and both must complete:

1. Registry policy key (set automatically by this script):
   `HKLM\SOFTWARE\Policies\Scout\AllowScoutFrontierAccess = 1`

2. Interactive Frontier sign-in (cannot be automated):
   The user must launch Scout on the node and sign in with the configured licensed account.

## Repository layout

```
scout-deployer\
  ScoutDeployer.ps1       Main deployment script
  ScoutDeployer.cmd       Double-click launcher
  package.json            npx package manifest
  extensions.txt          VS Code extension IDs for Extension provisioning
  README.md               This file
  bin\
    scout-deployer.js     npx entry point
  connectors\             Connector manifest JSONs (add your own)
  mcp-manifests\          MCP server manifest JSONs (add your own)
  automations\            .ps1 / .xml / .cmd automation files
  Logs\                   Generated at runtime — timestamped run logs
  docs\
    swe-scout-wiki.html   Public Scout deployment blueprint template
```

## Source of truth

`docs\swe-scout-wiki.html` is a public deployment-blueprint template.
Replace its `{{VARIABLE_NAME}}` placeholders with environment-specific values only in private copies.
