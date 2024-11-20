#!/bin/sh
export PYTHONPATH="${PYTHONPATH}:/usr/local/importer"
python -m importer.check_security_gate
