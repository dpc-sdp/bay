FROM uselagoon/node-18:latest

LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="Provides a ripple static site generator image optimised for the Bay container platform."
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/bay-ripple-static/Dockerfile"

WORKDIR /builder

RUN apk add git --no-cache && \
    npm i -g @quantcdn/quant-cli