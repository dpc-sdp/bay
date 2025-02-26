FROM elasticsearch:8.16.1

ENV ES_PATH=/usr/share/elasticsearch

# Run docker info to check Docker user info
RUN echo "Docker Info - Verifying user and login status" && docker info

RUN $ES_PATH/bin/elasticsearch-plugin install analysis-kuromoji \
    && $ES_PATH/bin/elasticsearch-plugin install analysis-icu
