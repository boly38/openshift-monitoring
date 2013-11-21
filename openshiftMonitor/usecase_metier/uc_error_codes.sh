#!/bin/bash
# note that exit code should be between 0-255
UCERROR_RHC_CREATE_APP=100 # create an application with rhc
UCERROR_CURL=101           # http get application welcome page
UCERROR_RHC_SSH=102        # rhc ssh to the application
UCERROR_RHC_TAIL=103       # rhc tail application logs
UCERROR_COMMIT_PUSH=104    # commit and push a new file
UCERROR_CURL_PUSH=105      # http get application pushed file
UCERROR_RHC_DELETE_APP=110 # rhc delete application
## others values
# UCERROR 127 : script bash not found, please check cron configuration
# UCERROR ... : business error : please check (...)/usecase_metier/last_log/usecase.log
