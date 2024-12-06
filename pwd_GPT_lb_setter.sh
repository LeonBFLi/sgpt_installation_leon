#!/bin/bash
#function: this script is used for setting up nginx lb in PWD playground env

#vars
nginx_config_file="/etc/nginx/nginx.conf"

#functions
packages_installer(){
apk update && apk upgrade
apk add nginx && apk add openrc --no-cache
}

rc_softlevel_enabler(){
if [[ ! -f /run/openrc/softlevel  ]]; then
mkdir -p /run/openrc/
touch /run/openrc/softlevel
fi
}

nginx_conf_writter(){
cat << EOF > $nginx_config_file
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}


http {
    access_log /var/log/nginx/access.log;

    upstream backend {
        server talkwithme.top;
    }

    server {
        listen 80;
        location / {
            proxy_pass http://backend/;
        }

        client_max_body_size 999M;
    }
}
EOF
}

function service_starter(){
echo "INFO: $(nginx -t)"
rc-status && rc-service nginx start
echo "INFO: please access the page via port 80"
}


#main script
packages_installer
rc_softlevel_enabler
nginx_conf_writter
service_starter
#main script
