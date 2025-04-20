#!/bin/sh
export PYTHONPATH="${PYTHONPATH}:/usr/local/importer"
python -m importer.file_upload_sbom
