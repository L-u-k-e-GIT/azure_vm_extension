terraform {
  required_providers {
  
    azapi = {
      source  = "azure/azapi"
      version = "~>0.1"
    }
  }
}




resource "azurerm_virtual_machine_extension" "VMperfomancediag" {
   
  name                 = "AzurePerformanceDiagnostics"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.Azure.Performance.Diagnostics"
  type                       = "AzurePerformanceDiagnostics"
  type_handler_version       = "1.0"
  # get handler version  -> az vm extension image list --location germanywestcentral -o table | grep "Microsoft.Azure.Diagnostics"
  auto_upgrade_minor_version = "true"
   settings = <<SETTINGS
    {
        "performanceScenario": "quick",
        "traceDurationInSeconds": 5,
        "srNumber": "",
        
        "networkTrace": "",
        "perfCounterTrace": "p",
        "xperfTrace": "",
        "storPortTrace": "",
        "configurations": {
                        "InstallOnly": "false",
                        "Symptoms": "",
                        "UserAgreedToShareData": "false"
                    },
        "storageAccountName": "${var.MD_DIAG_STORAGE_ACCOUNT}",
        "resourceId" : "${var.MD_VIRTUAL_MACHINE_ID}"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {        
        "storageAccountKey":  "${var.MD_ST_DIAG_KEY}"
       
         }
SETTINGS

      tags = var.MD_ALL_TAGS 
 
   }
  
 

resource "azurerm_virtual_machine_extension" "admincenter" {
  #non esiste policy
  name                 = "AdminCenter"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.AdminCenter"
  type                       = "AdminCenter"
  type_handler_version       = "0.0"
  # get handler version  -> az vm extension image list --location germanywestcentral -o table | grep "Microsoft.Azure.Diagnostics"
  auto_upgrade_minor_version = "true"
  settings = <<SETTINGS
  {
                        "port": 6519                        
   }
  SETTINGS 
  tags = var.MD_ALL_TAGS 
}

resource "azurerm_virtual_machine_extension" "NetworkWatcker" {
   
  name                 = "AzureNetworkWatcherExtension"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  tags = var.MD_ALL_TAGS 
}

# Dependency Agent for Windows
resource "azurerm_virtual_machine_extension" "da" {
  name                       = "DependencyAgentWindows"
  virtual_machine_id         =  var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.0"
  auto_upgrade_minor_version = true
 ## Get version -> az vm extension image list --location germanywestcentral -o table | findstr "Microsoft.Azure.Monitoring.DependencyAgent"
 tags = var.MD_ALL_TAGS 
}

resource "azurerm_virtual_machine_extension" "vm_insights" {
  name                       = "MicrosoftMonitoringAgent"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring" 
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
# get version az vm extension image list --location germanywestcentral -o table | findstr "Microsoft.EnterpriseCloud.Monitoring"
  settings = <<SETTINGS
    {
      "workspaceId" :  "${var.MD_WORKSPACEID}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey" : "${var.MD_WORKSPACEID_KEY}"
    }
 PROTECTED_SETTINGS

 tags = var.MD_ALL_TAGS 

}



resource "azurerm_virtual_machine_extension" "ama" {
   
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = "true"
  automatic_upgrade_enabled  = "true"
  tags = var.MD_ALL_TAGS 
}


resource "azapi_resource" "dcr_association" {
  provider  = azapi
  name      = "dcr-ass-${var. MD_VIRTUAL_MACHINE_NAME}"
  parent_id = var.MD_VIRTUAL_MACHINE_ID
  type      = "Microsoft.Insights/dataCollectionRuleAssociations@2021-04-01"
  body      = jsonencode({
    properties = {
      dataCollectionRuleId = var.MD_DCR_ID
    }
  })
  
}


