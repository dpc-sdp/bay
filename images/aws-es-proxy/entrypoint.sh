#!/usr/bin/env bash
#
# This script acts as a wrapper to securely proxy requests to an OpenSearch endpoint
# using the aws-es-proxy tool. It performs the following steps:
#   1. Validates that required environment variables (BAY_OPENSEARCH_ENDPOINT and BAY_OPENSEARCH_ROLE)
#      are set and not empty.
#   2. Verifies that valid AWS credentials are present. If credentials are invalid or missing, the
#      script exits with an error.
#   3. Starts the aws-es-proxy service.
#
# The following environment variables can be used to configure the behavior of this script:
#   BAY_OPENSEARCH_ENDPOINT:      The AWS opensearch domain endpoint.
#   BAY_OPENSEARCH_ROLE:          The AWS IAM role that should be assumed to access the opensearch
#                                 domain.
#   BAY_OPENSEARCH_PROXY_PORT:    Port that the aws-es-proxy should bind to.
#   BAY_OPENSEARCH_PROXY_TIMEOUT: Timeout for incoming connections.
#   BAY_OPENSEARCH_PROXY_FLAGS:   See [aws-es-proxy docs](https://github.com/abutaha/aws-es-proxy?tab=readme-ov-file#usage-example)
#                                 for supported options here.
#
# If verbose or debug logs are required, set env var BAY_OPENSEARCH_PROXY_FLAGS="-debug -verbose"

set -euo pipefail

# Check if BAY_OPENSEARCH_ENDPOINT is unset or empty
if [ -z "${BAY_OPENSEARCH_ENDPOINT:-}" ]; then
  echo "Error: BAY_OPENSEARCH_ENDPOINT is not set or is empty" >&2
  exit 1
fi

# Check if BAY_OPENSEARCH_ROLE is unset or empty
if [ -z "${BAY_OPENSEARCH_ROLE:-}" ]; then
  echo "Error: BAY_OPENSEARCH_ROLE= is not set or is empty" >&2
  exit 1
fi

# Ensure AWS credentials exist and are valid
AWS_PAGER="" aws sts get-caller-identity || (echo "Error: AWS credentials invalid" && exit 1)

# Rest of your script here
aws-es-proxy "${BAY_OPENSEARCH_PROXY_FLAGS:-}" \
  -listen "0.0.0.0:${BAY_OPENSEARCH_PROXY_PORT:-3000}" \
  -timeout "${BAY_OPENSEARCH_PROXY_TIMEOUT:-60}" \
  -assume "${BAY_OPENSEARCH_ROLE}" \
  -endpoint "${BAY_OPENSEARCH_ENDPOINT}"
