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
export SO_PARSER_NAME="CryptoLyzer"

echo ----------------------------------------
echo CryptoLyzer
echo - TARGET:             "$TARGET"
echo - REPORT_NAME:        "$REPORT_NAME"
echo - RUN_DIRECTORY:      "$RUN_DIRECTORY"
if [[ -n "$FURTHER_PARAMETERS" ]]; then
  echo - FURTHER_PARAMETERS: "$FURTHER_PARAMETERS"
fi

source /.venv/bin/activate
cd "$WORKSPACE"
cryptolyze $FURTHER_PARAMETERS --output-format json tls all "$TARGET" >"$REPORT_NAME"
deactivate

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
