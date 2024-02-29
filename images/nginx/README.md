# Container Image - bay-nginx-drupal

Provides a nginx image optimised for the Bay container platform with the following features

- Drupal compatible server block
- Ingress protection with pre-shared keys
- Optimised health checks for section.io

## Usage

Typically this image is designed for use with lagoon using the following `lagoon.type` values:

- `nginx-php`
- `nginx-php-persistent`

You can also use it in your Docker Compose stack with the following snippet:

```
services:
  nginx:
    image: ghcr.io/dpc-sdp/bay/nginx:6.x
    volumes: 
      - path/to/app:/app
    ports:
      - 8080
```

## Environment Variables

| Name | Default Value | Description |
|------|---------------|-------------|
| `BAY_INGRESS_ENABLED` | `false` | Global toggle for ingress protection. Set to "true" to enable. |
| `BAY_INGRESS_HEADER` | `<none>` | Name of header with PSK. |
| `BAY_INGRESS_PSK` | `<none>` | Pre-shared key value |

## Ports

- 8080 - Application webserver
- 50000 - nginx status available at `/nginx_status`
