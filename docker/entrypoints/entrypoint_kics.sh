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

if [[ -z "${OUTPUT_PATH}" ]]; then
  OUTPUT_PATH=.
fi

export SO_FILE_NAME="${OUTPUT_PATH}"/"${REPORT_NAME}"
export SO_PARSER_NAME="Sarif"

echo ----------------------------------------
echo KICS
echo - TARGET:             "$TARGET"
echo - REPORT_NAME:        "$REPORT_NAME"
echo - OUTPUT_PATH:        "$OUTPUT_PATH"
echo - RUN_DIRECTORY:      "$RUN_DIRECTORY"
if [[ -n "$FURTHER_PARAMETERS" ]]; then
  echo - FURTHER_PARAMETERS: "$FURTHER_PARAMETERS"
fi

cd "$RUN_DIRECTORY"
kics scan $FURTHER_PARAMETERS --silent --no-progress --ignore-on-exit results --path "$TARGET" --report-formats sarif --output-path "$OUTPUT_PATH" --output-name "$REPORT_NAME"
cd "$WORKSPACE"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
