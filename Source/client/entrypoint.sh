#!/bin/bash

# switch directories
cd build/web/

# Start the server
echo 'Server starting on port' $PORT '...'
python -m http.server $PORT