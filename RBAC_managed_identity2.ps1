# Install the module.
# Install-Module Microsoft.Graph -Scope CurrentUser

# The tenant ID - replace from Azure active directory overview page
$TenantId = "908fe88c-5536-4488-a62f-c6f6a418b4eb"

# The name of your web API name and the resource group name, which has a managed identity.
$webAppName = "msi-test1-webapi1"
# Resource group of WebAPIs
$resourceGroupName = "Test1-RG"

# The name of the app role that the managed identity should be assigned to.
$appRoleName = "API2.FullAccess"

# Get the web app's managed identity's object ID.
Connect-AzAccount -Tenant $TenantId
$managedIdentityObjectId = (Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $webAppName).identity.principalid

Connect-MgGraph -TenantId $TenantId -Scopes 'Application.Read.All','Application.ReadWrite.All','AppRoleAssignment.ReadWrite.All','Directory.AccessAsUser.All','Directory.Read.All','Directory.ReadWrite.All'

# Get Microsoft Graph app's service principal and app role.
$serverApplicationName = "WebAPI2-msi-test"
$serverServicePrincipal = (Get-MgServicePrincipal -Filter "DisplayName eq '$serverApplicationName'")
$serverServicePrincipalObjectId = $serverServicePrincipal.Id

$appRoleId = ($serverServicePrincipal.AppRoles | Where-Object {$_.Value -eq $appRoleName }).Id

# Assign the managed identity access to the app role.
New-MgServicePrincipalAppRoleAssignment `
    -ServicePrincipalId $managedIdentityObjectId `
    -PrincipalId $managedIdentityObjectId `
    -ResourceId $serverServicePrincipalObjectId `
    -AppRoleId $appRoleId
