output "frontend_url" {
  description = "Public URL of the frontend container app"
  value       = azurerm_container_app.frontend.ingress[0].fqdn
}

output "backend_internal_url" {
  description = "Internal FQDN of the backend container app"
  value       = azurerm_container_app.backend.ingress[0].fqdn
}
