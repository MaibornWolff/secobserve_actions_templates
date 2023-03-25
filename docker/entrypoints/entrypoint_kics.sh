#!/bin/sh
set -e

if [[ -z "${GITHUB_WORKSPACE}" ]]; then
  if [[ -z "${CI_PROJECT_DIR}" ]]; then
    WORKSPACE=.
  else
    WORKSPACE="${CI_PROJECT_DIR}"
  fi
else
  WORKSPACE="${GITHUB_WORKSPACE}"
fi

export SO_FILE_NAME="${REPORT_NAME}"
export SO_PARSER_NAME="Sarif"

cd "$RUN_DIRECTORY"
kics scan $FURTHER_PARAMETERS --no-progress --ignore-on-exit results --queries-path /usr/local/kics/queries --path "$TARGET" --report-formats sarif --output-path . --output-name "$WORKSPACE/$REPORT_NAME"
cd "$WORKSPACE"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
