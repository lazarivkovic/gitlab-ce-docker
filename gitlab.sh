#!/bin/bash

sudo docker run --detach \
  --hostname gitlab.lazar.cloud \
  --publish 127.0.0.1:4433:443 --publish 127.0.0.1:8081:80 --publish 2222:22 \
  --name gitlab \
  --restart always \
  --volume /srv/gitlab/config:/etc/gitlab \
  --volume /srv/gitlab/logs:/var/log/gitlab \
  --volume /srv/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest
