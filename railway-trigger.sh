#!/usr/bin/env bash

set -euo pipefail

RAILWAY_BINARY="/tmp"
RAILWAY_VERSION="1.8.4"

# Install the Railway CLI
VERSION="$RAILWAY_VERSION" INSTALL_DIR="$RAILWAY_BINARY" sh -c "$(curl -sSL https://raw.githubusercontent.com/railwayapp/cli/master/install.sh)"
$RAILWAY_BINARY version

affected_projects=$(pnpm nx print-affected --base="$BASE_COMMIT" --head=HEAD --select=projects --type='app')
for project in ${affected_projects//,/ }
do
    echo "Processing: '$project'..."
    # convert hyphens to underscores
    parameterized_name=$(echo $project | tr '-' '_')
    branch_name="$(git branch --show-current)"
    # this is the key by which the required token is present in the secrets file
    env_variable="NX_API_PROXY_TOKEN"
    # convert the whole thing to upper case
    echo "env_variable: '$env_variable'..."
    final_env_variable=$(echo "$env_variable" | awk '{print toupper($0)}')
    # get the actual value of the token from the secrets file
    railway_token="3d39e126-cc4c-4abc-bdeb-94e186fb9492"
    # trigger the deploy
    RAILWAY_TOKEN="$railway_token" $RAILWAY_BINARY up --detach --verbose
done