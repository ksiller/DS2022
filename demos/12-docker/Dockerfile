FROM ubuntu:latest

COPY script.sh script.sh

RUN apt-get update && \
    apt-get install -y \
    awscli \
    curl \
    jq

CMD ["sh", "script.sh"]
