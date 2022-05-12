#!/bin/bash
set -e

if [[ -z "$INPUT_WORKING_DIRECTORY" ]]; then
  echo "Missing WORKING DIRECTORY in the action"
  exit 1
fi

if [[ -z "$INPUT_CONSOLE_VERSION" ]]; then
  echo "Missing CONSOLE VERSION in the action"
  exit 1
fi

if [[ -z "$SNXD_CLIENT_ID" ]]; then
  echo "Missing CLIENT ID in the action"
  exit 1
fi

if [[ -z "$SNXD_CLIENT_SECRET" ]]; then
  echo "Missing CLIENT SECRET in the action"
  exit 1
fi

if [[ -z "$INPUT_TARGET_PRODUCT" ]]; then
  echo "Missing TARGET PRODUCT in the action"
  exit 1
fi

if [[ -z "$INPUT_TARGET_ENVIRONMENT" ]]; then
  echo "Missing TARGET ENVIRONMENT in the action"
  exit 1
fi
if [[ -z "$INPUT_TARGET_REPOSITORY" ]]; then
  echo "Missing TARGET REPOSITORY in the action"
  exit 1
fi

cd /github/workspace
# Remove the old deploy script directory
if [ -d "solsta_work" ]; then rm -Rf solsta_work; fi
# Download the latest deploy scripts
git clone --branch 3.7 https://gitlab.com/snxd/deploy.git solsta_work
# Generate console credential file from env vars
echo "{\"consoleCredentials\":{\"audience\":\"https://axis.snxd.com/\",\"clientId\":\"$SNXD_CLIENT_ID\",\"clientSecret\":\"$SNXD_CLIENT_SECRET\",\"grant\":\"clientCredentials\"}}"  > solsta_work/client_credentials.json
cd solsta_work
# Install any missing deploy script dependencies
pip install -r requirements.txt
# Download the latest SSN Console Tools if necessary
if [ ! -d "solsta_console" ]; then python direct_get.py --overwrite --version=$INPUT_CONSOLE_VERSION --target_directory=solsta_console --console_credentials=client_credentials.json ; fi
# Run the script that creates a new release and deploys it
python release_deploy.py --debug --console_credentials=client_credentials.json --console_directory=solsta_console --product_name=$INPUT_TARGET_PRODUCT --env_name=$INPUT_TARGET_ENVIRONMENT --repository_name=$INPUT_TARGET_REPOSITORY --source=$INPUT_WORKING_DIRECTORY