#!/bin/bash
PATH=/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin



#############
# variables #
#############

### global variables ###
backup_path='/absolute/path/to/backup';
webroot_path='/absolute/path/to/webroot/e.g./public_html';
restore_path='/absolute/path/to/directory/restore';
scr_path='/absolute/path/to/directory/with/shell_scripts';

### site variables ###
site='mysite.com';
db='database_name';
db_usr='database_user_name';
db_passwd='database_password';



###################
# prepare restore #
###################

### Create restore log ###
cd $restore_path/;
exec > ./restore.log 2>&1;


### empty trash ###
echo -e "\n\n\n\n\n\n\n\n\n\n EMPTY TRASH \n";
cd $webroot_path/;
# requires a directory "trash" within the webroot
rm -Rf ./trash/*;



#######################
# handle backup files #
#######################

echo -e '\n\n\n\n\n\n\n\n\n\n#####################################\n# handle backup files #\n#####################################\n';
### untar ###
echo -e "\n\n\n\n\n\n\n\n\n\n UNTAR BACKUP TO .../restore/backup.tmp \n";
mkdir $restore_path/backup.tmp;
cd $backup_path/2.restore/;
tar -xpvzf *.tar.gz -C $restore_path/backup.tmp;



###########
# restore #
###########

echo -e '\n\n\n\n\n\n\n\n\n\n#####################################\n# restore #\n#####################################\n';

### Drop Database Tables ###
echo -e "\n\n\n\n\n\n\n\n\n\n DROP ALL TABLES IN DATABASE \n";
cd $scr_path/;
./drop-mysql-tables.sh $db_usr $db_passwd $db;


### Restore Database ###
echo -e "\n\n\n\n\n\n\n\n\n\n GUNZIP DATABASE \n";
cd $restore_path/backup.tmp/;
gunzip ./*.sql.gz;

echo -e "\n\n\n\n\n\n\n\n\n\n MYSQL VERSION IS: \n";
mysql --version;

echo -e "\n\n\n\n\n\n\n\n\n\n MYSQLIMPORT \n";
mysql -u $db_usr -p$db_passwd --verbose --default-character-set=utf8mb4 $db < $db.sql;


### Restore Files ###
echo -e "\n\n\n\n\n\n\n\n\n\n MOVE LIVE DIRECTORIES TO TRASH \n";
cd $webroot_path/_$site/;
mv ./htdocs $webroot_path/trash/;

echo -e "\n\n\n\n\n\n\n\n\n\n MOVE RESTORE DIRECTORIES TO HTML \n";
cd $restore_path/backup.tmp/;
mv .$webroot_path/_$site/htdocs $webroot_path/_$site/;

echo -e "\n\n\n\n\n\n\n\n\n\n chmod htdocs directory \n";
chmod 755 $webroot_path/_$site/htdocs/;


### Remove backup archives ###
echo -e "\n\n\n\n\n\n\n\n\n\n REMOVE BACKUP ARCHIVES \n";
cd $restore_path/;
rm -Rf backup.tmp;



#######################
# gzip and rename log #
#######################

### Gzip Rename Log ###
echo -e "\n\n\n\n\n\n\n\n\n\n GZIP AND RENAME LOG \n";
cd $restore_path/;
gzip ./restore.log;
now=$(date +"%Y-%m-%d");
mv ./restore.log.gz ./$now.restore_$site.log.gz;
