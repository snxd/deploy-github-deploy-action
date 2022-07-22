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

if [[ -z "$INPUT_SCRIPTS_VERSION" ]]; then
  echo "Missing SCRIPTS VERSION in the action"
  exit 1
fi

if [[ -z "$INPUT_SOLSTA_CLIENT_ID" ]]; then
  echo "Missing SOLSTA CLIENT ID in the action"
  exit 1
fi

if [[ -z "$INPUT_SOLSTA_CLIENT_SECRET" ]]; then
  echo "Missing SOLSTA CLIENT SECRET in the action"
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
mkdir solsta_work
# Download the latest deploy scripts
cd solsta_work
wget https://releases.snxd.com/deploy-scripts-$INPUT_SCRIPTS_VERSION.zip
unzip deploy-scripts-$INPUT_SCRIPTS_VERSION.zip
# Generate console credential file from env vars
echo "{\"consoleCredentials\":{\"audience\":\"https://axis.snxd.com/\",\"clientId\":\"$INPUT_SOLSTA_CLIENT_ID\",\"clientSecret\":\"$INPUT_SOLSTA_CLIENT_SECRET\",\"grant\":\"clientCredentials\"}}"  > client_credentials.json
# Install any missing deploy script dependencies
pip install -r requirements.txt
# Download the latest SSN Console Tools if necessary
if [ ! -d "solsta_console" ]; then python3 direct_get.py --overwrite --version="$INPUT_CONSOLE_VERSION" --target_directory=./solsta_console/ --console_credentials=client_credentials.json ; fi
# Run the script that creates a new release and deploys it
cd ..
python3 solsta_work/release_deploy.py --debug --console_credentials=solsta_work/client_credentials.json --console_directory=./solsta_work/solsta_console/console/ --product_name="$INPUT_TARGET_PRODUCT" --env_name="$INPUT_TARGET_ENVIRONMENT" --repository_name="$INPUT_TARGET_REPOSITORY" --source="$INPUT_WORKING_DIRECTORY"
