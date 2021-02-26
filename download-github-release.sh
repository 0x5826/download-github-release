#!/bin/bash

#download the release
function dl_lastest_release() {
    VERSION=$(curl -fsSL https://api.github.com/repos/$1/$2/releases/latest | grep tag_name | sed -E 's/.*"(.*)".*/\1/')
    DOWNLOAD_URL=$(curl -fsSL https://api.github.com/repos/$1/$2/releases/latest | grep browser_download_url | sed -E 's/.*"(.*)".*/\1/')
    DOWNLOAD_FOLDER="$1-$2-$VERSION"
    if [ -d "$DOWNLOAD_FOLDER" ];then
    	echo "[Notice]Found folder $DOWNLOAD_FOLDER, Do nothing."
    else
    	echo "[Notice]Creating folder $DOWNLOAD_FOLDER"
    	mkdir $DOWNLOAD_FOLDER && cd $DOWNLOAD_FOLDER
    	echo "$DOWNLOAD_URL" | grep $VERSION | xargs wget -q --show-progress
    fi
}

function dl_custom_release() {
    DOWNLOAD_URL=$(curl -fsSL https://api.github.com/repos/$1/$2/releases/tags/$3 | grep browser_download_url | sed -E 's/.*"(.*)".*/\1/')
    DOWNLOAD_FOLDER="$1-$2-$VERSION"
    if [ -d "$DOWNLOAD_FOLDER" ];then
    	echo "[Notice]Found folder $DOWNLOAD_FOLDER, Do nothing."
    else
    	echo "[Notice]Creating folder $DOWNLOAD_FOLDER"
    	mkdir $DOWNLOAD_FOLDER && cd $DOWNLOAD_FOLDER
    	wget -q --show-progress $DOWNLOAD_URL
    fi
}

function help_info() {
	echo -e "usage:\n ./download-github-release.sh latest v2fly v2ray-core\n ./download-github-release.sh custom v2fly v2ray-core v1.6.0-rc5"
}

if [ "$1" = "latest" ];then
	if [[ -n "$2" ]] && [[ -n "$3" ]];then
    	dl_lastest_release $2 $3
    else
    	help_info
    fi
elif [ "$1" = "custom" ];then
	if [[ -n "$2" ]] && [[ -n "$3" ]];then
    	if [ -n "$4"  ];then
    		dl_custom_release $2 $3 $4
        else
        	help_info
        fi
    else
    	help_info
    fi
else
	help_info
fi