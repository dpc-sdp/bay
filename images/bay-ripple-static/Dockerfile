FROM uselagoon/node-18-builder:latest as builder

WORKDIR /builder

COPY app/package.json app/package-lock.json /builder/
RUN npm ci

FROM uselagoon/node-18:latest

LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="Provides a ripple static site generator image optimised for the Bay container platform."
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/bay-ripple-static/Dockerfile"

WORKDIR /builder

RUN apk add git redis --no-cache && \
    npm i -g @quantcdn/quant-cli

COPY --from=builder /builder/node_modules /builder/node_modules
COPY app/ /builder/

EXPOSE 3000

# To reduce the number of pods that are in the cluster and to make this more self contained we include
# redis alognside the node deployment.
COPY entrypoints/ /lagoon/entrypoints

CMD ["yarn", "run", "start"]
