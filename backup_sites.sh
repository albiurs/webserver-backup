#!/bin/bash
PATH=/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin



########################
### global variables ###
########################

webroot_path=$1;



#################
# create backup #
#################

echo -e "################\n# root files #\n################\n";
### site variables ###
site='root_files';

### backup ###
echo -e "\n\n\n\n\n\n\n\n\n\n GZIPPED TAR FILES \n";
tar -cvpzf backup_$site.tar.gz $webroot_path/.htaccess $webroot_path/cgi-bin/ $webroot_path/any/other/directory/to/backup;

echo -e "\n\n\n\n\n\n\n\n\n\n CHMOD ARCHIVE \n";
chmod 600 backup_$site.tar.gz;

### date ###
echo -e "\n\n\n\n\n\n\n\n\n\n ADD DATE \n";
now=$(date +"%Y-%m-%d");
mv ./backup_$site.tar.gz ./01/$now.backup_$site.tar.gz;


echo -e "################\n# mysite.com #\n################\n";
### site variables ###
site='mysite.com';
db='database_name';
db_usr='database_user_name';
db_passwd='database_password';

### dump ###
echo -e "\n\n\n\n\n\n\n\n\n\n MYSQLDUMP VERSION IS: \n";
mysqldump --version;

echo -e "\n\n\n\n\n\n\n\n\n\n MYSQLDUMP \n";
mysqldump -u $db_usr -p$db_passwd --verbose --add-drop-table --default-character-set=utf8mb4 $db > ./$db.sql;

### backup ###
echo -e "\n\n\n\n\n\n\n\n\n\n GZIP SQL FLISES \n";
gzip ./$db.sql;

echo -e "\n\n\n\n\n\n\n\n\n\n GZIPPED TAR FILES \n";
tar -cvpzf backup_$site.tar.gz $webroot_path/_$site/ ./*.sql.gz;
rm ./*sql.gz;

echo -e "\n\n\n\n\n\n\n\n\n\n CHMOD ARCHIVE \n";
chmod 600 backup_$site.tar.gz;

### date ###
echo -e "\n\n\n\n\n\n\n\n\n\n ADD DATE \n";
now=$(date +"%Y-%m-%d");
mv ./backup_$site.tar.gz ./01/$now.backup_$site.tar.gz;
