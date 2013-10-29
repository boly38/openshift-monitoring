#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PHPSCRIPT=$SCRIPT_PATH/uc_openshift_samplephp.sh
LOGDIR=$SCRIPT_PATH/log
LASTLOGDIR=$SCRIPT_PATH/last_log
LOGFILE=$LOGDIR/usecase.log

mkdir -p $LOGDIR
DATE=`date "+%Y-%m-%d %H:%M"`
echo "$DATE" > $LOGFILE
`$PHPSCRIPT 2>>$LOGFILE 1>>$LOGFILE`
CASESTATUS=$?
if [ $CASESTATUS -ne 0 ]; then
  DATE=`date "+%Y-%m-%d %H:%M"`
  echo "$DATE end " >> $LOGFILE
  rm -rf $LASTLOGDIR
  mkdir -p $LASTLOGDIR
  cp -R $LOGDIR/* $LASTLOGDIR
fi
rm -rf $LOGDIR
exit $CASESTATUS
