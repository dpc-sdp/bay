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

| Name | Default Value     | Description                                                                                      |
|------|-------------------|--------------------------------------------------------------------------------------------------|
| `BAY_DISABLE_FUNCTIONS` | (see source code) | A list of PHP functions to disable. Security feature to disable potential attack vectors.        |
| `BAY_UPLOAD_LIMIT` | `100M`            | Payload size supported by PHP. Synchronises the value across several php configuration elements. |
| `BAY_POST_MAX` | `100M`            |                                                                                                  |
| `BAY_SESSION_NAME` | `PHPSESSID`       |                                                                                                  |
| `BAY_SESSION_COOKIE_LIFETIME` | `28800`           |                                                                                                  |
| `BAY_SESSION_STRICT` | `1`               |                                                                                                  |
| `BAY_SESSION_SID_LEN` | `256`             |                                                                                                  |
| `BAY_SESSION_SID_BITS` | `6`               |                                                                                                  |
| `PHP_CLI_MEMORY_LIMIT` | `1024M`           | Default memory_limit for CLI container.                                                          |
| `PHP_FPM_EXPORTER_ENABLED` | `false`           | Toggle for php-fpm metrics exporter.                                                             |

## Emergency PHP security releases

These images build on `uselagoon/php-8.3-fpm:latest` and `uselagoon/php-8.3-cli-drupal:latest`, which only move when Lagoon cuts a release. To ship a PHP security release sooner:

1. Wait for the official `php:<version>-fpm-alpine<x.y>` tag to appear on Docker Hub.
2. Set the `PHP_PATCH_VERSION` repository variable (Settings → Secrets and variables → Actions → Variables) to the new version, e.g. `8.3.36`. Optionally set `LAGOON_IMAGES_REF` to pin a `uselagoon/lagoon-images` tag (defaults to the latest release).
3. Run the `build-deploy-bay-images` workflow on `6.x` (or wait for the next merge or scheduled build).

While the variable is set, `php-cli` and `php-fpm` builds rebuild the Lagoon PHP image chain from source with the php base bumped (see `lagoon-php-patch.hcl`) and push to the usual tags. Nothing else is published. Before pushing, an amd64 build is checked to run the new PHP version and to match the current `6.x` image in everything else.

If the Lagoon release already ships that version or newer, the override switches itself off. Unset the variable once Lagoon has released the fix.


- 9000 - PHP FPM port
- 9253 - php-fpm_exporter metrics endpoint
