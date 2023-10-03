# Container Image - bay-clamav

Provides a clamav image for local development.

## Usage

Typically this image is designed for use with lagoon using the following `lagoon.type` values:

- `none`

You can also use it in your Docker Compose stack with the following snippet:

```
services:
  clamav:
    image: singledigital/bay-clamav:5.x
    ports:
      - 3310
```

## Environment Variables

None

## Ports

- 3310 - Scanning endpoint
