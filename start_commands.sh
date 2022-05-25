#!/bin/bash

# Just to let the user know where the scripts are if they run container without providing script inputs:
echo "The followings scripts are available to run inside this container ($(pwd)/bin):";
echo "$(ls ./bin)";