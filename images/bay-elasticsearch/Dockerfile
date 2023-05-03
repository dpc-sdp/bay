FROM elasticsearch:8.5.3

LABEL org.opencontainers.image.authors="Digital Victoria"
LABEL org.opencontainers.image.description="ElasticSearch image for Bay container platform"
LABEL org.opencontainers.image.source="https://github.com/dpc-sdp/bay/blob/5.x/images/bay-elasticsearch/Dockerfile"

ENV ES_PATH=/usr/share/elasticsearch

RUN $ES_PATH/bin/elasticsearch-plugin install --batch ingest-attachment \
    && $ES_PATH/bin/elasticsearch-plugin install analysis-kuromoji \
    && $ES_PATH/bin/elasticsearch-plugin install analysis-icu
