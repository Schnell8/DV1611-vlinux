#!/usr/bin/env bash

# Get ip and url to json data
sed -E -n 's/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).+((http|https):.+\.[a-z]{2,3})\/.+/\t{\n\t\t"ip": "\1",\n\t\t"url": "\2"\n\t\},/p' ../access-50k.log > ./data/log.json

# Add "[" at start and replace last comma with "]"
sed -E -i -e '1s/^/[\n/' -e '$s/,$/\n]/' ./data/log.json