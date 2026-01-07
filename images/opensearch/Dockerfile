FROM uselagoon/opensearch-2:latest

RUN for plugin in \
  analysis-kuromoji \
  ingest-attachment \
  analysis-icu; do \
    /usr/share/opensearch/bin/opensearch-plugin install $plugin; \
  done
