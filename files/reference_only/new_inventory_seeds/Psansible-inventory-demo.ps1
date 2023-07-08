import-module psansible.inventory

# Creating a new inventory

$Inventory = New-AnsibleInventory
$Inventory

#Creating Hiearchy

$Arch = @()

$Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all" -Children "all_nonprod_linux_servers","all_prod_linux_servers"
# $Arch += New-AnsibleInventoryHiearchyEntry -ParentName "all_database_servers" -Children "all_mongodb_servers","all_postgres_servers"
$Arch

$Inventory.AddHiearchy($Arch)

<#
    Let's try an import  
#>

$Inventory.

<#
    Working with Variables
#>

$vars = @();
# $vars += New-AnsibleInventoryVariable -Name "plop" -Type Group -Value "WWW" -ContainerName "ABC"
$vars += New-AnsibleInventoryVariable -Name "ip_addr" -Type Host -Value "1.1.1.1" -ContainerName "server123"
$vars

#Adding a variable to an PsAnsibleInventory

$Inventory.AddVariable($vars) 

$Inventory


#Fetching variabl

$VariableCollection.GetGroupVariables($Inventory)
$VariableCollection.GetHostVariables($Inventory)

#Showing Grouping

$VariableCollection.GetGrouping($Inventory)

# $VariableCollection.GetVariable('wsusServer')
# $VariableCollection.GetVariableFromContainer('Node0055620.Node-005.dev.woop.net')

#Adding the Variables to the Inventory

$Inventory.SetVariableCollection($VariableCollection)


#Exporting the data
$Inventory.SetPath('/Users/mark.nottagealaskaair.com/ansible-playbooks/as-illumio_onboard/')

$Inventory.Export()
