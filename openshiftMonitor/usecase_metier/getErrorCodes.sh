#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cat $SCRIPT_PATH/uc_error_codes.sh|grep UCERROR
