#!/bin/sh
export PYTHONPATH="$VIRTUAL_ENV/lib/python3.13/site-packages:/usr/local/importer"
python -m importer.file_upload_observations
