#!/bin/bash
set -e

if [[ -z "$INPUT_ACTION" ]]; then
  echo "Missing action"
  exit 1
fi

if [[ -z "$INPUT_WORKING_DIRECTORY" ]]; then
  echo "Missing WORKING DIRECTORY in the action"
  exit 1
fi

if [[ -z "$INPUT_CONSOLE_VERSION" ]]; then
  echo "Missing CONSOLE VERSION in the action"
  exit 1
fi

if [[ -z "$INPUT_CONSOLE_PATH" ]]; then
  echo "Missing CONSOLE PATH in the action"
  exit 1
fi

if [[ -z "$INPUT_CLIENT_ID" ]]; then
  echo "Missing CLIENT ID in the action"
  exit 1
fi

if [[ -z "$INPUT_CLIENT_SECRET" ]]; then
  echo "Missing CLIENT SECRET in the action"
  exit 1
fi

if [[ -z "$INPUT_TARGET_PRODUCT" ]]; then
  echo "Missing TARGET PRODUCT in the action"
  exit 1
fi

if [ "$INPUT_ACTION" == "deploy" ]
    echo "Solsta Action: Deploy"
    if [[ -z "$INPUT_TARGET_ENVIRONMENT" ]]; then
      echo "Missing TARGET ENVIRONMENT in the action"
      exit 1
    fi
    if [[ -z "$INPUT_TARGET_REPOSITORY" ]]; then
      echo "Missing TARGET REPOSITORY in the action"
      exit 1
    fi
elif [ "$INPUT_ACTION" == "promote" ]
    echo "Solsta Action: Promote"
    if [[ -z "$INPUT_SOURCE_PRODUCT" ]]; then
      echo "Missing SOURCE PRODUCT in the action"
      exit 1
    fi
    if [[ -z "$INPUT_SOURCE_ENVIRONMENT" ]]; then
      echo "Missing SOURCE ENVIRONMENT in the action"
      exit 1
    fi
    if [[ -z "$INPUT_SOURCE_REPOSITORY" ]]; then
      echo "Missing SOURCE REPOSITORY in the action"
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
elif [ "$INPUT_ACTION" == "cleanup" ]
    echo "Solsta Action: Cleanup"
else
  echo "Invalid action: ${INPUT_ACTION}"
  exit 1
fi

cd /github/workspace
# Remove the old deploy script directory
if [ -d "solsta_work" ]; then rm -Rf solsta_work; fi
# Download the latest deploy scripts
git clone --branch 3.7 https://gitlab.com/snxd/deploy.git solsta_work
# Generate console credential file from env vars
echo "{\"consoleCredentials\":{\"audience\":\"https://axis.snxd.com/\",\"clientId\":\"$INPUT_CLIENT_ID\",\"clientSecret\":\"$INPUT_CLIENT_SECRET\",\"grant\":\"clientCredentials\"}}"  > solsta_work/client_credentials.json
cd solsta_work
# Create the python venv in the deploy directory
if [ ! -f "venv" ]; then python3 -m venv venv ; fi
# Activate the new python environment
source venv/bin/activate
# Install any missing deploy script dependencies
pip install -r requirements.txt
# Download the latest SSN Console Tools if necessary
if [ ! -d "$INPUT_CONSOLE_PATH$INPUT_CONSOLE_VERSION/console" ]; then python direct_get.py --overwrite --version=$INPUT_CONSOLE_VERSION --target_directory=$INPUT_CONSOLE_PATH$INPUT_CONSOLE_VERSION --console_credentials=client_credentials.json ; fi
# Run the script that creates a new release and deploys it
if [ "$INPUT_ACTION" == "deploy" ]
    python release_deploy.py --debug --console_credentials=client_credentials.json --console_directory=$INPUT_CONSOLE_PATH$INPUT_CONSOLE_VERSION/console --product_name=$INPUT_TARGET_PRODUCT --env_name=$INPUT_TARGET_ENVIRONMENT --repository_name=$INPUT_TARGET_REPOSITORY --source=$INPUT_WORKING_DIRECTORY
elif [ "$INPUT_ACTION" == "promote" ]
    python manifest_promote.py --debug --console_credentials=client_credentials.json --console_directory=$INPUT_CONSOLE_PATH$INPUT_CONSOLE_VERSION/console --product_name=$INPUT_TARGET_PRODUCT --env_name=$INPUT_TARGET_ENVIRONMENT --repository_name=$INPUT_TARGET_REPOSITORY --process_default=API --source_product_name=$INPUT_SOURCE_PRODUCT --source_env_name=$INPUT_SOURCE_ENVIRONMENT --source_repository_name=$INPUT_SOURCE_REPOSITORY 
elif [ "$INPUT_ACTION" == "cleanup" ]
    echo "Solsta Action: Cleanup"
    python cleanup.py --debug --console_credentials=client_credentials.json --console_directory=$INPUT_CONSOLE_PATH$INPUT_CONSOLE_VERSION/console --product_name=$INPUT_TARGET_PRODUCT 
fi
