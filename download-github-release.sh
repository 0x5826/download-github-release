#!/bin/bash

#proxy="-x socks5://127.0.0.1:1080"
proxy=""

#download the release
function dl_lastest_release() {
    VERSION=$(curl -fsSL $proxy https://api.github.com/repos/$1/$2/releases/latest | grep tag_name | sed -E 's/.*"(.*)".*/\1/')
    DOWNLOAD_URL=$(curl -fsSL $proxy https://api.github.com/repos/$1/$2/releases/latest | grep browser_download_url | sed -E 's/.*"(.*)".*/\1/')
    DOWNLOAD_FOLDER="releases-$1-$2-$VERSION"
    if [ -d "$DOWNLOAD_FOLDER" ];then
        echo -e "\033[33m[Notice]\033[0mFound folder $DOWNLOAD_FOLDER, Do nothing."
    else
        echo -e "\033[33m[Notice]\033[0mCreating folder $DOWNLOAD_FOLDER"
        mkdir $DOWNLOAD_FOLDER && cd $DOWNLOAD_FOLDER
        for DOWNLOAD_FILE in $DOWNLOAD_URL
        do
            echo -e "\033[33m[Notice]\033[0mDownloading \033[32m$DOWNLOAD_FILE\033[0m"
            curl -O -fSL $proxy -# $DOWNLOAD_FILE
        done
        
    fi
}

function dl_custom_release() {
    DOWNLOAD_URL=$(curl -fsSL $proxy https://api.github.com/repos/$1/$2/releases/tags/$3 | grep browser_download_url | sed -E 's/.*"(.*)".*/\1/')
    DOWNLOAD_FOLDER="releases-$1-$2-$3"
    if [ -d "$DOWNLOAD_FOLDER" ];then
        echo -e "\033[33m[Notice]\033[0mFound folder $DOWNLOAD_FOLDER, Do nothing."
    else
        echo -e "\033[33m[Notice]\033[0mCreating folder $DOWNLOAD_FOLDER"
        mkdir $DOWNLOAD_FOLDER && cd $DOWNLOAD_FOLDER
        for DOWNLOAD_FILE in $DOWNLOAD_URL
        do
            echo -e "\033[33m[Notice]\033[0mDownloading \033[32m$DOWNLOAD_FILE\033[0m"
            curl -O -fSL $proxy -# $DOWNLOAD_FILE
        done
    fi
}

function dl_all_release() {
    VERSIONS=$(curl -fsSL $proxy https://api.github.com/repos/$1/$2/releases | grep tag_name | sed -E 's/.*"(.*)".*/\1/')
    DOWNLOAD_FOLDER="releases-$1-$2"
    if [ -d "$DOWNLOAD_FOLDER" ];then
        echo -e "\033[33m[Notice]\033[0mFounding folder $DOWNLOAD_FOLDER."
    else
        echo -e "\033[33m[Notice]\033[0mCreating folder $DOWNLOAD_FOLDER."
        mkdir $DOWNLOAD_FOLDER
    for VERSION in $VERSIONS
    do
        if [ -d "$VERSION" ];then
            echo -e "\033[33m[Notice]\033[0mFounding folder $VERSION, noting to do."
        else
            echo -e "\033[33m[Notice]\033[0mCreating folder $DOWNLOAD_FOLDER/$VERSION"
            cd $DOWNLOAD_FOLDER && mkdir $VERSION && cd $VERSION
            DOWNLOAD_URL=$(curl -fsSL $proxy https://api.github.com/repos/$1/$2/releases/tags/$VERSION | grep browser_download_url | sed -E 's/.*"(.*)".*/\1/')
            for DOWNLOAD_FILE in $DOWNLOAD_URL
            do
                echo -e "\033[33m[Notice]\033[0mDownloading \033[32m$DOWNLOAD_FILE\033[0m"
                curl -O -fSL $proxy -# $DOWNLOAD_FILE
            done
            cd ..
    done
    fi
}

function help_info() {
    echo -e "usage:\n ./download-github-release.sh latest v2fly v2ray-core\n ./download-github-release.sh custom v2fly v2ray-core v1.6.0-rc5 \n ./download-github-release.sh all v2fly v2ray-core"
}

if [ "$1" = "latest" ];then
    if [[ -n "$2" ]] && [[ -n "$3" ]];then
        dl_lastest_release $2 $3
    else
        help_info
    fi
elif [ "$1" = "all" ];then
    if [[ -n "$2" ]] && [[ -n "$3" ]];then
        dl_all_release $2 $3
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