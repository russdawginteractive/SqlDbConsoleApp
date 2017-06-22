# Sign in to Azure.
Add-AzureRmAccount

# If you have multiple subscriptions, uncomment and set to the subscription you want to work with.
#$subscriptionId = "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}"
#Set-AzureRmContext -SubscriptionId $subscriptionId

# Provide these values for your new AAD app.
# $appName is the display name for your app, must be unique in your directory.
# $uri does not need to be a real uri.
# $secret is a password you create.

$appName = "RTG-SQLConsoleAppTest"
$uri = "http://RTG-SQLConsoleAppTest"
$secret = "SummerParty"

# Create a AAD app
$azureAdApplication = New-AzureRmADApplication -DisplayName $appName -HomePage $Uri -IdentifierUris $Uri -Password $secret

# Create a Service Principal for the app
$svcprincipal = New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId

# To avoid a PrincipalNotFound error, I pause here for 15 seconds.
Start-Sleep -s 15

# If you still get a PrincipalNotFound error, then rerun the following until successful. 
$roleassignment = New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $azureAdApplication.ApplicationId.Guid


# Output the values we need for our C# application to successfully authenticate

Write-Output "Copy these values into the C# sample app"

Write-Output "_subscriptionId:" (Get-AzureRmContext).Subscription.SubscriptionId
Write-Output "_tenantId:" (Get-AzureRmContext).Tenant.TenantId
Write-Output "_applicationId:" $azureAdApplication.ApplicationId.Guid
Write-Output "_applicationSecret:" $secret