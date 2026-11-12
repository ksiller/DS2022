FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        fortune-mod fortunes-min && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/games:${PATH}

ENTRYPOINT ["fortune"]
