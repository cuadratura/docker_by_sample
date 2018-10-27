#!/bin/bash
while true; do
    echo $(date +%H:%M:%S) >> /opt/index.html
    sleep 10
done