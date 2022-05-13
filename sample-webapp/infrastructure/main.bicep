param appServicePlanName string
param appServicePlanResourceGroup string

param webAppName string
param containerImage string

@secure()
param registryUsername string
@secure()
param registryPassword string

param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: appServicePlanName
  scope: resourceGroup(appServicePlanResourceGroup)
}

resource sampleWebApp 'Microsoft.Web/sites@2021-03-01' = {
  name: webAppName
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource sampleWebAppSlot 'Microsoft.Web/sites/slots@2021-03-01' = {
  parent: sampleWebApp
  name: 'preproduction'
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerImage}'
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: registryUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: registryPassword
        }
      ]
    }
  }
}
