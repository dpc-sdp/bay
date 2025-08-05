# Container Image - bay-nginx-drupal

Provides a nginx image optimised for the Bay container platform with the following features

- Drupal compatible server block
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
| _None_ | _N/A_ | _All previous ingress protection variables have been removed._ |

## Ports

- 8080 - Application webserver
- 50000 - nginx status available at `/nginx_status`
