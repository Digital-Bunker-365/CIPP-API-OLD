function Get-CIPPAlertSecDefaultsUpsell {
    <#
    .FUNCTIONALITY
        Entrypoint
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        $input,
        $TenantFilter
    )
    $LastRunTable = Get-CIPPTable -Table AlertLastRun


    try {
        try {
            $SecDefaults = (New-GraphGetRequest -uri 'https://graph.microsoft.com/beta/policies/identitySecurityDefaultsEnforcementPolicy' -tenantid $TenantFilter)
            if ($SecDefaults.isEnabled -eq $false -and $SecDefaults.securityDefaultsUpsell.action -in @('autoEnable', 'autoEnabledNotify')) {
                'Security Defaults will be automatically enabled on {0}' -f $SecDefaults.securityDefaultsUpsell.dueDateTime
               
            }
        } catch {}
        $LastRun = @{
            RowKey       = 'SecDefaultsUpsell'
            PartitionKey = $TenantFilter
        }
        Add-CIPPAzDataTableEntity @LastRunTable -Entity $LastRun -Force
    } catch {
        # Error handling
    }
}

