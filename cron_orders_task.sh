#!/bin/bash

while true; do
    rails tray:get_orders

    # Sleep for 1 hour (3600 seconds)
    sleep 600
done