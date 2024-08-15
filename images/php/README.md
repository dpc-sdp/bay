# Container Image - bay-php

Provides a php image optimised for the Bay container platform with the following features

- Automatic Drupal configuration from environment variables.
- Automatic PHP configuration from environment variables.
- Redis service configuration.
- Optimisation for Lagoon.

## Usage

Typically this image is designed for use with lagoon using the following `lagoon.type` values:

- `nginx-php`
- `nginx-php-persistent`

You can also use it in your Docker Compose stack with the following snippet:

```
services:
  nginx:
    image: ghcr.io/dpc-sdp/bay/php-fpm:6.x
    volumes:
      - path/to/app:/app
    ports:
      - 9000
```

## Environment Variables

| Name | Default Value | Description |
|------|---------------|-------------|
| `BAY_DISABLE_FUNCTIONS` | (see source code) | A list of PHP functions to disable. Security feature to disable potential attack vectors. |
| `BAY_UPLOAD_LIMIT` | `100M` | Payload size supported by PHP. Synchronises the value across several php configuration elements. |
| `BAY_POST_MAX` | `100M` |  |
| `BAY_SESSION_NAME` | `PHPSESSID` |   |
| `BAY_SESSION_COOKIE_LIFETIME` | `28800` |   |
| `BAY_SESSION_STRICT` | `1` |   |
| `BAY_SESSION_SID_LEN` | `256` |   |
| `BAY_SESSION_SID_BITS` | `6` |   |

## Ports

- 9000 - PHP FPM port
