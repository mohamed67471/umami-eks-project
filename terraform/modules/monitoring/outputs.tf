output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = "https://grafana.${var.domain_name}"
}

output "prometheus_url" {
  description = "Prometheus URL (internal)"
  value       = "http://prometheus-kube-prometheus-prometheus.${var.namespace}.svc.cluster.local:9090"
}