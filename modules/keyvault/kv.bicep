// module keyvault
//Specifies the name of the key vault.
param vaultName string ='kvwesteurope01'

// Specifies the Azure location where the key vault should be created.
param location string = resourceGroup().location

// Specifies whether the key vault is a standard vault or a premium vault.
param sku string 

// Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
param tenant string 

// Specifies the permissions to secrets in the vault.
param accessPolicies array 

param tagEnvironmentNameKv string
param tagCostCenterKv string

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: vaultName
  location: location
  tags: {
    Environment: tagEnvironmentNameKv
    tagCostCenter: tagCostCenterKv
  }
  properties: {
    tenantId: tenant
    sku: {
      family: 'A'
      name: sku
    }
    accessPolicies: accessPolicies
  }
}

output name string = keyvault.name
