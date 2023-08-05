#!/bin/bash
docker build -t my-nginx-proxy .
docker run -d -p 80:80 --name nginx-proxy my-nginx-proxy
