targetScope = 'subscription'

// virtual network parameters
param vnetName string = 'vnet-d-eus-001'
param vnetLocation string = 'east us'
param vnetAddressPrefix string = '12.0.0.0/16'
param subnetName1 string = 'snet-d-eus-001-aks-pool01'
param subnetPrefix1 string = '12.0.1.0/24'
param tagEnvironmentNameVnet string = 'development'
param tagCostCenterVnet string = '123'

// kubernetes parameters
param dnsPrefix string = 'aksdeus001'
param clusterName string = 'aks-d-eus-001'
param aksLocation string = 'eus'
param agentCount int = 2
param agentVMSize string = 'Standard_D2_v3'
param tagEnvironmentNameAks string = 'development'
param tagCostCenterAks string = '123'

// keyvault parameters
param vaultName string = 'kvdeus001'
param kvLocation string = 'east us'
param sku string = 'standard'
param tenant string = '86545b4b-8dd6-4b55-95f3-8d2bbdad26a1'  // replace with your tenantId
param accessPolicies array = [
  {
    tenantId: tenant
    objectId: '828e6504-de17-412d-9f88-58cfb090ad98'  // replace with your objectId
    permissions: {
      secrets: [
        'Get'
        'List'
        'Set'
      ]
    }
  }
]
param secretName string = 'password'
param secretValue string = '12345'
param tagEnvironmentNameKv string = 'development'
param tagCostCenterKv string = '123'

// resource group infra
resource rgInfra 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '_rg-infra-d-eus-001'
  location: 'east us'
}

// resource group kubernetes
resource rgAks 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '_rg-aks-d-eus-001'
  location: 'east us'
}

// module virtual network
module vnet './modules/virtualnetwork/vnet.bicep' = {
  name: 'vnet01'
  scope: resourceGroup(rgInfra.name)
  params: {
    vnetName: vnetName
    vnetLocation: vnetLocation
    vnetAddressPrefix: vnetAddressPrefix
    subnetName1: subnetName1
    subnetPrefix1: subnetPrefix1
    tagEnvironmentNameVnet: tagEnvironmentNameVnet
    tagCostCenterVnet: tagCostCenterVnet
  }
}

// module azure kubernetes service
module aks './modules/kubernetes/aks.bicep' = {
  name: 'aks01'
  scope: resourceGroup(rgAks.name)
  params: {
    dnsPrefix: dnsPrefix
    clusterName: clusterName
    location: aksLocation
    agentCount: agentCount
    agentVMSize: agentVMSize
    vnetSubnetId: vnet.outputs.subnets[0].id
    tagEnvironmentNameAks: tagEnvironmentNameAks
    tagCostCenterAks: tagCostCenterAks
  }
}

// module keyvault
module kv './modules/keyvault/kv.bicep' = {
  name: 'kv01'
  scope: resourceGroup(rgInfra.name)
  params: {
    vaultName: vaultName
    location: kvLocation
    sku: sku
    tenant: tenant
    accessPolicies: accessPolicies
    tagEnvironmentNameKv: tagEnvironmentNameKv
    tagCostCenterKv: tagCostCenterKv
  }
}

// create secret in existing KeyVault
//resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
//  name: '${vaultName.name}/${secretName}'
//  properties: {
//    attributes: {
//      enabled: true
//    }
//    value: secretValue
//  }
//}
