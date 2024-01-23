#!/bin/bash

while true; do
    rails snk:stock_price

    # Sleep for 1 hour (3600 seconds)
    sleep 900
done