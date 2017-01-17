
Param(
    [Parameter( Mandatory = $false)]
    $subscription="5050b769-83ab-4f02-a6cb-0c0af0afa991",
    #$rgNames= ("NonProd-A-East","NonProd-B-East","Prod-A-East","Prod-B-East","Service-A-East","Service-B-East","Staging-A-East","Staging-B-East","NonProd-A-East2","NonProd-B-East2","Prod-A-East2","Prod-B-East2","Service-A-East2","Service-B-East2","Staging-A-East2","Staging-B-East2"),
    $rgNames= ("Prod-A-East"),
    $connection1="DC1-connection",
    $connection2="DC2-connection",
    $regionEast="East US",
    $regionEast2="East US2",
    $vnetgw="prod-vpn-a",
    $localgw1="localgw-datacenter1",
    $localgw2="localgw-datacenter2",
    
    $sharedkey="AAAAB3NzaC1yc2EAAAABJQAAASomeStuff",

    #set the acitve connection
    $active="DC1-connection"


)

Set-AzureRmContext -SubscriptionID $subscription
if ($active -eq $connection1)
{
# This loop will remove the connectionName2
    Foreach($name in $rgNames)
        {
            remove-AzureRmVirtualNetworkGatewayConnection -Name $connection2 -ResourceGroupName $name -Verbose -Force
        }

# It creates a new local gateway using $localgw2 variable and establishes connection2
    Foreach($name in $rgNames)
        {
            New-AzureRmLocalNetworkGateway -Name $localgw1 -ResourceGroupName $name -Location $regionEast -GatewayIpAddress '52.184.193.54' -AddressPrefix '10.186.8.0/21' -Force
            $local = Get-AzureRmLocalNetworkGateway -Name $localgw1 -ResourceGroupName $name
            New-AzureRmVirtualNetworkGatewayConnection -Name $connection2 -ResourceGroupName $name -Location $regionEast -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local -ConnectionType IPsec -RoutingWeight 10 -SharedKey $sharedkey -Force
        }
}
                
else{

# This loop will remove the connectionName1
Write-Host "Changing the default connection to connection2"
    Foreach($name in $rgNames)
        {
            remove-AzureRmVirtualNetworkGatewayConnection -Name $connection1 -ResourceGroupName $name -Verbose -Force
        }

# It creates a new local gateway using $localgw2 variable and establishes connection2
    Foreach($name in $rgNames)
        {
            New-AzureRmLocalNetworkGateway -Name $localgw2 -ResourceGroupName $name -Location $regionEast -GatewayIpAddress '52.184.193.54' -AddressPrefix '10.186.8.0/21' -Force
            $local = Get-AzureRmLocalNetworkGateway -Name $localgw2 -ResourceGroupName $name
            New-AzureRmVirtualNetworkGatewayConnection -Name $connection2 -ResourceGroupName $name -Location $regionEast -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local -ConnectionType IPsec -RoutingWeight 10 -SharedKey $sharedkey -Force
        }
    }

                
