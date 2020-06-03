# This script activates Windows either by using the key in the BIOS / SLIC 3.0 or from a manual entered key.
# NOTE: This will NOT activate Windows without a legitimate license!!

# Regular expression to validate the keys
$keyRegExp = '^([A-Z1-9]{5})-([A-Z1-9]{5})-([A-Z1-9]{5})-([A-Z1-9]{5})-([A-Z1-9]{5})$'
# Obtain the SLIC 3.0 key through WMI
$key = (Get-WmiObject -Class SoftwareLicensingService).OA3xOriginalProductKey

if(!$key) {
    Write-Host 'No OEM key from BIOS detected, please enter it manually...'
    $key = Read-Host 'Enter Windows License key'
    Write-Host $tempkey
} else {
    Write-Host 'Found OEM license key'
}
# Re-Check if there is a license key
if ($key -match $keyRegExp) {
    Write-Host 'Using key' $key 'to activate Windows'
    Invoke-Expression "cscript /b C:\windows\system32\slmgr.vbs /upk"
    Invoke-Expression "cscript /b C:\windows\system32\slmgr.vbs /ipk $key"
    Invoke-Expression "cscript /b C:\windows\system32\slmgr.vbs /ato"
} else {
    Write-Warning 'No or invalid license key detected, skipping activation'
}