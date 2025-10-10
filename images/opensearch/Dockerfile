FROM uselagoon/opensearch-2:latest

RUN for plugin in \
  analysis-kuromoji \
  analysis-icu; do \
    /usr/share/opensearch/bin/opensearch-plugin install $plugin; \
  done

COPY opensearch.yml /usr/share/opensearch/config