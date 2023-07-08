# Script to Retrieve VMs with Linux OS from PSU API - OutPuts to $Results
# Variables
#$ArrayLinux = @("*Red*", "*Oracle*", "*Other*")
$ArrayLinux = @("*Red*", "*Oracle*")

$ArrayVC_NonProd = @("igqprqavc01", "se4prtsvc01")
$ArrayVC_Prod = @("tukvvvc02", "igqprvc01", "se4prvc01")


# Invoke Method
$RVtoolsvInfo = Invoke-RestMethod http://igqprmgtpsu01:443/RVTools_vInfo -Method GET

#
#NON PROD---------------------------------
#

# The Do
$RVToolsvInfoFilter_NonProd = @()
foreach ($item in $ArrayLinux) {
    foreach ($vm in $RVToolsVInfo) {
        if (($vm.vInfoVISDKServer -in $ArrayVC_NonProd -and $vm.vInfoTemplate -eq "False" -and $vm.vInfoPowerState -eq "poweredOn") -and ($vm.vInfoOS -like $item -or $vm.vInfoOSTools -like $item)) {
            $RVToolsvInfoFilter_NonProd += $vm
        }
    }
}

#Unique Results
#$RVToolsvInfoFilter_NonProd_Results = $RVToolsvInfoFilter_NonProd | Select-Object vInfoGuestHostName, vInfoPrimaryIPAddress, vInfoOSTools, vInfoVMName, vInfoOS, vInfoCluster, vInfoVISDKServer
$RVToolsvInfoFilter_NonProd_Results = $RVToolsvInfoFilter_NonProd | Select-Object @{E="vInfoVISDKServer";L="Datacenter"}, @{E="vInfoGuestHostName";L="ansible_fqdn"}, @{E="vInfoPrimaryIPAddress";L="ansible_host"}

#$Json_Results_NonProd = $RVToolsvInfoFilter_NonProd_Results | ConvertTo-Json
$Results_NonProd = $RVToolsvInfoFilter_NonProd_Results

# $Json_Results_NonProd | Out-File -FilePath "C:\Users\v-emoeckel\OneDrive - Alaska Airlines, Inc\Documents\Linux_VMs_vInfo_NonProd-$(get-date -f yyyy-MM-dd).json"
#$Json_Results_NonProd | Out-File -FilePath /Users/mark.nottagealaskaair.com/ansible-playbooks/as-illumio_onboard/Linux_VMs_vInfo_NonProd-$(get-date -f yyyy-MM-dd).json
$Results_NonProd | Export-Csv -Path /Users/mark.nottagealaskaair.com/ansible-playbooks/as-illumio_onboard/Linux_VMs_vInfo_NonProd-$(get-date -f yyyy-MM-dd).csv -NoTypeInformation


#
#PROD---------------------------------
#

#UnComment to run Prod
<#

#The Do
$RVToolsvInfoFilter_Prod = @()
foreach ($item in $ArrayLinux) {
    foreach ($vm in $RVToolsVInfo) {
        if (($vm.vInfoVISDKServer -in $ArrayVC_Prod -and $vm.vInfoTemplate -eq "False") -and ($vm.vInfoOS -like $item -or $vm.vInfoOSTools -like $item)) {
            $RVToolsvInfoFilter += $vm
        }
    }
}
$RVToolsvInfoFilter_Prod_Results = $RVToolsvInfoFilter_Prod | Select-Object vInfoVMName, vInfoGuestHostName, vInfoPrimaryIPAddress, vInfoOS, vInfoOSTools, vInfoCluster, vInfoVISDKServer
$Json_Results_Prod = $RVToolsvInfoFilter_Prod_Results | ConvertTo-Json
$Json_Results_Prod | Out-File -FilePath "C:\Users\v-emoeckel\OneDrive - Alaska Airlines, Inc\Documents\Linux_VMs_vInfo_Prod-$(get-date -f yyyy-MM-dd).json"

#>
