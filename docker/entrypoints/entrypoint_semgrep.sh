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
echo Semgrep
echo - TARGET:             "$TARGET"
echo - REPORT_NAME:        "$REPORT_NAME"
echo - CONFIGURATION:      "$CONFIGURATION"
echo - RUN_DIRECTORY:      "$RUN_DIRECTORY"
if [[ -n "$FURTHER_PARAMETERS" ]]; then
  echo - FURTHER_PARAMETERS: "$FURTHER_PARAMETERS"
fi

cd "$RUN_DIRECTORY"
semgrep scan $FURTHER_PARAMETERS --config $CONFIGURATION --quiet --metrics off --no-error --output "$WORKSPACE/$REPORT_NAME" --sarif "$TARGET"
cd "$WORKSPACE"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
