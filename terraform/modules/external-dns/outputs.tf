output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.external_dns.name
}

output "release_namespace" {
  description = "Namespace where ExternalDNS is installed"
  value       = helm_release.external_dns.namespace
}

output "release_version" {
  description = "Version of the Helm release"
  value       = helm_release.external_dns.version
}

output "release_status" {
  description = "Status of the Helm release"
  value       = helm_release.external_dns.status
}

output "chart_version" {
  description = "Chart version of ExternalDNS"
  value       = helm_release.external_dns.chart
}

output "domain_name" {
  description = "Domain name being managed"
  value       = var.domain_name
}

output "zone_type" {
  description = "Type of Route53 zones being managed"
  value       = var.zone_type
}