# Container Image - bay-nginx

Provides a nginx image optimised for the Bay container platform with the following features

- Drupal compatible server block
- Ingress protection with pre-shared keys
- Optimised health checks for section.io

## Environment Variables

| Name | Default Value | Description |
|------|---------------|-------------|
| `BAY_INGRESS_ENABLED` | `false` | Global toggle for ingress protection. Set to "true" to enable. |
| `BAY_INGRESS_HEADER` | `<none>` | Name of header with PSK. |
| `BAY_INGRESS_PSK` | `<none>` | Pre-shared key value |
