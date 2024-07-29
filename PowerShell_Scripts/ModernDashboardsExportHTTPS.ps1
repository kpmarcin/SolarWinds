
# Adding security settings
#Set-ExecutionPolicy Unrestricted -Force

# Clearing all previous errors (if any)
$error.Clear()

cls

# Safe checking certificate settings
# This is required, if there is a self signed certificate or it is outdated
if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
{
$certCallback=@"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            if(ServicePointManager.ServerCertificateValidationCallback ==null)
            {
                ServicePointManager.ServerCertificateValidationCallback += 
                    delegate
                    (
                        Object obj, 
                        X509Certificate certificate, 
                        X509Chain chain, 
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
    }
"@
    Add-Type $certCallback
 }
[ServerCertificateValidationCallback]::Ignore();

############
#
# Script Parameters - Start
#

$dashboardFile = "C:\Scripts\ExportedDashboard.json"
$dashboardId = "15"

$OrionServer = "localhost"
$OrionPort = "17774"

$url = "https://$($OrionServer):$OrionPort/SolarWinds/InformationService/v3/Json/Invoke/Orion.Dashboards.Instances/Export"

$useSavedCredentials = $false

#
# Option for saving encrypted password to XML
#
# First, encrypt the password using command: 
# GET-CREDENTIAL –Credential $login | EXPORT-CLIXML -path C:\Scripts\credentials.xml
#
# Next, you can import XML using command: 
# $credObject = IMPORT-CLIXML C:\Scripts\credentials.xml
#

[string]$userName = 'testAccount'
[string]$userPassword = '_P@$$w0rD123'
[securestring]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)

#
# Script Parameters - End
#
############

# Clearing up
$output = $null
$outputContent = $null
$body = $null
$header = $null

# Preparing body for REST API
$body = '{"dashboardId": "'+$dashboardId+'"}'

# Preparing header for REST API
$header = @{
"Accept"="application/json"
"Content-Type"="application/json"
} 

# Checking if script should ask for credentials
if($useSavedCredentials -ne $true) {$credObject = $null; $credObject = GET-CREDENTIAL –Credential YourUserLogin}

# Sending request
$output = Invoke-WebRequest -Uri $url -UseBasicParsing -Method 'POST' -Credential $credObject -Headers $header -Body $body

# Converting and saving the dashboard (but only, if the HTTP code is 200)
if($output.StatusCode -eq 200) {

    $outputContent = $output.Content | ConvertFrom-Json

    # Saving Dashboard to the file
    $outputContent | Out-File $dashboardFile
}

# Count number of errors
$errorsCounter = 0
$error | ForEach {$errorsCounter += 1}

# Checking if dashboard exist in SolarWinds
if( $($error | Out-String)  -like '*no dashboard*') {
    
    Write-Host "------"
    Write-Host "No dashboard for export with ID $dashboardId"
    Write-Host "------"

    Exit
}

if($errorsCounter -gt 0) {

    Write-Host "------"
    Write-Host "Something went wrong. Please check PowerShell errors."
    Write-Host "------"

    Exit
}

# Displaying output
Write-Host "------"
Write-Host "Note: Status Code 200 and Description 'OK' is correct and it means that REST API finished successfully."
Write-Host "------"
Write-Host "HTTPS Status Code:" $output.StatusCode
Write-Host "HTTPS Status Description:" $output.StatusDescription
Write-Host "------"