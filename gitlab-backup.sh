#!/usr/bin/env bash

set -x

mkdir -p /root/backups/gitlab/app
mkdir -p /root/backups/gitlab/secrets

docker exec -t gitlab gitlab-ctl backup-etc && \
docker exec -t gitlab gitlab-backup create && \


last_file_app=$(docker exec -t gitlab sh -c 'ls -t /var/opt/gitlab/backups/ | head -n 1') && \
last_file_secrets=$(docker exec -t gitlab sh -c 'ls -t /etc/gitlab/config_backup/ | head -n 1') && \
app=$(printf $last_file_app | tr -d '\r')
secrets=$(printf $last_file_secrets | tr -d '\r')

docker cp gitlab:/var/opt/gitlab/backups/$app /root/backups/gitlab/app && \
docker cp gitlab:/etc/gitlab/config_backup/$secrets /root/backups/gitlab/secrets && \


docker exec -t gitlab sh -c 'rm -rf /var/opt/gitlab/backups/*.tar' && \
docker exec -t gitlab sh -c 'rm -rf /etc/gitlab/config_backup/*.tar' && \

if [[ $? -eq 0 ]]; then

find /root/backups/gitlab/secrets/*tar -mtime +7 -type f -delete 
find /root/backups/gitlab/app/*tar -mtime +7 -type f -delete 
   
echo "something went wrong!"

exit 1

fi


