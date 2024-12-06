#!/bin/bash
#function: set up nginx lb for GPT access from a PWD instance

#define vars
prepared_img="andylbf/lb_pwd"

#define functions
function lb_container_starter(){
echo "INFO: please open your port 80 for the access"
docker pull $prepared_img && (docker run -itd --name lb -p 80:80 $prepared_img)
}


###Main scirpt###
lb_container_starter
###Main scirpt###
