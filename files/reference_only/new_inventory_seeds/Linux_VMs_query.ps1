# Script to Retrieve VMs with Linux OS from PSU API - OutPuts to $Results
# Variables
$ArrayLinux = @("*Red*", "*Oracle*")

$ArrayVC_NonProd = @("igqprqavc01", "se4prtsvc01")
$ArrayVC_Prod = @("tukvvvc02", "igqprvc01", "se4prvc01")


# Invoke Method
$RVtoolsvInfo = Invoke-RestMethod http://igqprmgtpsu01:443/RVTools_vInfo -Method GET

# The Do
$RVToolsvInfoFilter = @();
foreach ($item in $ArrayLinux) {
    foreach ($vm in $RVToolsVInfo) {
        if (($vm.vInfoVISDKServer -in $ArrayVC_NonProd -and $vm.vInfoTemplate -eq "False" -and $vm.vInfoPowerState -eq "poweredOn") -and ($vm.vInfoOS -like $item -or $vm.vInfoOSTools -like $item)) {
            $RVToolsvInfoFilter_NonProd += $vm
        }
    }
}

#Unique Results
$Results = $RVToolsvInfoFilter |  Select-Object -Property vInfoGuestHostName,vInfoPrimaryIPAddress,vInfoCluster,vInfoVISDKServer,vInfoVMName,vInfoOSTools,vInfoOS,vInfoResourcepool,vInfoFolder | Sort-Object vInfoGuestHostName -Unique | Export-Csv -Path ./Linux_VMs_vInfo_NonProd-$(get-date -f yyyy-MM-dd).csv -NoTypeInformation
#$Results = $RVToolsvInfoFilter |  Select-Object -Property vInfoCluster,vInfoVISDKServer,vInfoVMName,vInfoGuestHostName,vInfoPrimaryIPAddress,vInfoOSTools,vInfoOS,vInfoResourcepool,vInfoFolder | Sort-Object vInfoVMName -Unique | Export-Csv -Path ./Linux_VMs_vInfo_NonProd-$(get-date -f yyyy-MM-dd).csv -NoTypeInformation
#$Results = $RVToolsvInfoFilter | Sort-Object vInfoVMName -Unique | Export-Csv -Path ./Linux_VMs_vInfo.csv -NoTypeInformation