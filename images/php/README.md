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

These images build on the upstream Lagoon PHP images (`uselagoon/php-<minor>-fpm` and `uselagoon/php-<minor>-cli-drupal`). When a PHP security release ships before Lagoon publishes a new release, rebuild the Lagoon images ourselves:

1. Wait for the official `php:<version>-fpm-alpine<x.y>` tag to appear on Docker Hub.
2. Run the `build-lagoon-php` workflow with `php_version` (e.g. `8.3.36`) and `lagoon_ref` (the current Lagoon release tag). It bumps the php base image in `uselagoon/lagoon-images`, smoke tests the result and publishes `ghcr.io/dpc-sdp/bay/lagoon/php-<minor>-{fpm,cli-drupal}:<version>`.
3. In a `build/` branch, set the `LAGOON_BASE_REPO` and `LAGOON_BASE_TAG` defaults in `gh-actions-bake.hcl` to the published repo and version, verify the PR images, then merge.
4. Once Lagoon releases a version containing the fix, revert the defaults to `uselagoon` / `latest`.


- 9000 - PHP FPM port
- 9253 - php-fpm_exporter metrics endpoint
