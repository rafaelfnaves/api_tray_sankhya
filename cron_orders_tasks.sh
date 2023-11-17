#!/bin/bash

while true; do
    # Add the command to run your script here
    # For example, to run a Ruby script named "script.rb":
    rails tray:get_orders

    # Sleep for 1 hour (3600 seconds)
    sleep 300
done