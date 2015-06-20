#!/bin/bash
set -e


docker build \
    -t piotrminkina/squid-proxy \
    .
