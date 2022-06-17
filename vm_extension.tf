terraform {
  required_providers {
  
    azapi = {
      source  = "azure/azapi"
      version = "~>0.1"
    }
  }
}



/*



 resource "azurerm_virtual_machine_extension" "VMDiagnosticsSettings" {
 #esiste policy ma non abilita l'interno delle vm
 
  name                 = "DiagnosticSettings"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.5"
  # get handler version  -> az vm extension image list --location germanywestcentral -o table | grep "Microsoft.Azure.Diagnostics"
  auto_upgrade_minor_version = "true"
  settings = <<SETTINGS
    {
      "StorageAccount": "${var.MD_DIAG_STORAGE_ACCOUNT}",
      "WadCfg": {
                        "DiagnosticMonitorConfiguration": {
                            "overallQuotaInMB": 5120,
                            "Metrics": {
                                "resourceId": "${var.MD_VIRTUAL_MACHINE_ID}",
                                "MetricAggregation": [
                                    {
                                        "scheduledTransferPeriod": "PT1H",
                                         "sinks": "AzureMonitor"
                                    },
                                    {
                                        "scheduledTransferPeriod": "PT1M",
                                         "sinks": "AzureMonitor"
                                    }
                                ]
                            },
                            "DiagnosticInfrastructureLogs": {
                                "scheduledTransferLogLevelFilter": "Error",
                                "scheduledTransferPeriod": "PT1M"
                            },
                            "PerformanceCounters": ${file("${path.module}/Windows_diag_config.json")}, 
                            "SinksConfig": {
                                "Sink": [
                                    {
                                        "AzureMonitor": {},
                                        "name": "AzureMonitor"
                                    }
                                ]
                            },
                            "WindowsEventLog": ${file("${path.module}/Windows_diag_evt.json")},
                            "Directories": {
                                "scheduledTransferPeriod": "PT1M"
                            }
                        },
                        "SinksConfig": {
                            "Sink": [
                                {
                                    "AzureMonitor": {},
                                    "name": "AzureMonitor"
                                }
                            ]
                        }
                 }
                
              
    }
    
  SETTINGS

protected_settings = <<PROTECTED_SETTINGS
   {
    "storageAccountName": "${var.MD_DIAG_STORAGE_ACCOUNT}"
     }

  PROTECTED_SETTINGS

   }
  
*/

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

      lifecycle {
            ignore_changes = [
             tags
            ]
      }
 
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
  lifecycle {
    ignore_changes = [
     tags
    ]
  }
}

resource "azurerm_virtual_machine_extension" "NetworkWatcker" {
   
  name                 = "AzureNetworkWatcherExtension"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  lifecycle {
    ignore_changes = [
     tags
    ]
  }
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
  lifecycle {
      ignore_changes = [
      tags
    ]
  }
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

 lifecycle {
    ignore_changes = [
     tags
    ]
  }

}



resource "azurerm_virtual_machine_extension" "ama" {
   
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = var.MD_VIRTUAL_MACHINE_ID
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = "true"
  automatic_upgrade_enabled  = "true"
  lifecycle {
    ignore_changes = [
     tags
    ]
  }
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
  lifecycle {
    ignore_changes = [
     tags
    ]
  }
}

/*
resource "azurerm_virtual_machine_extension" "domjoin" {
name = "domjoin"
virtual_machine_id = var.MD_VIRTUAL_MACHINE_ID
publisher = "Microsoft.Compute"
type = "JsonADDomainExtension"
type_handler_version = "1.3"
settings = <<SETTINGS
    {
    "Name": "w3cp.windtre.it",
    "User": "${var.MD_USERNAME}",
    "OUPath": "OU=${var.MD_PROJECT_NAME},${var.MD_DOMAIN_LDAP}",
    "Restart": "true",
    "Options": "3"
      
    }
SETTINGS
    protected_settings = <<PROTECTED_SETTINGS
    {
            "Password": "${var.MD_USERPWD}"
    }
PROTECTED_SETTINGS
lifecycle {
    ignore_changes = [
     tags,
     protected_settings
     ]
  }
}
*/

