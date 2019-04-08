#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required:  MacOS           							  #
#   Description: One click get info from ishadow.com              #
#   Author: BLZ <zhaoxiangyu333@icloud.com>                       #
#   Thanks: https://d.ishadowx.com         						  #
#=================================================================#

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'


clear
echo
echo "#############################################################"
echo "# One click get info from ishadow.com                       #"
echo "# BLZ <zhaoxiangyu333@icloud.com>                           #"
echo "# Github: qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq #"
echo "#############################################################"
echo


get_info(){
echo "请输入爬虫项目的本地路径"
read -p "(默认当前目录):" projectPath
[ -z "${projectPath}" ] && projectPath=$(cd `dirname $0`; pwd)
echo "---------------------------"
echo "目录路径 = '${projectPath}'"
echo "---------------------------"
echo 
echo "正在获取账号信息....."
cd ${projectPath}
scrapy crawl ishadow_spider
clear
echo "---------------------------"
echo "-----获得账号信息如下-----"
echo "---------------------------"
cat ${projectPath}/ishadow.json
echo
echo "---------------------------"
}


check_sys_pre(){
	st= sw_vers
	if ${st} | grep 'Mac OS X';then
		return 0
	else
        return 1
	fi 
}

check_sys(){
    local checkType=$1
    local value=$2

    local release=''
    local systemPackage=''

    if [[ -f /etc/redhat-release ]]; then
        release="centos"
        systemPackage="yum"
    elif grep -Eqi "debian|raspbian" /etc/issue; then
        release="debian"
        systemPackage="apt"
    elif grep -Eqi "ubuntu" /etc/issue; then
        release="ubuntu"
        systemPackage="apt"
    elif grep -Eqi "centos|red hat|redhat" /etc/issue; then
        release="centos"
        systemPackage="yum"
    elif grep -Eqi "debian|raspbian" /proc/version; then
        release="debian"
        systemPackage="apt"
    elif grep -Eqi "ubuntu" /proc/version; then
        release="ubuntu"
        systemPackage="apt"
    elif grep -Eqi "centos|red hat|redhat" /proc/version; then
        release="centos"
        systemPackage="yum"
    fi

    if [[ "${checkType}" == "sysRelease" ]]; then
        if [ "${value}" == "${release}" ]; then
            return 0
        else
            return 1
        fi
    elif [[ "${checkType}" == "packageManager" ]]; then
        if [ "${value}" == "${systemPackage}" ]; then
            return 0
        else
            return 1
        fi
    fi
}

install_dependencies(){
    if check_sys packageManager yum; then
        echo -e "[${green}Info${plain}] 检查EPEL存储库..."
        if [ ! -f /etc/yum.repos.d/epel.repo ]; then
            yum install -y epel-release > /dev/null 2>&1
        fi
        [ ! -f /etc/yum.repos.d/epel.repo ] && echo -e "[${red}Error${plain}] 安装EPEL存储库失败，请检查它." && exit 1
        [ ! "$(command -v yum-config-manager)" ] && yum install -y yum-utils > /dev/null 2>&1
        [ x"$(yum-config-manager epel | grep -w enabled | awk '{print $3}')" != x"True" ] && yum-config-manager --enable epel > /dev/null 2>&1
        echo -e "[${green}Info${plain}] 检查EPEL存储库..."

        yum_depends=(
            unzip gzip openssl openssl-devel gcc python python-devel python-setuptools pcre pcre-devel libtool libevent
            autoconf automake make curl curl-devel zlib-devel perl perl-devel cpio expat-devel gettext-devel
            libev-devel c-ares-devel git qrencode
        )
        for depend in ${yum_depends[@]}; do
            error_detect_depends "yum -y install ${depend}"
        done
    elif check_sys packageManager apt; then
        apt_depends=(
            gettext build-essential unzip gzip python python-dev python-setuptools curl openssl libssl-dev
            autoconf automake libtool gcc make perl cpio libpcre3 libpcre3-dev zlib1g-dev libev-dev libc-ares-dev git qrencode
        )

        apt-get -y update
        for depend in ${apt_depends[@]}; do
            error_detect_depends "apt-get -y install ${depend}"
        done
    fi
}

install_check(){
    if check_sys packageManager yum || check_sys packageManager apt; then
        if centosversion 5; then
            return 1
        fi
        return 0
    else
        return 1
    fi
}





echo "----正在检测安装环境----"

if check_sys_pre;then
	echo "检测为MACOS系统"
else
	echo "检测为未知系统"
	if !install_check;then
		echo "error"
		exit 1
	fi
fi


install_dependencies
get_info

