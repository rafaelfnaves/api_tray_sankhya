#!/bin/bash

while true; do
    # Add the command to run your script here
    # For example, to run a Ruby script named "script.rb":
    rails db:update_products

    # Sleep for 1 hour (3600 seconds)
    sleep 28800
done