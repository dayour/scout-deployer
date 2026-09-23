<#
.SYNOPSIS
    Load and validate environment configuration for ScoutDeployer.

.DESCRIPTION
    Reads environment variables from .env file (if present) and system environment,
    with fallback to safe example defaults. Provides Get-ScoutConfig function that
    returns a hashtable of all configuration values.

.NOTES
    Priority order (highest to lowest):
    1. Command-line parameters
    2. Environment variables
    3. .env file
    4. Safe example defaults
#>

function Get-ScoutConfig {
    <#
    .SYNOPSIS
        Load Scout configuration from .env file, environment variables, and defaults.
    
    .PARAMETER ScriptRoot
        Root directory of the ScoutDeployer script (where .env file is located).
    
    .OUTPUTS
        Hashtable containing all configuration values.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string] $ScriptRoot
    )

    # Initialize config hashtable with defaults
    $config = @{
        # Tenant
        TenantName    = "Contoso"
        TenantId      = "00000000-0000-0000-0000-000000000000"
        Domain        = "contoso.com"
        DomainAlt     = ""
        
        # Licensed user
        LicensedUser  = "admin@contoso.com"
        
        # App registration
        AppClientId   = "11111111-1111-1111-1111-111111111111"
        AppObjectId   = "22222222-2222-2222-2222-222222222222"
        AppName       = "Scout"
        
        # Fleet
        SystemName      = "Contoso Scout Cluster"
        PrimaryNodeIp   = "scout-primary.contoso.com"
        PrimaryNodeName = "scout-primary"
        AdditionalNodes = @("scout-gateway.contoso.com", "scout-secondary.contoso.com")
        
        # Deployment credentials
        TargetUser    = "administrator"
        SshKeyPath    = (Join-Path $HOME ".ssh\id_ed25519")
        
        # Scout binary
        ScoutVersion  = "0.22.333"
        InstallerPath = (Join-Path $HOME "Downloads\MicrosoftScout-Windows-0.22.333-x64-Setup.exe")
        
        # PuTTY
        PuttyDir      = "C:\Program Files\PuTTY"
        
        # Local source paths
        LocalSkillsRoot       = (Join-Path $HOME ".copilot\skills")
        LocalMemoryRoot       = (Join-Path $HOME ".copilot\memory")
        LocalSessionRoot      = (Join-Path $HOME ".copilot\session-state")
        LocalConnectorsRoot   = (Join-Path $ScriptRoot "connectors")
        LocalMcpManifestsRoot = (Join-Path $ScriptRoot "mcp-manifests")
        LocalAutomationsRoot  = (Join-Path $ScriptRoot "automations")
        LocalExtensionsList   = (Join-Path $ScriptRoot "extensions.txt")
        
        # Logging
        LogDir        = (Join-Path $ScriptRoot "Logs")
    }

    # Load .env file if it exists
    $envPath = Join-Path $ScriptRoot ".env"
    if (Test-Path $envPath -PathType Leaf) {
        Write-Verbose "Loading configuration from .env file: $envPath"
        Get-Content $envPath | ForEach-Object {
            $line = $_.Trim()
            # Skip empty lines and comments
            if ($line -and -not $line.StartsWith('#')) {
                if ($line -match '^([^=]+)=(.*)$') {
                    $key = $matches[1].Trim()
                    $value = $matches[2].Trim()
                    # Remove surrounding quotes if present
                    if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") {
                        $value = $matches[1]
                    }
                    Set-Item -Path "env:$key" -Value $value -ErrorAction SilentlyContinue
                }
            }
        }
    }

    # Override with environment variables if present
    $envMapping = @{
        'SCOUT_TENANT_NAME'          = 'TenantName'
        'SCOUT_TENANT_ID'            = 'TenantId'
        'SCOUT_DOMAIN'               = 'Domain'
        'SCOUT_DOMAIN_ALT'           = 'DomainAlt'
        'SCOUT_LICENSED_USER'        = 'LicensedUser'
        'SCOUT_APP_CLIENT_ID'        = 'AppClientId'
        'SCOUT_APP_REG_ID'           = 'AppClientId'
        'SCOUT_APP_OBJECT_ID'        = 'AppObjectId'
        'SCOUT_APP_NAME'             = 'AppName'
        'SCOUT_SYSTEM_NAME'          = 'SystemName'
        'SCOUT_PRIMARY_NODE_IP'      = 'PrimaryNodeIp'
        'SCOUT_PRIMARY_NODE_NAME'    = 'PrimaryNodeName'
        'SCOUT_ADDITIONAL_NODES'     = 'AdditionalNodes'
        'SCOUT_TARGET_USER'          = 'TargetUser'
        'SCOUT_SSH_KEY_PATH'         = 'SshKeyPath'
        'SCOUT_VERSION'              = 'ScoutVersion'
        'SCOUT_INSTALLER_PATH'       = 'InstallerPath'
        'PUTTY_DIR'                  = 'PuttyDir'
        'LOCAL_SKILLS_ROOT'          = 'LocalSkillsRoot'
        'LOCAL_MEMORY_ROOT'          = 'LocalMemoryRoot'
        'LOCAL_SESSION_ROOT'         = 'LocalSessionRoot'
        'LOCAL_CONNECTORS_ROOT'      = 'LocalConnectorsRoot'
        'LOCAL_MCP_MANIFESTS_ROOT'   = 'LocalMcpManifestsRoot'
        'LOCAL_AUTOMATIONS_ROOT'     = 'LocalAutomationsRoot'
        'LOCAL_EXTENSIONS_LIST'      = 'LocalExtensionsList'
        'LOG_DIR'                    = 'LogDir'
    }

    foreach ($envVar in $envMapping.Keys) {
        $value = [Environment]::GetEnvironmentVariable($envVar)
        if ($value) {
            $configKey = $envMapping[$envVar]
            # Handle comma-separated lists (e.g., SCOUT_ADDITIONAL_NODES)
            if ($configKey -eq 'AdditionalNodes') {
                $config[$configKey] = $value -split ',' | ForEach-Object { $_.Trim() }
            }
            else {
                $config[$configKey] = $value
            }
        }
    }

    return $config
}

function Show-ScoutConfig {
    <#
    .SYNOPSIS
        Display the current Scout configuration in a readable format.
    
    .PARAMETER Config
        Configuration hashtable from Get-ScoutConfig.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [hashtable] $Config
    )

    Write-Host "`n===== Scout Deployment Configuration =====" -ForegroundColor Cyan
    Write-Host "`nTenant:" -ForegroundColor Yellow
    Write-Host "  Name:          $($Config.TenantName)"
    Write-Host "  ID:            $($Config.TenantId)"
    Write-Host "  Domain:        $($Config.Domain) / $($Config.DomainAlt)"
    Write-Host "  Licensed User: $($Config.LicensedUser)"
    Write-Host "  App Client ID: $($Config.AppClientId)"
    Write-Host "  App Object ID: $($Config.AppObjectId)"
    Write-Host "  App Name:      $($Config.AppName)"
    
    Write-Host "`nFleet:" -ForegroundColor Yellow
    Write-Host "  System Name:   $($Config.SystemName)"
    Write-Host "  Primary Node:  $($Config.PrimaryNodeIp) ($($Config.PrimaryNodeName))"
    if ($Config.AdditionalNodes -and $Config.AdditionalNodes.Count -gt 0) {
        Write-Host "  Additional:    $($Config.AdditionalNodes -join ', ')"
    }
    
    Write-Host "`nDeployment:" -ForegroundColor Yellow
    Write-Host "  Target User:   $($Config.TargetUser)"
    Write-Host "  Scout Version: $($Config.ScoutVersion)"
    Write-Host "  Installer:     $($Config.InstallerPath)"
    
    Write-Host "`nPaths:" -ForegroundColor Yellow
    Write-Host "  Skills:        $($Config.LocalSkillsRoot)"
    Write-Host "  Memory:        $($Config.LocalMemoryRoot)"
    Write-Host "  Sessions:      $($Config.LocalSessionRoot)"
    Write-Host "  Logs:          $($Config.LogDir)"
    
    Write-Host "`n==========================================`n" -ForegroundColor Cyan
}

Export-ModuleMember -Function Get-ScoutConfig, Show-ScoutConfig
