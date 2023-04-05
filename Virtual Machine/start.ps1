$group="AmitRG"
$location="centralindia"

$instance = Read-Host "How many VMs do you want to create? "

if ($instance -eq 0 -or $instance -eq "") {
    Write-Host "No VMs will be created"
    Exit 1
}

function generateKeys {
    $KeyPair = New-SSHKey -KeyAlgorithm rsa -KeyLength 4096
    $PrivateKeyPath = "C:\Users\amitdg\.ssh\" 
    $KeyPair.PrivateKey | Out-File $PrivateKeyPath -Encoding ascii  
    $PublicKeyPath = "C:\Users\amitdg\.ssh\" 
    $KeyPair.PublicKey | Out-File $PublicKeyPath -Encoding ascii
    
    Write-Host "Keys generated successfully"
}
generateKeys

Write-Output "Initializing the VM creation process..."

New-AzResourceGroup -n $group -l $location

$vnet = @{
    Name = "vm-net"
    ResourceGroupName = $group
    Location = $location
    AddressPrefix = "10.0.0.0/16"
}

$virtualNetwork = New-AzVirtualNetwork @vnet

$subnet = @{
    Name = "vm-subnet"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = "10.0.0.0/24"
}

$subnetConfig = New-AzVirtualNetworkSubnetConfig @subnet

$virtualNetwork | Set-AzVirtualNetwork

function vmCreate{
    for ($i = 0; $i -lt $instance; $i++) {
        New-AzVM 
    }
}