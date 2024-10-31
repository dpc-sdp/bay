# # Container Image - php-fpm-metrics

Provides a [php-fpm-metrics](https://github.com/hipages/php-fpm_exporter/) image.

## Usage

Container needs to be able to access the php-fpm status endpoint, so should be deployed as a sidecar alongside a php-fpm container.

## Environment Variables

None

## Ports

- `9253` - metrics server
