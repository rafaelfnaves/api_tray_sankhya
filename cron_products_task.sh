#!/bin/bash

while true; do
    rails db:update_products

    # Sleep for 1 hour (3600 seconds)
    sleep 7200
done