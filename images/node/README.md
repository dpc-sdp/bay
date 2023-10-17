# Container Image - bay-node

Provides a nodejs image optimised for the Bay container platform.

## Usage

Typically this image is designed for use with lagoon using the following `lagoon.type` values:

- `node`
- `node-persistent`

You can also use it in your Docker Compose stack with the following snippet:

```
services:
  app:
    image: singledigital/bay-node:5.x
    volumes:
      - path/to/app:/app
    ports:
      - 3000
```

## Environment Variables

None

## Ports

- 3000 - Application webserver