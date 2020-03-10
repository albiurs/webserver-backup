#!/bin/bash
PATH=/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin



########################
### global variables ###
########################

backup_path='/absolute/path/to/backup';
webroot_path='/absolute/path/to/webroot/e.g./public_html';



##################
# prepare backup #
##################

### update archive ###
echo -e "\n\n\n\n\n\n\n\n\n\n UPDATE ARCHIVE \n";
cd $backup_path/weekly/;
rm ./04/*;
mv ./03/* ./04/;
mv ./02/* ./03/;
mv ./01/* ./02/;

### Create backup log ###
cd $backup_path/weekly/01/;
exec > ./backup.log 2>&1;

### Empty Trash ###
echo -e "\n\n\n\n\n\n\n\n\n\n EMPTY TRASH \n";
cd $webroot_path/;
# requires a directory "trash" within the webroot
rm -Rf ./trash/*;

echo -e "################\n# cd to backup directory #\n################\n";
cd $backup_path/weekly/;



#################
# create backup #
#################

echo -e "################\n# run backup_sites.sh #\n################\n";
### run backup_sites.sh ###
path/to/backup/scripts/backup_sites.sh $webroot_path;



#######################
# gzip and rename log #
#######################

echo -e "################\n# gzip and rename log #\n################\n";
cd $backup_path/weekly/01/;
gzip ./backup.log;
now=$(date +"%Y-%m-%d");
mv ./backup.log.gz ./$now.backup.log.gz;
