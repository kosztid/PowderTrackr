#!/bin/bash

# Path to the sourcery configuration file
SOURCERY_CONFIG_FILE="./sourcery-mock.yml"

# Run Sourcery with the specified configuration
sourcery --config $SOURCERY_CONFIG_FILE
