#!/bin/bash

#Set variables
API_KEY=""

#Set functions
function spgt_installer(){
if ! which sgpt 1>/dev/null 2>&1; then
	echo "INFO: shell-gpt is not installed, now installing it..."
	pip install shell-gpt
	if [[ $? -ne 0 ]]; then
		echo "ERROR: Unsupported PWD env!"
	fi
fi

}

function spgt_api_key_setter(){
echo -e "Please enter the OPENAI API key (Check with Leon if you don't have any)\n"
read API_KEY
line_number_for_Key=""
if [[ -n $API_KEY ]]; then
	if [[ ! -f /root/.config/shell_gpt/.sgptrc ]]; then
		echo "INFO: Config file is not detected, now creating it..."
		mkdir -p /root/.config/shell_gpt
		touch /root/.config/shell_gpt/.sgptrc
	fi
	echo "OPENAI_API_KEY=" > /root/.config/shell_gpt/.sgptrc
	line_number_for_Key=$(awk '/OPENAI_API/{print NR}' /root/.config/shell_gpt/.sgptrc)
	sed -i "${line_number_for_Key}c "OPENAI_API_KEY=${API_KEY}"" /root/.config/shell_gpt/.sgptrc
	[[ $? -eq 0 ]] && echo "INFO: API key inserted." || echo "ERROR: API key insertion failed!"
else
	echo "ERROR: The API key cannot be empty string!"
fi
}

###Main scirpt###
spgt_installer
spgt_api_key_setter
###Main scirpt###


