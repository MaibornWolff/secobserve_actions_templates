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
export SO_PARSER_NAME="CycloneDX"

echo ----------------------------------------
echo Grype Image
echo - TARGET:             "$TARGET"
echo - REPORT_NAME:        "$REPORT_NAME"
if [[ -n "$FURTHER_PARAMETERS" ]]; then
  echo - FURTHER_PARAMETERS: "$FURTHER_PARAMETERS"
fi

cd "$WORKSPACE"
docker pull --quiet "$TARGET"
grype docker:"$TARGET" $FURTHER_PARAMETERS --quiet --output cyclonedx-json --file "$REPORT_NAME"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
