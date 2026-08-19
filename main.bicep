param location string = 'swedencentral'
param storageAccountName string = 'stcloudcourse2026'
param appServicePlanName string = 'asp-cloud-course'
param webAppName string = 'webapp-cloud-course-2026'
param vnetName string = 'vnet-cloud-course'
param nsgName string = 'nsg-vm-subnet'
param myIpAddress string = '88.80.101.158'
param enablePublicBlobAccess bool = true

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: enablePublicBlobAccess
  }
  tags: {
    project: 'cloud-course'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|24-lts'
    }
  }
}

module networking 'networking.bicep' = {
  name: 'networkingDeployment'
  params: {
    location: location
    vnetName: vnetName
    nsgName: nsgName
    myIpAddress: myIpAddress
  }
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output storageAccountBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
