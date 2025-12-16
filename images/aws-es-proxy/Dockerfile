FROM golang:alpine AS build

RUN apk add --no-cache git
RUN git clone https://github.com/abutaha/aws-es-proxy.git /go/src/github.com/abutaha/aws-es-proxy
WORKDIR /go/src/github.com/abutaha/aws-es-proxy

RUN go get -u && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o aws-es-proxy

FROM alpine:latest
ARG URI_REWRITER_VERSION=v0.0.1-alpha1

RUN apk --no-cache add ca-certificates
WORKDIR /home/
COPY --from=build /go/src/github.com/abutaha/aws-es-proxy/aws-es-proxy /usr/local/bin/
COPY entrypoint.sh /entrypoint.sh
RUN apk add --no-cache bash aws-cli

RUN wget "https://github.com/dpc-sdp/uri-rewriter/releases/download/${URI_REWRITER_VERSION}/uri-rewriter_$(echo ${TARGETPLATFORM:-linux/amd64} | tr '/' '_').tar.gz" -O /tmp/uri-rewriter.tgz && \
    cd /bin && \
    tar -vxxzf /tmp/uri-rewriter.tgz

ENV BAY_OPENSEARCH_ENDPOINT=
ENV BAY_OPENSEARCH_ROLE=
ENV BAY_OPENSEARCH_PROXY_TIMEOUT=60
ENV BAY_OPENSEARCH_PROXY_VERBOSE=
ENV BAY_OPENSEARCH_PROXY_DEBUG=
ENV BAY_OPENSEARCH_PROXY_PORT=9200
EXPOSE 9200

ENTRYPOINT ["/entrypoint.sh"]
