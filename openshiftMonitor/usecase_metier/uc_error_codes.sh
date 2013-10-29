#!/bin/bash
UCERROR_RHC_CREATE_APP=1000 # create an application with rhc
UCERROR_CURL=1010           # http get application welcome page
UCERROR_RHC_SSH=1020        # rhc ssh to the application
UCERROR_RHC_TAIL=1030       # rhc tail application logs
UCERROR_COMMIT_PUSH=1040    # commit and push a new file
UCERROR_CURL_PUSH=1050      # http get application pushed file
UCERROR_RHC_DELETE_APP=1100 # rhc delete application
## other UCERROR
# UCERROR 127 : script bash not found, please check cron configuration
# UCERROR 232 : ruby script not found, please check rvm configuration
