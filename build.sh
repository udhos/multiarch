#!/bin/bash

#docker build -t udhos/web-scratch:latest .

docker buildx build \
    --push \
    --tag udhos/web-scratch:latest \
    --tag udhos/web-scratch:0.8.0 \
    --platform linux/amd64,linux/arm64 .

#docker buildx imagetools inspect udhos/web-scratch:latest
