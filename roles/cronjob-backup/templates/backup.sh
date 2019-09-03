#!/bin/bash

BACKUPDIR="/opt/app/backups"
CURRENTBACKUPDIR="${BACKUPDIR}/pdscurrent"
PDSBACKUPDIR="${BACKUPDIR}/pds/pds_`date -d '-1 day' '+%m-%d-%Y'`"
PDSBIN="/opt/app/installs/pds/bin"
CRONJOBLOG="/opt/app/logs/pds/pdscronlogs_`date '+%m-%d-%Y'`"
PREVDAY="`date -d '-1 day' '+%m-%d-%Y'`"
PRESENTDAY="`date '+%m-%d-%Y'`"
OPENDJBACKUPDIR="${BACKUPDIR}/opendj/opendj_`date '+%m-%d-%Y'`"
OPENDJCURRENTBACKUPDIR="${BACKUPDIR}/opendjcurrent"

# Check whether the current backup directory is empty or not

if [ "$(ls -A $CURRENTBACKUPDIR)" ]; then
     echo "The folder $CURRENTBACKUPDIR is not Empty" >> $CRONJOBLOG
fi

# Check the count of number of files in the userRoot

if [ "$(ls ${CURRENTBACKUPDIR}/userRoot | wc -l)" -lt 11 ]; then
     echo "One or more incremental backups might have failed on $PREVDAY" >> $CRONJOBLOG
else
     echo "Incremental backups are successful on $PREVDAY" >> $CRONJOBLOG
fi

# Create a folder to place previous day's backup
mkdir $PDSBACKUPDIR

#create a folder for opendj to place the backup
mkdir $OPENDJBACKUPDIR

# Move the contents from current folder to the date folder
echo "Moving the pds backup contents of $PREVDAY from the current folder to the DATE folder " >> $CRONJOBLOG
mv $CURRENTBACKUPDIR/* $PDSBACKUPDIR

# Move the contents of opendj from current folder to the date folder
echo "Moving the opendj backup contents of $PRESENTDAY from the current folder to the DATE folder " >> $CRONJOBLOG
mv $OPENDJCURRENTBACKUPDIR/* "$OPENDJBACKUPDIR"

if [ \( "$(ls -A $PDSBACKUPDIR)" \) -a \( "$(ls $PDSBACKUPDIR | wc -l)" -gt 11 \) ]; then
    echo "Successfully moved the contents to the date folder" >> $CRONJOBLOG

else
    echo "The date folder is missing some backup files after moving the contents from current folder" >> $CRONJOBLOG
fi

# Copy the encryption_settings.pin and place it in the current backup folder
cp -rf "/opt/app/installs/pds/config/encryption-settings.pin" "/opt/app/backups/pdscurrent"

# Take full PDS full backup to the Backup current folder

echo "Taking PDS full backup" >> $CRONJOBLOG

"${PDSBIN}/backup" --backUpAll --compress --backupDirectory "$CURRENTBACKUPDIR"
echo "PDS Full Backup is completed on $PRESENTDAY" >> $CRONJOBLOG

# Deleting the PDS backup folders which are older than 7 days

find "$BACKUPDIR/pds" -mindepth 1 -mtime 7 -type d | xargs rm -rf
echo "Deleted the 7 day old backup folder for PDS on $PRESENTDAY" >> $CRONJOBLOG

# Deleting the OpenDJ backup folders which are older than 7 days

find "$BACKUPDIR/opendj" -mindepth 1 -mtime 7 -type d | xargs rm -rf
echo "Deleted the 7 day old backup folder for OpenDJ on $PRESENTDAY" >> $CRONJOBLOG

# Deleting the cronjob logs from /opt/app/logs/pds folder that are 7 days old

find "/opt/app/logs/pds" -mtime 7 -type f -name pdscron* -delete
echo "Deleted the 7 day old cron job log files from the log folder"