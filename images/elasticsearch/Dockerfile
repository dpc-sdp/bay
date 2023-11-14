FROM elasticsearch:8.10.2

ENV ES_PATH=/usr/share/elasticsearch

RUN $ES_PATH/bin/elasticsearch-plugin install analysis-kuromoji \
    && $ES_PATH/bin/elasticsearch-plugin install analysis-icu
