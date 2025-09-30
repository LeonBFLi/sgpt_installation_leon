#!/bin/bash
#function using the 'https://github.com/fathyb/carbonyl' project to run a terminal bowser contianer

##Define variables
url=$1  #adding user-put as the first positional argument

##Defind functions
function args_parser(){

	if [[ $# -ne 1 ]]; then
	echo 'INFO: Please pass in the url that you would like to visit as the 1st positional argument'
	echo "Example: $0 https://youtube.com"
	exit 2
fi

if [[ $url =~ 'www' ]]; then
	url=`echo $url | sed 's@www.@https://@g'`
fi

}

function connectivity_checker(){
response=""
response=$(curl -s -o /dev/null -w "%{http_code}" $url)
if [[ $response -ne 200 ]]; then
	echo "ERROR: the link provided is not accessible"
	exit 2
fi
}

function termial_broswer(){
which docker 1>/dev/null 2>&1
[[ $? -ne 0 ]] && echo "ERROR: docker is not installed." && exit
docker run --rm -ti fathyb/carbonyl $url
}

###main###
args_parser $url
#connectivity_checker
termial_broswer
###main###
