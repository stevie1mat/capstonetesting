variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "TradeMinutes-RG"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
  default     = "trademinutesacr"
}

variable "env_name" {
  description = "Container App environment name"
  type        = string
  default     = "trademinutes-env"
}

variable "frontend_name" {
  description = "Frontend container app name"
  type        = string
  default     = "trademinutes-frontend"
}

variable "backend_name" {
  description = "Backend container app name"
  type        = string
  default     = "trademinutes-users-api"
}
