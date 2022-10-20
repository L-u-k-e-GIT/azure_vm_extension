variable "MD_VIRTUAL_MACHINE_ID" { 
 description = "Virtual Machine Id"
 type = string
 default = ""
}

 
variable "MD_VIRTUAL_MACHINE_NAME" { 
 description = "Virtual Machine Id"
 type = string
 default = ""
}

variable "MD_DIAG_STORAGE_ACCOUNT" { 
 description = "Nome dello storage accound diagnostics"
 type = string
 default = ""
 
}


variable "MD_ST_DIAG_KEY" { 
 description = "Storage Account Key"
 type = string
 default = ""
 
}


variable "MD_WORKSPACEID" {
  type        = string
  description = "Centralized Workspace Log Analytics"
  default     = ""
}

variable "MD_WORKSPACEID_KEY" {
  type        = string
  description = "Centralized Workspace Log Analytics"
  default     = ""
}

variable "MD_DCR_ID" {
  type        = string
  description = "Centralized Data collection rule ID"
  default     = ""
}


variable "MD_USERNAME" { 
 description = "UserName for AD Join"
 type = string
 default = ""
 sensitive   = true
}

variable "MD_USERPWD" { 
 description = "Password for AD Join"
 type = string
 default = ""
 sensitive   = true
}

variable "MD_PROJECT_NAME" { 
 description = "NOme Progetto"
 type = string
 default = ""
 
}

variable "MD_DOMAIN_LDAP" { 
 description = "Percorso LDAP"
 type = string
 default = ""
 
}


variable "MD_ALL_TAGS" { 
 
 default = ""
 
}

