#!/bin/bash
OPENSHIFT_DOMAIN=myopenshift.fr
USER_DOMAIN=monitor
#
# configuration
#
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SAMPLE_APPNAME=samplephp
SAMPLE_CARTRIDGE=php-5.3
SAMPLE_APP_URL=http://samplephp-$USER_DOMAIN.$OPENSHIFT_DOMAIN

#proxies
http_proxy=
https_proxy=

WORK_DIR=$SCRIPT_PATH/work
WORK_REPO_DIR=$WORK_DIR/$SAMPLE_APPNAME

# commandes
CREATE_APP="rhc create-app $SAMPLE_APPNAME $SAMPLE_CARTRIDGE --repo $WORK_REPO_DIR"
DELETE_APP="rhc delete-app --confirm $SAMPLE_APPNAME"

#colors
GREEN='\e[0;32m'
RED='\e[1;31m'
ENDCOLOR='\e[0m'

if [ "$1" == "--no-color" ]; then
 GREEN=""
 RED=""
 ENDCOLOR=""
fi

# handle uc error codes
. $SCRIPT_PATH/uc_error_codes.sh
#
# function exit_trap {
#   local rc=$?
#  if [ $rc -ne 0 ]; then echo "$STEP exited with code [$rc]"; fi
# }
# trap exit_trap EXIT
# set -e
#
#
function errorMsg {
	echo -e "${RED}ERROR [$*] Failed${ENDCOLOR}"
}

function successMsg {
	echo -e "Test ${GREEN}PASSED${ENDCOLOR}"
}

function createApp {
	STEP=$CREATE_APP
	echo o $STEP
	$CREATE_APP
	if [ $? -ne 0 ]; then echo $(errorMsg $STEP) ; `exit $UCERROR_RHC_CREATE_APP`; fi
}

function curlApp {
	STEP="curl $SAMPLE_APP_URL"
	# app index page should contains Welcome to OpenShift 2 times
	echo o $STEP
	CURL_CHECK=`curl $SAMPLE_APP_URL 2>/dev/null |grep "Welcome to OpenShift"|wc -l`
	if [ $CURL_CHECK -ne 2 ]; then echo $(errorMsg $STEP) ; `exit $UCERROR_CURL`; fi
}

function sshApp {
	STEP="rhc ssh $SAMPLE_APPNAME env"
	echo o $STEP
	# app env should include OPENSHIFT_APP_NAME
	SSH_CHECK=`rhc ssh $SAMPLE_APPNAME env|grep OPENSHIFT_APP_NAME|wc -l`
	if [ $SSH_CHECK -ne 1 ];  then echo $(errorMsg $STEP) ; `exit $UCERROR_RHC_SSH`; fi
}

function tailApp {
	TAIL_TIMEBOX=7
	STEP="timeout3 -t$TAIL_TIMEBOX rhc tail $SAMPLE_APPNAME -o '-n0'"
	echo o $STEP
	# app tail should provide 3 php log file (timebox $TAIL_TIMEBOX seconds)
	TAIL_CHECK=`$SCRIPT_PATH/lib/timeout3 -t$TAIL_TIMEBOX rhc tail $SAMPLE_APPNAME -o '-n0'|grep "php/log"|wc -l`
	if [ ! "$TAIL_CHECK" -ge 2 ];  then echo $(errorMsg $STEP) ; `exit $UCERROR_RHC_TAIL`; fi
}

function pushApp {
	STEP="commit add phpinfo.php and push it"
	echo o $STEP
	PHPINFO_CONTENT="<? phpinfo(); ?>"
	PHPINFO_FILE="$WORK_REPO_DIR/php/phpinfo.php"
	echo "$PHPINFO_CONTENT" > $PHPINFO_FILE
	pushd $WORK_REPO_DIR > /dev/null && git add $PHPINFO_FILE && git commit -m "add phpinfo" && git push
	if [ $? -ne 0 ]; then echo $(errorMsg $STEP) ; popd > /dev/null ; `exit $UCERROR_COMMIT_PUSH`; else popd > /dev/null ; fi
}

function curlPush {
	PHPINFO_URL="$SAMPLE_APP_URL/phpinfo.php"
	PHPINFO_HASH="This program makes use of the Zend Scripting Language Engine"
        STEP="curl $PHPINFO_URL"
        echo o $STEP
        # phpinfo *new* page should contains $PHPINFO_HASH
        CURL_CHECK=`curl $PHPINFO_URL 2>/dev/null |grep "$PHPINFO_HASH"|wc -l`
        if [ $CURL_CHECK -ne 1 ]; then echo $(errorMsg $STEP) ; `exit $UCERROR_CURL_PUSH`; fi
}

function deleteApp {
	STEP=$DELETE_APP
	echo o $STEP
	$DELETE_APP
	if [ $? -ne 0 ]; then echo $(errorMsg $STEP) ; `exit $UCERROR_RHC_DELETE_APP`; fi
}

function checkAppPresence {
	IS_APP_PRESENT=`(rhc apps|grep "$SAMPLE_APP_URL" |wc -l)`
	echo $IS_APP_PRESENT
}

# clean app if exists
function cleanApp {
	STEP="clean app if exists"
	echo o $STEP
	if [ "$(checkAppPresence)" == "1" ]; then deleteApp; fi
}

# clean work dir if exists
function cleanWork {
	STEP="clean work/ dir if exists"
	echo o $STEP
	if [ -d $WORK_DIR ]; then rm -rf "$WORK_DIR"; fi
}

function createWork {
	STEP="mkdir -p $WORK_DIR"
	$STEP && \
	echo o $STEP
}

RESULT=0
##############
cleanWork && cleanApp && createWork
##########/ \
createApp && \
curlApp   &&  \
sshApp    &&   \
tailApp   && \
pushApp   &&  \
curlPush  &&   \
deleteApp &&    \
echo "$(successMsg)" # Joyeux Noel ! #
RESULT=$?
##############
cleanWork && cleanApp 
##############
exit $RESULT
