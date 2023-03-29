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

echo ----------------------------------------
echo Bandit
echo - TARGET:             "$TARGET"
echo - REPORT_NAME:        "$REPORT_NAME"
echo - RUN_DIRECTORY:      "$RUN_DIRECTORY"
if [[ -n "$FURTHER_PARAMETERS" ]]; then
  echo - FURTHER_PARAMETERS: "$FURTHER_PARAMETERS"
fi

cd "$RUN_DIRECTORY"
bandit $FURTHER_PARAMETERS --quiet --format sarif --output "$WORKSPACE/$REPORT_NAME" --exit-zero --recursive "$TARGET"
cd "$WORKSPACE"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
