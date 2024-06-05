#!/bin/bash
#function: set up an proxy to access any page internally

#set variables
target_url=""

#set functions
function link_getter(){
read -p "Please enter the page that you would like to access: " target_url
if ! ping -c 1 $target_url 1>/dev/null 2>&1 ; then
	echo "ERROR: page not accessible"
#	exit
fi
}

function nginx_container_builder(){
docker run -itd -p 80:80 --name nginx_proxy_server nginx 
}

function template_file_builder(){

touch /tmp/nginx.conf
cat << EOF > /tmp/nginx.conf
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}


http {
    access_log /var/log/nginx/access.log;

    upstream backend {
        server <IP_addr>;
    }

    server {
        listen 80;
        location / {
            proxy_pass http://backend/;
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
