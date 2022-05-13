param appServicePlanName string
param appServicePlanGroup string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' existing = {
  name: appServicePlanName
  scope: resourceGroup(appServicePlanGroup)
}
