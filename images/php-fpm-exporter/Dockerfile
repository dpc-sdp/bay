FROM golang:latest as builder
RUN git clone https://github.com/hipages/php-fpm_exporter.git /workspace
WORKDIR /workspace
RUN make deps
RUN TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}; \
    GOOS=${TARGETPLATFORM%%/*} GOARCH=${TARGETPLATFORM#*/} go build -o php-fpm-exporter -ldflags='-extldflags "-static"' .

FROM gcr.io/distroless/static:nonroot
LABEL org.opencontainers.image.authors="Single Digital Presence"
LABEL org.opencontainers.image.description="Utility to export php-fpm data as prometheus metrics"
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay"

WORKDIR /
EXPOSE 9253
COPY --from=builder /workspace/php-fpm-exporter .
USER nonroot:nonroot
ENTRYPOINT ["/php-fpm-exporter"]
CMD ["server"]