# Container Image - bay-mailhog

Provides a mailhog image for local development.

## Usage

Typically this image is designed for use with lagoon using the following `lagoon.type` values:

- `none`

You can also use it in your Docker Compose stack with the following snippet:

```
services:
  mailhog:
    image: ghcr.io/dpc-sdp/bay/mailhog:5.x
    ports:
      - 1025
      - 8025
```

## Environment Variables

None

## Ports

- 1025 - SMTP endpoint
- 8025 - Web UI
