 #!/bin/bash -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

main()
{
 BASE_DIR=/app
 ENVIRON=PROD
 PAYLOAD_PATH=/staging/taskid
 PAYLOAD_FILE=PAYLOAD.tar.gz
 SCP_USER=scpuser
 DEPLOYMENT_SERVER=svrhostname

 is_DM_HOST=$1

 logmsg "deploying to host $HOSTNAME ..."

 cd $BASE_DIR

 scp ${SCP_USER}@${DEPLOYMENT_SERVER}:${PAYLOAD_PATH}/${PAYLOAD_FILE} .

 if [ ! -f ${PAYLOAD_FILE} ]; then
    logmsg "payload file ${PAYLOAD_PATH}/${PAYLOAD_FILE} was not copied from $DEPLOYMENT_SERVER"
    exit 1
 fi

 if [ ! -d "mkv/DS_$HOSTNAME" ]; then mkdir -p "mkv/DS_$HOSTNAME"; fi
 cd mkv/DS_$HOSTNAME
 if [ -f "current" ]; then mv current previous; fi
 cd ../..

 if [ is_DM_HOST==true ]; then
         if [ ! -d "mkv/DM_$HOSTNAME" ]; then mkdir -p "mkv/DM_$HOSTNAME"; fi
         cd mkv/DM_$HOSTNAME
         if [ -f "current" ]; then mv current previous; fi
         cd ../..
 fi

 # expand tarball
 tar -xvf $PAYLOAD_FILE
 mv "${BASE_DIR}/libs/JAVA" "${BASE_DIR}/libs/java"

 cd config
 chmod -x *
 cp PLATFORM_config.include_${ENVIRON} PLATFORM_config.include
 rm -f PLATFORM_config.include_*
 cd ../mkv

 rsync -a --remove-sent-files DS/ DS_$HOSTNAME/

 if [ isDM_HOST==true ]; then
   rsync -a --remove-sent-files DM/ DM_$HOSTNAME/
   rsync -a --remove-sent-files SHELL/ SHELL_$HOSTNAME/
 fi

 rm -rf DM DS SHELL

 # specific host only

 if [ "$HOSTNAME" == "specifichost" ]; then
    # commands for specific host go here
 fi

 rm -f "${BASE_DIR}/${PAYLOAD_FILE}"
}

logmsg()
{

 MSG=$1
 msgtimestamp=$(date "+%Y.%m.%d-%H.%M.%S")
 logstr="$msgtimestamp | $MSG"

 printf "$logstr\n"
}
main "$@"
