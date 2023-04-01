#!/bin/bash
###
 # @Edited Author: spiritlhl
 # @Date: 2023-04-02
 # @Repo: https://github.com/spiritLHLS/OpenAI-Checker
 # @Original Author: Vincent Young
 # @LastEditors: Vincent Young
 # @LastEditTime: 2023-02-15 20:54:40
 # @FilePath: /OpenAI-Checker/openai.sh
 # @Telegram: https://t.me/missuo
 # 
 # Copyright © 2023 by Vincent, All Rights Reserved. 
### 

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'
BLUE="\033[36m"
SUPPORT_COUNTRY=(AL DZ AD AO AG AR AM AU AT AZ BS BD BB BE BZ BJ BT BA BW BR BG BF CV CA CL CO KM CR HR CY DK DJ DM DO EC SV EE FJ FI FR GA GM GE DE GH GR GD GT GN GW GY HT HN HU IS IN ID IQ IE IL IT JM JP JO KZ KE KI KW KG LV LB LS LR LI LT LU MG MW MY MV ML MT MH MR MU MX MC MN ME MA MZ MM NA NR NP NL NZ NI NE NG MK NO OM PK PW PA PG PE PH PL PT QA RO RW KN LC VC WS SM ST SN RS SC SL SG SK SI SB ZA ES LK SR SE CH TH TG TO TT TN TR TV UG AE US UY VU ZM BO BN CG CZ VA FM MD PS KR TW TZ TL GB)
REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'" "fedora" "arch")
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Fedora" "Arch")
PACKAGE_UPDATE=("! apt-get update && apt-get --fix-broken install -y && apt-get update" "apt-get update" "yum -y update" "yum -y update" "yum -y update" "pacman -Sy")
PACKAGE_INSTALL=("apt-get -y install" "apt-get -y install" "yum -y install" "yum -y install" "yum -y install" "pacman -Sy --noconfirm --needed")
PACKAGE_REMOVE=("apt-get -y remove" "apt-get -y remove" "yum -y remove" "yum -y remove" "yum -y remove" "pacman -Rsc --noconfirm")
PACKAGE_UNINSTALL=("apt-get -y autoremove" "apt-get -y autoremove" "yum -y autoremove" "yum -y autoremove" "yum -y autoremove" "")
CMD=("$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)" "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)" "$(lsb_release -sd 2>/dev/null)" "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)" "$(grep . /etc/redhat-release 2>/dev/null)" "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')" "$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)") 
SYS="${CMD[0]}"
[[ -n $SYS ]] || exit 1
for ((int = 0; int < ${#REGEX[@]}; int++)); do
    if [[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[int]} ]]; then
        SYSTEM="${RELEASE[int]}"
        [[ -n $SYSTEM ]] && break
    fi
done
apt-get --fix-broken install -y > /dev/null 2>&1

checkping() {
    echo "checking ping"
	if  [ ! -e '/usr/bin/ping' ]; then
            echo "Installing ping"
	        ! ${PACKAGE_INSTALL[int]} iputils-ping || ${PACKAGE_INSTALL[int]} ping > /dev/null 2>&1
	fi
}

checkping
echo -e "${BLUE}OpenAI Access Checker. ${PLAIN}"
echo -e "${BLUE}Current Author: spiritlhl${PLAIN}"
echo -e "${BLUE}Current repo: https://github.com/spiritLHLS/OpenAI-Checker${PLAIN}"
echo -e "${BLUE}Original Author: Vincent${PLAIN}"
echo -e "${BLUE}Original repo: https://github.com/missuo/OpenAI-Checker${PLAIN}"
echo "-------------------------------------"
if [[ $(curl -sS -m 10 https://chat.openai.com/ -I 2>/dev/null | grep "text/plain") != "" ]] >/dev/null 2>&1; then
	echo "Your IP is BLOCKED!"
else
	echo -e "[IPv4]"
	check4=`ping -W 10 1.1.1.1 -c 1 2>&1`; > /dev/null 2>&1
	if [[ "$check4" != *"received"* || "$check4" != *"transmitted"* || "$check4" == *"timed out"* ]]; then
		echo -e "\033[34mIPv4 is not supported on the current host. Skip...\033[0m";
	else
		# local_ipv4=$(curl --fail -4 -s --max-time 10 api64.ipify.org) > /dev/null 2>&1
		local_ipv4=$(curl --fail -4 -sS -m 10 https://chat.openai.com/cdn-cgi/trace | grep "ip=" | awk -F= '{print $2}') > /dev/null 2>&1
		local_isp4=$(curl --fail -s -4 --max-time 10  --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv4}" | grep organization | cut -f4 -d '"') > /dev/null 2>&1
		#local_asn4=$(curl --fail -s -4 --max-time 10  --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv4}" | grep asn | cut -f8 -d ',' | cut -f2 -d ':') > /dev/null 2>&1
		echo -e "${BLUE}Your IPv4: ${local_ipv4} - ${local_isp4}${PLAIN}"
		iso2_code4=$(curl --fail -4 -sS -m 10 https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}') > /dev/null 2>&1
		if [[ "${SUPPORT_COUNTRY[@]}"  =~ "${iso2_code4}" ]]; 
		then
			echo -e "${GREEN}Your IP supports access to OpenAI. Region: ${iso2_code4}${PLAIN}" 
		else
			echo -e "${RED}Region: ${iso2_code4}. Not support OpenAI at this time.${PLAIN}"
		fi
	fi
	echo "-------------------------------------"
	echo -e "[IPv6]"
	check6=`ping6 -w 10 240c::6666 -c 1 2>&1`; > /dev/null 2>&1
	if [[ "$check6" != *"received"* || "$check6" != *"transmitted"* || "$check6" == *"timed out"* ]]; then
		echo -e "\033[34mIPv6 is not supported on the current host. Skip...\033[0m";    
	else
		# local_ipv6=$(curl --fail -6 -s --max-time 10 api64.ipify.org) > /dev/null 2>&1
		local_ipv6=$(curl --fail -6 -sS -m 10 https://chat.openai.com/cdn-cgi/trace | grep "ip=" | awk -F= '{print $2}') > /dev/null 2>&1
		local_isp6=$(curl --fail -s -6 --max-time 10 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv6}" | grep organization | cut -f4 -d '"') > /dev/null 2>&1
		#local_asn6=$(curl --fail -s -6 --max-time 10  --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv6}" | grep asn | cut -f8 -d ',' | cut -f2 -d ':') > /dev/null 2>&1
		echo -e "${BLUE}Your IPv6: ${local_ipv6} - ${local_isp6}${PLAIN}"
		iso2_code6=$(curl --fail -6 -sS -m 10 https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}') > /dev/null 2>&1
		if [[ "${SUPPORT_COUNTRY[@]}"  =~ "${iso2_code6}" ]]; 
		then
			echo -e "${GREEN}Your IP supports access to OpenAI. Region: ${iso2_code6}${PLAIN}" 
		else
			echo -e "${RED}Region: ${iso2_code6}. Not support OpenAI at this time.${PLAIN}"
		fi
	fi
	echo "-------------------------------------"
fi
