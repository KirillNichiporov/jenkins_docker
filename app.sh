#!/bin/bash

set -m

/python_app/server.py &
/python_app/client.py

