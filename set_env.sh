#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Read the environment argument
ENVIRON=$1

# Validate the environment argument
if [[ "$ENVIRON" != "development" && "$ENVIRON" != "test" ]]; then
    echo -n -e "${RED}ArgumentError: Please use 'test' or 'development' instead of '$ENVIRON'.${NC}"
    exit 1
fi

# Log the start of the setup process
echo -n -e "${GREEN}Starting setup for the '$ENVIRON' environment...${NC}"

# Determine the appropriate .env file
if [[ "$ENVIRON" == "test" ]]; then
    ENV_FILE=".env.test"
else
    ENV_FILE=".env"
fi

# Log finding the environment file
echo -e "${GREEN}Searching for the $ENV_FILE file...${NC}"

# Check if the environment file exists and source it
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
    echo -e "${RED}Error: File $ENV_FILE does not exist in this directory.${NC}"
    exit 1
fi

# Log successful setting of the environment file
echo -e "${GREEN}Successfully set the environment from $ENV_FILE.${NC}"

# Check if the Rails binary exists and set the database environment
if [[ -f 'bin/rails' ]]; then
    bin/rails db:environment:set RAILS_ENV=$ENVIRON
    # Log successful setting of the Rails environment
    echo -e "${GREEN}Rails environment set to '$ENVIRON'.${NC}"

    # Perform database migrations
    bin/rails db:migrate RAILS_ENV=$ENVIRON
    # Log successful completion of migrations
    echo -e "${GREEN}Database migrations completed successfully.${NC}"
else
    echo -e "${RED}Error: 'bin/rails' file does not exist in this directory.${NC}"
    exit 1
fi

