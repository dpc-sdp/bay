#!/usr/bin/env bash
#
# This script acts as a wrapper to securely proxy requests to an OpenSearch endpoint
# using the aws-es-proxy tool. It performs the following steps:
#   1. Validates that required environment variables (BAY_OPENSEARCH_ENDPOINT and BAY_OPENSEARCH_ROLE)
#      are set and not empty.
#   2. If BAY_OPENSEARCH_ENDPOINT is a custom domain, rewrites to the AWS
#      endpoint to ensure sigv4 request signing works.
#   3. Verifies that valid AWS credentials are present. If credentials are invalid or missing, the
#      script exits with an error.
#   4. Starts the aws-es-proxy service.
#
# The following environment variables can be used to configure the behavior of this script:
#   BAY_OPENSEARCH_ENDPOINT:      The AWS opensearch domain endpoint.
#   BAY_OPENSEARCH_ROLE:          The AWS IAM role that should be assumed to access the opensearch
#                                 domain.
#   BAY_OPENSEARCH_PROXY_PORT:    Port that the aws-es-proxy should bind to.
#   BAY_OPENSEARCH_PROXY_TIMEOUT: Timeout for incoming connections.
#   BAY_OPENSEARCH_PROXY_VERBOSE: "true" to enable proxy verbose logs
#   BAY_OPENSEARCH_PROXY_DEBUG:   "true" to enable proxy debug logs

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

# Configure debug and verbose flags
AWS_ES_PROXY_DEBUG_FLAG=""
AWS_ES_PROXY_VERBOSE_FLAG=""

if [ "${BAY_OPENSEARCH_PROXY_DEBUG:-false}" = "true" ]; then
  AWS_ES_PROXY_DEBUG_FLAG="-debug"
fi

if [ "${BAY_OPENSEARCH_PROXY_VERBOSE:-false}" = "true" ]; then
  AWS_ES_PROXY_VERBOSE_FLAG="-verbose"
fi

if ! [[ "$BAY_OPENSEARCH_ENDPOINT" == *amazonaws.com* ]]; then
  echo "endpoint appears to be a custom domain - adjusting to aws endpoint"
  BAY_OPENSEARCH_ENDPOINT=$(uri-rewriter hostname-cname "${BAY_OPENSEARCH_ENDPOINT}")
  echo " - updated endpoint to ${BAY_OPENSEARCH_ENDPOINT}"
fi

# Ensure AWS credentials exist and are valid
AWS_PAGER="" aws sts get-caller-identity || (echo "Error: AWS credentials invalid" && exit 1)

# Rest of your script here
aws-es-proxy \
  ${AWS_ES_PROXY_DEBUG_FLAG} \
  ${AWS_ES_PROXY_VERBOSE_FLAG} \
  -listen "0.0.0.0:${BAY_OPENSEARCH_PROXY_PORT:-9200}" \
  -timeout "${BAY_OPENSEARCH_PROXY_TIMEOUT:-60}" \
  -assume "${BAY_OPENSEARCH_ROLE}" \
  -endpoint "${BAY_OPENSEARCH_ENDPOINT}"
