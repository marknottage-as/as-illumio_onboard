1 #Script to Retrieve VMs with Linux OS from PSU API (not tested for production) | OutPuts to $Results 
2 #Variables 
3   $Array_Linux = @("*Linux*", "*CentOS*", "*FreeBSD*", "*Oracle*", "*Debian*", "*Fedora*", "*Other*") 
4   $Array_VC = @("igqprvc01", "se4prtsvc01") 
5 
6 #Invoke Method 
7   $RVtools_vInfo = Invoke-RestMethod http://igqprmgtpsu01:443/RVTools_vInfo -Method GET
8 
9 #The Do 
10   $RVTools_vInfo_Filter = @() foreach ($item in $Array_Linux) 
11     { foreach ($vm in $RVTools_VInfo) 
12       { if (($vm.vInfoVISDKServer -in $Array_VC -and $vm.vInfoTemplate -eq "False") -and ($vm.vInfoOS -like $item -or $vm.vInfoOSTools -like $item)) 
13         { $RVTools_vInfo_Filter += $vm } 
14       } 
15     } 
16 
17 #Unique Results 
18   $Results = $RVTools_vInfo_Filter | Sort-Object vInfoVMName -Unique
~                                                                         