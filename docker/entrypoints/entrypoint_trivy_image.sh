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

echo ----------------------------------------
echo Trivy Image
echo - TARGET:             "$TARGET"
echo - REPORT_NAME:        "$REPORT_NAME"
if [[ -n "$FURTHER_PARAMETERS" ]]; then
  echo - FURTHER_PARAMETERS: "$FURTHER_PARAMETERS"
fi

export SCANNERS="vuln"
if [[ -n "$LICENSES" ]]; then
  echo - LICENSES          : "$LICENSES"
  if [ "$LICENSES" == "true" ]; then
    export SCANNERS="vuln,license"
  fi
fi

cd "$WORKSPACE"
trivy image $FURTHER_PARAMETERS --quiet --exit-code 0 --format cyclonedx --scanners $SCANNERS --output "$REPORT_NAME" "$TARGET"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
