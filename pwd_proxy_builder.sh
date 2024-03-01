#!/bin/bash
#function: set up an proxy to access any page internally

#set variables
target_url=""

#set functions
function link_getter(){
read -p "Please enter the page that you would like to access: " target_url
if ! ping -c 1 $target_url 1>/dev/null 2>&1 ; then
	echo "Warning: link unpingable!"
#	exit
fi
}

function nginx_container_builder(){
docker run -itd -p 80:80 --name nginx_proxy_server nginx 
}

function template_file_builder(){

touch /tmp/nginx.conf
cat << EOF > /tmp/nginx.conf

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                     '$status $body_bytes_sent "$http_referer" '
                     '"$http_user_agent" "$http_x_forwarded_for"';
    access_log /var/log/nginx/access.log main;
    sendfile on;
    #tcp_nopush on;
    keepalive_timeout 65;
    #gzip on;

    server {
        listen 80;
       # server_name 8.219.249.154; # Replace with your domain or IP address

        location / {
            proxy_pass <IP_addr>;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

}

function config_file_updator (){
sed -i "s@<IP_addr>@$target_url@g" /tmp/nginx.conf
docker cp /tmp/nginx.conf nginx_proxy_server:/etc/nginx/nginx.conf
docker restart nginx_proxy_server
echo "INFO: please access the site via port 80"
}





###main scirpt###
link_getter
nginx_container_builder
template_file_builder
config_file_updator
###main scirpt###
