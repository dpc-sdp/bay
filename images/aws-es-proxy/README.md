# Container Image - aws-es-proxy

This container provides a secure proxy for requests to an AWS OpenSearch endpoint using the [aws-es-proxy](https://github.com/abutaha/aws-es-proxy) 
tool. It is designed for seamless integration and automated IAM authentication, with robust defaults and runtime 
configuration via environment variables.

## Features

- Secure proxying to AWS OpenSearch services.
- Automatic validation of critical environment variables and AWS credentials.
- Configurable timeouts, port, and proxy flags.
- Flexible runtime configuration for debugging and verbosity.

## Usage

This image is typically intended for use as a proxy in your infrastructure.  
You can use it in your Docker Compose stack with the following snippet:

```yaml
services: 
  aws-es-proxy: 
    image: ghcr.io/dpc-sdp/bay/aws-es-proxy:6.x 
    environment: 
      BAY_OPENSEARCH_ENDPOINT=https://your-opensearch-endpoint.amazonaws.com
      BAY_OPENSEARCH_ROLE=arn:aws:iam::123456789012:role/your-role 
    ports: 
      - "3000:3000"
```


## Environment Variables

| Name                      | Default Value | Description                                                                                   |
|---------------------------|--------------|-----------------------------------------------------------------------------------------------|
| `BAY_OPENSEARCH_ENDPOINT` | _(required)_ | The AWS OpenSearch domain endpoint to proxy requests to.                                       |
| `BAY_OPENSEARCH_ROLE`     | _(required)_ | The AWS IAM role to assume for accessing the OpenSearch domain.                                |
| `BAY_OPENSEARCH_PROXY_PORT`    | `3000`       | The port that the proxy listens on, inside the container.                                      |
| `BAY_OPENSEARCH_PROXY_TIMEOUT` | `60`         | Timeout (in seconds) for incoming connections.                                                 |
| `BAY_OPENSEARCH_PROXY_FLAGS`   | (empty)      | Extra flags passed to aws-es-proxy (e.g., `-debug -verbose`). See [aws-es-proxy docs](https://github.com/abutaha/aws-es-proxy?tab=readme-ov-file#usage-example) for options. |

### Example: Enabling Debug and Verbose Logging

```
BAY_OPENSEARCH_PROXY_FLAGS=-debug -verbose
```

## Ports

- **3000** (default, can be customized with `BAY_OPENSEARCH_PROXY_PORT`) – Proxy HTTP port

## Entrypoint

The container runs an entrypoint script that:

1. Verifies mandatory environment variables and AWS credentials.
2. Launches `aws-es-proxy` with your configuration.

## AWS Credentials

The container expects valid AWS credentials to be supplied via standard mechanisms (environment variables, mounted credentials files, or IAM roles if running in AWS ECS/EKS environments).

For more advanced configuration, refer to the [aws-es-proxy documentation](https://github.com/abutaha/aws-es-proxy).