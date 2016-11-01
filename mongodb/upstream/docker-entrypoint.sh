#!/bin/bash

if [ "$ROLE" = "master"  ]; then 
    exec /usr/bin/mongod --master
else
    exec /usr/bin/mongod --slave --source server1:27017
fi
