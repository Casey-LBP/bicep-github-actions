// module virtual network
// VNet name
param vnetName string = 'vnet01'

// Location of the virtual network
param vnetLocation string =resourceGroup().location

// Address prefix
param vnetAddressPrefix string = '10.0.0.0/16'

// Subnet 1 Name
param subnetName1 string = 'subnet1'

// Subnet 1 Prefix
param subnetPrefix1 string = '10.0.1.0/24'

param tagEnvironmentNameVnet string
param tagCostCenterVnet string

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: vnetLocation
  tags: {
    Environment: tagEnvironmentNameVnet
    tagCostCenter: tagCostCenterVnet
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName1
        properties: {
          addressPrefix: subnetPrefix1
        }
      }
    ]
  }
}

output id string = vnet.id
output name string = vnet.name
output subnets array = vnet.properties.subnets
