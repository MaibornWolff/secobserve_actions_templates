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
echo ESLint
echo - TARGET:             "$TARGET"
echo - REPORT_NAME:        "$REPORT_NAME"
echo - RUN_DIRECTORY:      "$RUN_DIRECTORY"
if [[ -n "$FURTHER_PARAMETERS" ]]; then
  echo - FURTHER_PARAMETERS: "$FURTHER_PARAMETERS"
fi

cd "$RUN_DIRECTORY"
npm install
npx -quiet eslint $FURTHER_PARAMETERS --quiet --ignore-pattern ./node_modules/ --format @microsoft/eslint-formatter-sarif --output-file "$WORKSPACE/$REPORT_NAME" "$TARGET"
cd "$WORKSPACE"

# The source files are referenced with "file://absolute_path", but we want to have relative paths,
# so we remove the "file://" prefix and the current directory.
sed -i "s|file:\/\/$PWD\/||g" "$WORKSPACE/$REPORT_NAME"

if [ "$SO_UPLOAD" == "true" ]; then
  source file_upload_observations.sh
fi

exit 0
