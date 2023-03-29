#!/bin/sh
set -e

export TRIVY_NO_PROGRESS=true

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

cd "$RUN_DIRECTORY"
trivy filesystem $FURTHER_PARAMETERS --quiet --exit-code 0 --format cyclonedx --scanners vuln --output "$WORKSPACE/$REPORT_NAME" "$TARGET"
cd "$WORKSPACE"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
