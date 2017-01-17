 
Param(
    [Parameter( Mandatory = $false)]
    $subscription="your-subscriptionid-goes-here",
    #$rgNames= ("NonProd-A-East","NonProd-B-East","Prod-A-East","Prod-B-East","Service-A-East","Service-B-East","Staging-A-East","Staging-B-East","NonProd-A-East2","NonProd-B-East2","Prod-A-East2","Prod-B-East2","Service-A-East2","Service-B-East2","Staging-A-East2","Staging-B-East2"),
    $rgNames= ("Prod-East","NonProd-East"),
    $connection1="DC1-connection",
    $connection2="DC2-connection",
    $regionEast="East US",
    $regionEast2="East US2",
    #$vnetgw="vpn-gateway-east",
    $localgw1="localgw-datacenter1",
    $localgw2="localgw-datacenter2",
    
    $sharedkey="your-key-goes-here",

    #set the acitve connection
    $active="DC1-connection"

　
)

Set-AzureRmContext -SubscriptionID $subscription
if ($active -eq $connection1)
{
# This loop will remove the connectionName2
Write-Host "Changing the default connection to connection1"
    Foreach($name in $rgNames)
        {
            remove-AzureRmVirtualNetworkGatewayConnection -Name $connection2 -ResourceGroupName $name -Verbose -Force
        
# It creates a new local gateway using $localgw2 variable and establishes connection2
            New-AzureRmLocalNetworkGateway -Name $localgw1 -ResourceGroupName $name -Location $regionEast -GatewayIpAddress '13.82.29.253' -AddressPrefix '10.186.16.0/20' -Force
            $local1 = Get-AzureRmLocalNetworkGateway -Name $localgw1 -ResourceGroupName $name
            $gateway1= Get-AzureRmVirtualNetworkGateway -ResourceGroupName $name
            New-AzureRmVirtualNetworkGatewayConnection -Name $connection1 -ResourceGroupName $name -Location $regionEast -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local1 -ConnectionType IPsec -RoutingWeight 10 -SharedKey $sharedkey -Force
        }
}
                
else{

# This loop will remove the connectionName1
Write-Host "Changing the default connection to connection2"
    Foreach($name in $rgNames)
        {
            remove-AzureRmVirtualNetworkGatewayConnection -Name $connection1 -ResourceGroupName $name -Verbose -Force
        
        # It creates a new local gateway using $localgw2 variable and establishes connection2
   
            New-AzureRmLocalNetworkGateway -Name $localgw2 -ResourceGroupName $name -Location $regionEast -GatewayIpAddress '52.184.193.54' -AddressPrefix '10.186.16.0/20' -Force
            $local2 = Get-AzureRmLocalNetworkGateway -Name $localgw2 -ResourceGroupName $name
            $local2 = Get-AzureRmLocalNetworkGateway -Name $localgw2 -ResourceGroupName $name
            $gateway2= Get-AzureRmVirtualNetworkGateway -ResourceGroupName $name
            New-AzureRmVirtualNetworkGatewayConnection -Name $connection2 -ResourceGroupName $name -Location $regionEast -VirtualNetworkGateway1 $gateway2 -LocalNetworkGateway2 $local2 -ConnectionType IPsec -RoutingWeight 10 -SharedKey $sharedkey -Force
        }
    }

                 
