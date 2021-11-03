// module kubernetes
// The DNS prefix to use with hosted Kubernetes API server FQDN.
param dnsPrefix string = 'cl01'

// The name of the Managed Cluster resource
param clusterName string = 'aks101'

// Specifies the Azure location where the key vault should be created.
param location string = resourceGroup().location

// The number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production
param agentCount int = {
  default: 1
  minValue: 1
  maxValue: 50
}

// The size of the Virtual Machine.
param agentVMSize string = 'Standard_D2_v3'

param tagEnvironmentNameAks string
param tagCostCenterAks string
param vnetSubnetId string

resource aks 'Microsoft.ContainerService/managedClusters@2020-09-01' = {
  name: clusterName
  location: location
  tags: {
    Environment: tagEnvironmentNameAks
    tagCostCenter: tagCostCenterAks
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enableRBAC: true
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'pool01'
        count: agentCount
        mode: 'System'
        vmSize: agentVMSize
        type: 'VirtualMachineScaleSets'
        osType: 'Linux'
        enableAutoScaling: false
        vnetSubnetID: vnetSubnetId
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
    }
  }
}

output id string = aks.id
output apiServerAddress string = aks.properties.fqdn
output name string = aks.name
