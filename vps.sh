#!/bin/bash
#MIT License
#
#Copyright (c) 2019-2020 johnrosen1

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

#Run me with:

#sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/vps.sh)"

clear

if [[ $(id -u) != 0 ]]; then
	echo Please run this script as root.
	exit 1
fi

if [[ $(uname -m 2> /dev/null) != x86_64 ]]; then
	echo Please run this script on x86_64 machine.
	exit 1
fi

if [[ -f /etc/init.d/aegis ]] || [[ -f /etc/systemd/system/aliyun.service ]]; then
systemctl stop aegis || true
systemctl disable aegis || true
rm -rf /etc/init.d/aegis || true
systemctl stop CmsGoAgent.service || true
systemctl disable CmsGoAgent.service || true
rm -rf /etc/systemd/system/CmsGoAgent.service || true
systemctl stop aliyun || true
systemctl disable aliyun || true
systemctl stop cloud-config || true
systemctl disable cloud-config || true
systemctl stop cloud-final || true
systemctl disable cloud-final || true
systemctl stop cloud-init-local.service || true
systemctl disable cloud-init-local.service || true
systemctl stop cloud-init || true
systemctl disable cloud-init || true
systemctl stop exim4 || true
systemctl disable exim4 || true
systemctl stop apparmor || true
systemctl disable apparmor || true
rm -rf /etc/systemd/system/aliyun.service || true
rm -rf /lib/systemd/system/cloud-config.service || true
rm -rf /lib/systemd/system/cloud-config.target || true
rm -rf /lib/systemd/system/cloud-final.service || true
rm -rf /lib/systemd/system/cloud-init-local.service || true
rm -rf /lib/systemd/system/cloud-init.service || true
systemctl daemon-reload || true
	if [[ $(lsb_release -cs) == stretch ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ oldstable main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable main contrib non-free

deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free

deb http://deb.debian.org/debian-security oldstable/updates main
deb-src http://deb.debian.org/debian-security oldstable/updates main

deb http://ftp.debian.org/debian stretch-backports main
deb-src http://ftp.debian.org/debian stretch-backports main
EOF
fi
	if [[ $(lsb_release -cs) == bionic ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#

###### Ubuntu Main Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
EOF
echo "nameserver 1.1.1.1" > '/etc/resolv.conf' || true
	fi
fi
#######color code############
ERROR="31m"      # Error message
SUCCESS="32m"    # Success message
WARNING="33m"   # Warning message
INFO="36m"     # Info message
LINK="92m"     # Share Link Message
#############################
cipher_server="ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA384"
cipher_client="ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA"
#############################
setlanguage(){
	set +e
	if [[ ! -d /root/.trojan/ ]]; then
		mkdir /root/.trojan/
	fi
	language="$( jq -r '.language' "/root/.trojan/language.json" )"
	while [[ -z $language ]]; do
	export LANGUAGE="C.UTF-8"
	export LANG="C.UTF-8"
	export LC_ALL="C.UTF-8"
	if (whiptail --title "使用中文 or English?" --yes-button "中文" --no-button "English" --yesno "使用中文或英文(Use Chinese or English)?" 8 78); then
	chattr -i /etc/locale.gen
	cat > '/etc/locale.gen' << EOF
zh_TW.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
language="cn"
locale-gen
update-locale
chattr -i /etc/default/locale
	cat > '/etc/default/locale' << EOF
LANGUAGE="zh_TW.UTF-8"
LANG="zh_TW.UTF-8"
LC_ALL="zh_TW.UTF-8"
EOF
	cat > '/root/.trojan/language.json' << EOF
{
  "language": "$language"
}
EOF
	else
	chattr -i /etc/locale.gen
	cat > '/etc/locale.gen' << EOF
zh_TW.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
language="en"
locale-gen
update-locale
chattr -i /etc/default/locale
	cat > '/etc/default/locale' << EOF
LANGUAGE="en_US.UTF-8"
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
EOF
	cat > '/root/.trojan/language.json' << EOF
{
  "language": "$language"
}
EOF
fi
done
if [[ $language == "cn" ]]; then
export LANGUAGE="zh_TW.UTF-8"
export LANG="zh_TW.UTF-8"
export LC_ALL="zh_TW.UTF-8"
	else
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
fi
#chattr +i /etc/locale.gen || true
#dpkg-reconfigure --frontend=noninteractive locales
#chattr +i /etc/default/locale || true
}
#############################
installacme(){
	set +e
	curl -s https://get.acme.sh | sh
	~/.acme.sh/acme.sh --upgrade --auto-upgrade
}
#############################
colorEcho(){
	set +e
	COLOR=$1
	echo -e "\033[${COLOR}${@:2}\033[0m"
}
#########Domain resolve verification###################
isresolved(){
	if [ $# = 2 ]
	then
		myip2=$2
	else
		myip2=`curl -s http://dynamicdns.park-your-domain.com/getip`
	fi
		ips=(`nslookup $1 1.1.1.1 | grep -v 1.1.1.1 | grep Address | cut -d " " -f 2`)
		for ip in "${ips[@]}"
		do
				if [ $ip == $myip ] || [ $ip == $myipv6 ] || [[ $ip == $localip ]] || [ $ip == $myip2 ]
				then
						return 0
				else
						continue
				fi
		done
		return 1
}
########################################################
issuecert(){
	clear
	colorEcho ${INFO} "申请(issuing) let\'s encrypt certificate"
	if [[ -f /etc/trojan/trojan.crt ]] && [[ -f /etc/trojan/trojan.key ]]; then
		TERM=ansi whiptail --title "证书已有，跳过申请" --infobox "证书已有，跳过申请。。。" 8 78
		else
	rm -rf /etc/nginx/sites-available/* &
	rm -rf /etc/nginx/sites-enabled/* &
	rm -rf /etc/nginx/conf.d/*
	touch /etc/nginx/conf.d/default.conf
		cat > '/etc/nginx/conf.d/default.conf' << EOF
server {
	listen       80;
	listen       [::]:80;
	server_name  $domain;
	root   /usr/share/nginx/html;
}
EOF
	nginx -t
	systemctl start nginx || true
	colorEcho ${INFO} "测试证书申请ing(test issuing) let\'s encrypt certificate"
	~/.acme.sh/acme.sh --issue --nginx -d $domain -k ec-256 --force --test --log --reloadcmd "systemctl reload trojan || true && nginx -s reload"
	if [[ $? != 0 ]]; then
	colorEcho ${ERROR} "证书申请测试失败，请检查VPS控制面板防火墙(80 443)是否打开!!!"
	colorEcho ${ERROR} "Domain verification fail,Pleae Open port 80 443 on VPS panel !!!"
	exit 1
	fi 
	clear
	colorEcho ${INFO} "正式证书申请ing(issuing) let\'s encrypt certificate"
	~/.acme.sh/acme.sh --issue --nginx -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload"
	~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/trojan/trojan.crt --keypath /etc/trojan/trojan.key --ecc
	chmod +r /etc/trojan/trojan.key
	fi
}
###############User input################
prasejson(){
	cat > '/root/.trojan/config.json' << EOF
{
  "installed": "1",
  "domain": "$domain",
  "password1": "$password1",
  "password2": "$password2",
  "qbtpath": "$qbtpath",
  "trackerpath": "$trackerpath",
  "trackerstatuspath": "$trackerstatuspath",
  "ariapath": "$ariapath",
  "ariapasswd": "$ariapasswd",
  "filepath": "$filepath",
  "netdatapath": "$netdatapath",
  "path": "$path",
  "alterid": "$alterid",
  "tor_name": "$tor_name",
  "sspath": "$sspath",
  "sspasswd": "$sspasswd",
  "ssmethod": "$ssmethod",
  "install_trojan": "$install_trojan",
  "install_qbt": "$install_qbt",
  "install_tracker": "$install_tracker",
  "install_aria": "$install_aria",
  "install_file": "$install_file",
  "install_netdata": "$install_netdata",
  "install_tor": "$install_tor"
}
EOF
}
################################################
readconfig(){
	domain="$( jq -r '.domain' "/root/.trojan/config.json" )"
    install_trojan="$( jq -r '.install_trojan' "/root/.trojan/config.json" )"
    install_qbt="$( jq -r '.install_qbt' "/root/.trojan/config.json" )"
    install_tracker="$( jq -r '.install_tracker' "/root/.trojan/config.json" )"
    install_aria="$( jq -r '.install_aria' "/root/.trojan/config.json" )"
    install_file="$( jq -r '.install_file' "/root/.trojan/config.json" )"
    install_netdata="$( jq -r '.install_netdata' "/root/.trojan/config.json" )"
    install_tor="$( jq -r '.install_tor' "/root/.trojan/config.json" )"
    password1="$( jq -r '.password1' "/root/.trojan/config.json" )"
    password2="$( jq -r '.password2' "/root/.trojan/config.json" )"
    qbtpath="$( jq -r '.qbtpath' "/root/.trojan/config.json" )"
    trackerpath="$( jq -r '.trackerpath' "/root/.trojan/config.json" )"
    trackerstatuspath="$( jq -r '.username' "/root/.trojan/config.json" )"
    ariapath="$( jq -r '.ariapath' "/root/.trojan/config.json" )"
    ariapasswd="$( jq -r '.ariapasswd' "/root/.trojan/config.json" )"
    filepath="$( jq -r '.filepath' "/root/.trojan/config.json" )"
    netdatapath="$( jq -r '.netdatapath' "/root/.trojan/config.json" )"
    path="$( jq -r '.path' "/root/.trojan/config.json" )"
    alterid="$( jq -r '.alterid' "/root/.trojan/config.json" )"
    tor_name="$( jq -r '.tor_name' "/root/.trojan/config.json" )"
    sspasswd="$( jq -r '.sspasswd' "/root/.trojan/config.json" )"
    ssmethod="$( jq -r '.ssmethod' "/root/.trojan/config.json" )"   
}
####################################
userinput(){
	set +e
if [ ! -f /root/.trojan/config.json ]; then
	cat > '/root/.trojan/config.json' << EOF
{
  "installed": "0"
}
EOF
fi
install_status="$( jq -r '.installed' "/root/.trojan/config.json" )"
colorEcho ${INFO} "被墙检测ing"

ping 114.114.114.114 -c 2 -q

if [[ $? -ne 0 ]]; then
	114status="0"
fi
ping 223.5.5.5 -c 2 -q
if [[ $? -ne 0 ]]; then
	alistatus="0"
fi

curl -s https://tencent.com/ --connect-timeout 10 &> /dev/null

if [[ $? -ne 0 ]]; then
	tencentstatus="0"
fi

if [[ $114status -eq 0 ]] && [[ $alistatus -eq 0 ]] && [[ $tencentstatus -eq 0 ]]; then
	colorEcho ${ERROR} "你的ip被墙了，滚蛋！"
	exit 1
fi

clear
if [[ $install_status == 1 ]]; then
if (whiptail --title "Installed Detected" --defaultno --yesno "检测到已安装，是否继续?" 8 78); then
    if (whiptail --title "Installed Detected" --defaultno --yesno "检测到已安装，是否重新设置具体参数?" 8 78); then
    :
    else
    readconfig
    fi
    else
    advancedMenu
    fi
fi

whiptail --clear --ok-button "吾意已決 立即執行" --backtitle "hi 请谨慎选择(Please choose carefully)" --title "User choose" --checklist --separate-output --nocancel "請按空格來選擇: !!! 默認沒選中的都是不推薦的 !!!
若不確定，請保持默認配置並回車" 25 75 17 \
"back" "返回上级菜单(Back to main menu)" off \
"系统" "System" on  \
"1" "系统升级(System Upgrade)" on \
"2" "启用BBR | TCP效能优化(TCP-Turbo)" on \
"3" "安裝BBRPLUS" off \
"代理" "Proxy" on  \
"4" "安裝Trojan-GFW" on \
"5" "安裝Dnscrypt-proxy | DNS加密(dns encryption)" on \
"6" "安裝Tor-Relay" off \
"下载" "Download" on  \
"7" "安裝Qbittorrent | BT客户端(Bittorrent Client)" on \
"8" "安裝Bittorrent-Tracker" on \
"9" "安裝Aria2" on \
"10" "安裝Filebrowser | 网盘(File manager)" on \
"状态" "Status" on  \
"11" "安裝Netdata | 服务器状态监控(Server status monitor)" on \
"其他" "Others" on  \
"12" "仅启用TLS1.3(Enable TLS1.3 only)" off 2>results

while read choice
do
	case $choice in
		back) 
		advancedMenu
		break
		;;
		1) 
		system_upgrade=1
		;;
		2) 
		install_bbr=1
		;;
		3)
		install_bbrplus=1
		;;
		4)
		install_trojan=1
		;;
		5) 
		dnsmasq_install=1
		;;
		6)
		install_tor=1
		;;
		7)
		install_qbt=1
		;;
		8)
		install_tracker=1
		;;
		9)
		install_aria=1
		;;
		10)
		install_file=1
		;;
		11)
		install_netdata=1
		;;
		12) 
		tls13only=1
		;;
		*)
		;;
	esac
done < results
####################################
if [[ $system_upgrade = 1 ]]; then
	if [[ $(lsb_release -cs) == stretch ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Debian 10?" 8 78); then
			debian10_install=1
		else
			debian10_install=0
		fi
	fi
	if [[ $(lsb_release -cs) == jessie ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Debian 9?" 8 78); then
			debian9_install=1
		else
			debian9_install=0
		fi
	fi
	if [[ $(lsb_release -cs) == xenial ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Ubuntu 18.04?" 8 78); then
			ubuntu18_install=1
		else
			ubuntu18_install=0
		fi
	fi
fi
#####################################
while [[ -z $domain ]]; do
domain=$(whiptail --inputbox --nocancel "快輸入你的域名並按回車" 8 78 --title "Domain input" 3>&1 1>&2 2>&3)
done
if [[ $install_trojan = 1 ]]; then
	while [[ -z $password1 ]]; do
password1=$(whiptail --passwordbox --nocancel "快輸入你想要的Trojan-GFW密碼一併按回車(若不確定，請直接回車，会随机生成)" 8 78 --title "password1 input" 3>&1 1>&2 2>&3)
if [[ $password1 == "" ]]; then
	password1=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo '' )
	fi
done
while [[ -z $password2 ]]; do
password2=$(whiptail --passwordbox --nocancel "快輸入想要的Trojan-GFW密碼二並按回車(若不確定，請直接回車，会随机生成)" 8 78 --title "password2 input" 3>&1 1>&2 2>&3)
if [[ $password2 == "" ]]; then
	password2=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo '' )
	fi
done
fi
###################################
	if [[ $install_qbt = 1 ]]; then
		while [[ -z $qbtpath ]]; do
		qbtpath=$(whiptail --inputbox --nocancel "快输入你的想要的Qbittorrent路径并按回车" 8 78 /qbt/ --title "Qbittorrent path input" 3>&1 1>&2 2>&3)
		done
	fi
#####################################
	if [[ $install_tracker = 1 ]]; then
		while [[ -z $trackerpath ]]; do
		trackerpath=$(whiptail --inputbox --nocancel "快输入你的想要的Bittorrent-Tracker路径并按回车" 8 78 /announce --title "Bittorrent-Tracker path input" 3>&1 1>&2 2>&3)
		done
		while [[ -z $trackerstatuspath ]]; do
		trackerstatuspath=$(whiptail --inputbox --nocancel "快输入你的想要的Bittorrent-Tracker状态路径并按回车" 8 78 /status --title "Bittorrent-Tracker status path input" 3>&1 1>&2 2>&3)
		done
	fi
####################################
	if [[ $install_aria = 1 ]]; then
		while [[ -z $ariapath ]]; do
		ariapath=$(whiptail --inputbox --nocancel "快输入你的想要的Aria2 RPC路径并按回车" 8 78 /jsonrpc --title "Aria2 path input" 3>&1 1>&2 2>&3)
		done
		while [[ -z $ariapasswd ]]; do
		ariapasswd=$(whiptail --passwordbox --nocancel "快输入你的想要的Aria2 rpc token并按回车" 8 78 --title "Aria2 rpc token input" 3>&1 1>&2 2>&3)
		if [[ $ariapasswd == "" ]]; then
		ariapasswd="123456789"
		fi
		done
	fi
####################################
	if [[ $install_file = 1 ]]; then
		while [[ -z $filepath ]]; do
		filepath=$(whiptail --inputbox --nocancel "快输入你的想要的Filebrowser路径并按回车" 8 78 /files/ --title "Filebrowser path input" 3>&1 1>&2 2>&3)
		done
	fi
####################################
	if [[ $install_netdata = 1 ]]; then
		while [[ -z $netdatapath ]]; do
		netdatapath=$(whiptail --inputbox --nocancel "快输入你的想要的Netdata路径并按回车" 8 78 /netdata/ --title "Netdata path input" 3>&1 1>&2 2>&3)
		done
	fi
####################################
	if [[ $install_tor = 1 ]]; then
		while [[ -z $tor_name ]]; do
		tor_name=$(whiptail --inputbox --nocancel "快輸入想要的tor nickname並按回車" 8 78 --title "tor nickname input" 3>&1 1>&2 2>&3)
		if [[ $tor_name == "" ]]; then
		tor_name="myrelay"
	fi
	done
	fi
####################################
mkdir /etc/trojan || true
	if [ -f /etc/trojan/*.crt ]; then
		mv /etc/trojan/*.crt /etc/trojan/trojan.crt || true
	fi
	if [ -f /etc/trojan/*.key ]; then
		mv /etc/trojan/*.key /etc/trojan/trojan.key || true
	fi
####################################
if [[ -f /etc/trojan/trojan.crt ]] && [[ -f /etc/trojan/trojan.key ]]; then
		TERM=ansi whiptail --title "证书已有，跳过申请" --infobox "证书已有，跳过申请。。。" 8 78
		else		
	if (whiptail --title "api" --yesno --defaultno "使用 (use) api申请证书(to issue certificate)?推荐，可用于申请wildcard证书" 8 78); then
    dns_api=1
    APIOPTION=$(whiptail --nocancel --clear --ok-button "吾意已決 立即執行" --title "API choose" --menu --separate-output "域名(domain)API：請按方向键來選擇(Use Arrow key to choose)" 15 78 6 \
"1" "Cloudflare" \
"2" "Namesilo" \
"3" "Aliyun" \
"4" "DNSPod.cn" \
"5" "CloudXNS.com" \
"back" "返回"  3>&1 1>&2 2>&3)

    case $APIOPTION in
        1)
        while [[ -z $CF_Key ]] || [[ -z $CF_Email ]]; do
        CF_Key=$(whiptail --passwordbox --nocancel "https://dash.cloudflare.com/profile/api-tokens，快輸入你CF Global Key併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
        CF_Email=$(whiptail --inputbox --nocancel "https://dash.cloudflare.com/profile，快輸入你CF_Email併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
        done
        export CF_Key="$CF_Key"
        export CF_Email="$CF_Email"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_cf -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        2)
        while [[ -z $Namesilo_Key ]]; do
        Namesilo_Key=$(whiptail --passwordbox --nocancel "https://www.namesilo.com/account_api.php，快輸入你的Namesilo_Key併按回車" 8 78 --title "Namesilo_Key input" 3>&1 1>&2 2>&3)
        done
        export Namesilo_Key="$Namesilo_Key"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_namesilo --dnssleep 900 -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        3)
        while [[ -z $Ali_Key ]] || [[ -z $Ali_Secret ]]; do
        Ali_Key=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Key併按回車" 8 78 --title "Ali_Key input" 3>&1 1>&2 2>&3)
        Ali_Secret=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Secret併按回車" 8 78 --title "Ali_Secret input" 3>&1 1>&2 2>&3)
        done
        export Ali_Key="$Ali_Key"
        export Ali_Secret="$Ali_Secret"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_ali -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        4)
        while [[ -z $DP_Id ]] || [[ -z $DP_Key ]]; do
        DP_Id=$(whiptail --passwordbox --nocancel "DNSPod.cn，快輸入你的DP_Id併按回車" 8 78 --title "DP_Id input" 3>&1 1>&2 2>&3)
        DP_Key=$(whiptail --passwordbox --nocancel "DNSPod.cn，快輸入你的DP_Key併按回車" 8 78 --title "DP_Key input" 3>&1 1>&2 2>&3)
        done
        export DP_Id="$DP_Id"
        export DP_Key="$DP_Key"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_dp -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        5)
        while [[ -z $CX_Key ]] || [[ -z $CX_Secret ]]; do
        CX_Key=$(whiptail --passwordbox --nocancel "CloudXNS.com，快輸入你的CX_Key併按回車" 8 78 --title "CX_Key input" 3>&1 1>&2 2>&3)
        CX_Secret=$(whiptail --passwordbox --nocancel "CloudXNS.com，快輸入你的CX_Secret併按回車" 8 78 --title "CX_Secret input" 3>&1 1>&2 2>&3)
        done
        export CX_Key="$CX_Key"
        export CX_Secret="$CX_Secret"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_cx -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        back) 
		userinput
		break
		;;
        *)
        ;;
    esac
    if [[ $? != 0 ]]; then
	colorEcho ${ERROR} "证书申请失败，请检查域名是否正确"
	colorEcho ${ERROR} "certificate issue fail,Pleae enter correct domain"
	exit 1
	fi 
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/trojan/trojan.crt --keypath /etc/trojan/trojan.key --ecc
    chmod +r /etc/trojan/trojan.key
    fi
fi
}
###############OS detect####################
osdist(){

set -e
colorEcho ${INFO} "初始化中(initializing)"
 if cat /etc/*release | grep ^NAME | grep -q CentOS; then
	dist=centos
	pack="yum -y -q"
	yum update -y
	yum install -y epel-release
	yum install sudo newt curl e2fsprogs jq redhat-lsb-core lsof -y -q || true
 elif cat /etc/*release | grep ^NAME | grep -q Red; then
	dist=centos
	pack="yum -y -q"
	yum update -y
	yum install -y epel-release
	yum install sudo newt curl e2fsprogs jq redhat-lsb-core lsof -y -q || true
 elif cat /etc/*release | grep ^NAME | grep -q Fedora; then
	dist=centos
	pack="yum -y -q"
	yum update -y
	yum install -y epel-release
	yum install sudo newt curl e2fsprogs jq redhat-lsb-core lsof -y -q || true
 elif cat /etc/*release | grep ^NAME | grep -q Ubuntu; then
	dist=ubuntu
	pack="apt-get -y -qq"
	apt-get update -q
	export DEBIAN_FRONTEND=noninteractive
	apt-get install sudo whiptail curl locales lsb-release e2fsprogs jq lsof -y -qq || true
 elif cat /etc/*release | grep ^NAME | grep -q Debian; then
	dist=debian
	pack="apt-get -y -qq"
	apt-get update -q
	export DEBIAN_FRONTEND=noninteractive
	apt-get install sudo whiptail curl locales lsb-release e2fsprogs jq lsof -y -qq || true
 else
	TERM=ansi whiptail --title "OS not SUPPORTED" --infobox "OS NOT SUPPORTED!" 8 78
		exit 1;
 fi
}
##############Upgrade system optional########
upgradesystem(){
	set +e
	if [[ $dist = centos ]]; then
		yum upgrade -y
 elif [[ $dist = ubuntu ]]; then
	export UBUNTU_FRONTEND=noninteractive
	if [[ $ubuntu18_install = 1 ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#

###### Ubuntu Main Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
EOF
	apt-get update
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	fi
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq -y'
	apt-get autoremove -qq -y
	clear
 elif [[ $dist = debian ]]; then
	export DEBIAN_FRONTEND=noninteractive 
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq -y'
	if [[ $debian10_install = 1 ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ stable main contrib non-free
deb-src http://deb.debian.org/debian/ stable main contrib non-free

deb http://deb.debian.org/debian/ stable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ stable-updates main contrib non-free

deb http://deb.debian.org/debian-security stable/updates main
deb-src http://deb.debian.org/debian-security stable/updates main

deb http://ftp.debian.org/debian buster-backports main
deb-src http://ftp.debian.org/debian buster-backports main
EOF
	apt-get update
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	clear
	fi
	if [[ $debian9_install = 1 ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ oldstable main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable main contrib non-free

deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free

deb http://deb.debian.org/debian-security oldstable/updates main
deb-src http://deb.debian.org/debian-security oldstable/updates main

deb http://ftp.debian.org/debian stretch-backports main
deb-src http://ftp.debian.org/debian stretch-backports main
EOF
	apt-get update
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	fi
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get autoremove -qq -y'
	clear
 else
	clear
	TERM=ansi whiptail --title "error can't upgrade system" --infobox "error can't upgrade system" 8 78
	exit 1;
 fi
}
##########install dependencies#############
installdependency(){
	colorEcho ${INFO} "Updating system"
	$pack update
	if [[ $install_status == 0 ]]; then
		caddystatus=$(systemctl is-active caddy)
		if [[ $caddystatus == active ]]; then
			systemctl stop caddy
			systemctl disable caddy
		fi
		apache2status=$(systemctl is-active apache2)
		if [[ $caddystatus == active ]]; then
			systemctl stop apache2
			systemctl disable apache2
		fi
		httpdstatus=$(systemctl is-active httpd)
		if [[ $httpdstatus == active ]]; then
			systemctl stop httpd
			systemctl disable httpd
		fi
		(echo >/dev/tcp/localhost/80) &>/dev/null && echo "TCP port 80 open" && kill $(lsof -t -i:80) || echo "Moving on"
		(echo >/dev/tcp/localhost/80) &>/dev/null && echo "TCP port 443 open" && kill $(lsof -t -i:443) || echo "Moving on"
	fi
###########################################
	clear
	colorEcho ${INFO} "安装所有必备软件(Install all necessary Software)"
	if [[ $dist = centos ]]; then
		yum install -y -q sudo curl wget gnupg python3-qrcode unzip bind-utils epel-release chrony systemd dbus xz cron socat || true
 elif [[ $dist = ubuntu ]] || [[ $dist = debian ]]; then
	apt-get install sudo curl xz-utils wget apt-transport-https gnupg dnsutils lsb-release python-pil unzip resolvconf ntpdate systemd dbus ca-certificates locales iptables software-properties-common cron socat -qq -y
	if [[ $(lsb_release -cs) == xenial ]] || [[ $(lsb_release -cs) == trusty ]] || [[ $(lsb_release -cs) == jessie ]]; then
		TERM=ansi whiptail --title "Skipping generating QR code!" --infobox "你的操作系统不支持 python3-qrcode,Skipping generating QR code!" 8 78
		else
		apt-get install python3-qrcode -qq -y
	fi
 else
	clear
	TERM=ansi whiptail --title "error can't install dependency" --infobox "error can't install dependency" 8 78
	exit 1;
 fi
 clear
#############################################
if [[ -f /etc/trojan/trojan.crt ]] || [[ $dns_api == 1 ]]; then
	:
	else
	if isresolved $domain
	then
	:
	else
	clear
	whiptail --title "Domain verification fail" --msgbox --scrolltext "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!" 8 78
	if (whiptail --title "api" --yesno "使用 (use) api申请证书(to issue certificate)替代?" 8 78); then
	domain=$(whiptail --inputbox --nocancel "快輸入你的域名並按回車" 8 78 --title "Domain input" 3>&1 1>&2 2>&3)
	while [[ -z $domain ]]; do
domain=$(whiptail --inputbox --nocancel "快輸入你的域名並按回車" 8 78 --title "Domain input" 3>&1 1>&2 2>&3)
done
    dns_api=1
    APIOPTION=$(whiptail --nocancel --clear --ok-button "吾意已決 立即執行" --title "API choose" --menu --separate-output "域名(domain)API：請按方向键來選擇(Use Arrow key to choose)" 15 78 6 \
"1" "Cloudflare" \
"2" "Namesilo" \
"3" "Aliyun" \
"4" "DNSPod.cn" \
"5" "CloudXNS.com" \
"back" "返回"  3>&1 1>&2 2>&3)

    case $APIOPTION in
        1)
        while [[ -z $CF_Key ]] || [[ -z $CF_Email ]]; do
        CF_Key=$(whiptail --passwordbox --nocancel "https://dash.cloudflare.com/profile/api-tokens ，快輸入你CF Global Key併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
        CF_Email=$(whiptail --inputbox --nocancel "https://dash.cloudflare.com/profile，快輸入你CF_Email併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
        done
        export CF_Key="$CF_Key"
        export CF_Email="$CF_Email"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_cf -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        2)
        while [[ -z $Namesilo_Key ]]; do
        Namesilo_Key=$(whiptail --passwordbox --nocancel "https://www.namesilo.com/account_api.php，快輸入你的Namesilo_Key併按回車" 8 78 --title "Namesilo_Key input" 3>&1 1>&2 2>&3)
        done
        export Namesilo_Key="$Namesilo_Key"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_namesilo --dnssleep 900 -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        3)
        while [[ -z $Ali_Key ]] || [[ -z $Ali_Secret ]]; do
        Ali_Key=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Key併按回車" 8 78 --title "Ali_Key input" 3>&1 1>&2 2>&3)
        Ali_Secret=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Secret併按回車" 8 78 --title "Ali_Secret input" 3>&1 1>&2 2>&3)
        done
        export Ali_Key="$Ali_Key"
        export Ali_Secret="$Ali_Secret"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_ali -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        4)
        while [[ -z $DP_Id ]] || [[ -z $DP_Key ]]; do
        DP_Id=$(whiptail --passwordbox --nocancel "DNSPod.cn，快輸入你的DP_Id併按回車" 8 78 --title "DP_Id input" 3>&1 1>&2 2>&3)
        DP_Key=$(whiptail --passwordbox --nocancel "DNSPod.cn，快輸入你的DP_Key併按回車" 8 78 --title "DP_Key input" 3>&1 1>&2 2>&3)
        done
        export DP_Id="$DP_Id"
        export DP_Key="$DP_Key"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_dp -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        5)
        while [[ -z $CX_Key ]] || [[ -z $CX_Secret ]]; do
        CX_Key=$(whiptail --passwordbox --nocancel "CloudXNS.com，快輸入你的CX_Key併按回車" 8 78 --title "CX_Key input" 3>&1 1>&2 2>&3)
        CX_Secret=$(whiptail --passwordbox --nocancel "CloudXNS.com，快輸入你的CX_Secret併按回車" 8 78 --title "CX_Secret input" 3>&1 1>&2 2>&3)
        done
        export CX_Key="$CX_Key"
        export CX_Secret="$CX_Secret"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_cx -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan || true && nginx -s reload || true"
        ;;
        back) 
		colorEcho ${ERROR} "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!"
		colorEcho ${ERROR} "Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!"
    	exit 1
		break
		;;
        *)
        ;;
    esac
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/trojan/trojan.crt --keypath /etc/trojan/trojan.key --ecc
    chmod +r /etc/trojan/trojan.key
    else
    colorEcho ${ERROR} "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!"
	colorEcho ${ERROR} "Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!"
    exit 1
    fi
	clear
	fi  
fi
#############################################
if [[ $system_upgrade = 1 ]]; then
upgradesystem
fi
clear
#############################################
if [[ $tls13only = 1 ]]; then
cipher_server="TLS_AES_128_GCM_SHA256"
fi
#####################################################
	if [[ -f /etc/apt/sources.list.d/nginx.list ]]; then
		:
		else
		clear
		colorEcho ${INFO} "安装Nginx(Install Nginx ing)"
	if [[ $dist = centos ]]; then
	yum install nginx -y -q
	systemctl stop nginx || true
 elif [[ $dist = debian ]] || [[ $dist = ubuntu ]]; then
 	curl -LO --progress-bar https://nginx.org/keys/nginx_signing.key
	apt-key add nginx_signing.key
	rm -rf nginx_signing.key
	touch /etc/apt/sources.list.d/nginx.list
	cat > '/etc/apt/sources.list.d/nginx.list' << EOF
deb https://nginx.org/packages/mainline/$dist/ $(lsb_release -cs) nginx
deb-src https://nginx.org/packages/mainline/$dist/ $(lsb_release -cs) nginx
EOF
	apt-get remove nginx-common -qq -y
	apt-get update -qq
	apt-get install nginx -qq -y
 else
	clear
	TERM=ansi whiptail --title "error can't install nginx" --infobox "error can't install nginx" 8 78
		exit 1;
 fi
fi
	cat > '/lib/systemd/system/nginx.service' << EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
if [[ $dist = centos ]]; then
	curl -LO --progress-bar https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/nginx_centos
	cp -f nginx_centos /usr/sbin/nginx
	rm nginx_centos
	mkdir /var/cache/nginx/ || true
	chmod +x /usr/sbin/nginx || true
fi
		cat > '/etc/nginx/nginx.conf' << EOF
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
	worker_connections 51200;
	use epoll;
	multi_accept on;
}

http {
	aio threads;
	charset UTF-8;
	tcp_nodelay on;
	tcp_nopush on;
	server_tokens off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	access_log /var/log/nginx/access.log;

	log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
		'\$status $body_bytes_sent "\$http_referer" '
		'"\$http_user_agent" "\$http_x_forwarded_for"';

	sendfile on;
	gzip on;
	gzip_comp_level 9;

	include /etc/nginx/conf.d/*.conf;
	client_max_body_size 10G;
}
EOF
clear
#############################################
if [[ $install_qbt = 1 ]]; then
	if [[ -f /usr/bin/qbittorrent-nox ]]; then
		cat > '/etc/systemd/system/qbittorrent.service' << EOF
[Unit]
Description=qBittorrent Daemon Service
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
# if you have systemd >= 240, you probably want to use Type=exec instead
Type=simple
User=root
ExecStart=/usr/bin/qbittorrent-nox
TimeoutStopSec=infinity
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF
	else
	clear
	colorEcho ${INFO} "安装Qbittorrent(Install Qbittorrent ing)"
	if [[ $dist = centos ]]; then
	yum install -y -q epel-release
	yum update -y -q
	yum install qbittorrent-nox -y -q || true
 elif [[ $dist = ubuntu ]]; then
	export DEBIAN_FRONTEND=noninteractive
	add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
	apt-get install qbittorrent-nox -qq -y
 elif [[ $dist = debian ]]; then
	export DEBIAN_FRONTEND=noninteractive 
	apt-get install qbittorrent-nox -qq -y
 else
	clear
	TERM=ansi whiptail --title "error can't install qbittorrent-nox" --infobox "error can't install qbittorrent-nox" 8 78
		exit 1;
 fi
	cat > '/etc/systemd/system/qbittorrent.service' << EOF
[Unit]
Description=qBittorrent Daemon Service
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
# if you have systemd >= 240, you probably want to use Type=exec instead
Type=simple
User=root
ExecStart=/usr/bin/qbittorrent-nox
TimeoutStopSec=infinity
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF
mkdir /usr/share/nginx/qbt/ || true
chmod 755 /usr/share/nginx/qbt/ || true
fi
fi
clear
#############################################
if [[ $install_tracker = 1 ]]; then
	if [[ -f /usr/bin/bittorrent-tracker ]]; then
		:
		else
		clear
		colorEcho ${INFO} "安装Bittorrent-tracker(Install bittorrent-tracker ing)"
	if [[ $dist = centos ]]; then
		curl -sL https://rpm.nodesource.com/setup_13.x | bash -
		yum install -y -q nodejs
 elif [[ $dist = ubuntu ]]; then
	export DEBIAN_FRONTEND=noninteractive
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
	apt-get install -qq -y nodejs
 elif [[ $dist = debian ]]; then
	export DEBIAN_FRONTEND=noninteractive 
	curl -sL https://deb.nodesource.com/setup_13.x | bash -
	apt-get install -qq -y nodejs
 else
	clear
	TERM=ansi whiptail --title "error can't install qbittorrent-nox" --infobox "error can't install qbittorrent-nox" 8 78
		exit 1;
 fi
 npm install -g bittorrent-tracker --quiet
			cat > '/etc/systemd/system/tracker.service' << EOF
[Unit]
Description=Bittorrent-Tracker Daemon Service
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
# if you have systemd >= 240, you probably want to use Type=exec instead
Type=simple
User=root
RemainAfterExit=yes
ExecStart=/usr/bin/bittorrent-tracker --trust-proxy
TimeoutStopSec=infinity
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF
fi
fi
clear
#############################################
if [[ $install_file = 1 ]]; then
	if [[ -f /usr/local/bin/filebrowser ]]; then
		:
		else
		clear
		colorEcho ${INFO} "安装Filebrowser(Install Filebrowser ing)"
	if [[ $dist = centos ]]; then
	curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash || true
 elif [[ $dist = ubuntu ]] || [[ $dist = debian ]]; then
	export DEBIAN_FRONTEND=noninteractive
	curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
 else
	clear
	TERM=ansi whiptail --title "error can't install filebrowser" --infobox "error can't install filebrowser" 8 78
		exit 1;
 fi
	cat > '/etc/systemd/system/filebrowser.service' << EOF
[Unit]
Description=filebrowser browser
After=network.target

[Service]
User=root
Group=root
ExecStart=/usr/local/bin/filebrowser -r /usr/share/nginx/ -d /etc/filebrowser/database.db -b $filepath -p 8081
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
RestartSec=1s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
mkdir /etc/filebrowser/ || true
touch /etc/filebrowser/database.db || true
fi
fi
clear
#############################################
if [[ $install_aria = 1 ]]; then
	ariaport=$(shuf -i 20000-60000 -n 1)
	trackers_list=$(wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt |awk NF|sed ":a;N;s/\n/,/g;ta")
	if [[ -f /usr/local/bin/aria2c ]]; then
		cat > '/etc/systemd/system/aria2.service' << EOF
[Unit]
Description=Aria2c download manager
Requires=network.target
After=network.target

[Service]
Type=forking
User=root
RemainAfterExit=yes
ExecStart=/usr/local/bin/aria2c --conf-path=/etc/aria2.conf --daemon
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
RestartSec=3s
Restart=on-failure
		
[Install]
WantedBy=multi-user.target
EOF
	cat > '/etc/aria2.conf' << EOF
log-level=info
log=/var/log/aria2.log
rlimit-nofile=51200
rpc-secure=false
continue=true
max-concurrent-downloads=50
#split=16
min-split-size=10M
max-connection-per-server=16
lowest-speed-limit=0
disable-ipv6=false
max-tries=0
#retry-wait=0
input-file=/usr/local/bin/aria2.session
save-session=/usr/local/bin/aria2.session
save-session-interval=60
force-save=true
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=false
event-poll=epoll
rpc-listen-port=6800
rpc-secret=$ariapasswd
bt-tracker=$trackers_list
follow-torrent=true
listen-port=$ariaport
enable-dht=true
enable-dht6=true
bt-enable-lpd=true
enable-peer-exchange=true
seed-ratio=0
bt-hash-check-seed=true
bt-seed-unverified=true
bt-save-metadata=true
bt-require-crypto=true
bt-force-encryption=true
dir=/usr/share/nginx/aria2/
file-allocation=none
disk-cache=64M
EOF
	else
	clear
	colorEcho ${INFO} "安装aria2(Install aria2 ing)"
	if [[ $dist = centos ]]; then
		yum install -y -q nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev libssl-dev libuv1-dev || true
		curl -LO --progress-bar https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/aria2c_centos.xz
		xz --decompress aria2c_centos.xz
		cp aria2c_centos /usr/local/bin/aria2c
		chmod +x /usr/local/bin/aria2c
		rm aria2c_centos
	else
		apt-get install nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev libssl-dev libuv1-dev -qq -y
		curl -LO --progress-bar https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/aria2c.xz
		xz --decompress aria2c.xz
		cp aria2c /usr/local/bin/aria2c
		chmod +x /usr/local/bin/aria2c
		rm aria2c
		#apt-get install build-essential nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libssl-dev autoconf automake autotools-dev autopoint libtool libuv1-dev libcppunit-dev -qq -y
		#wget https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0.tar.xz -q
		#cd aria2-1.35.0
		#./configure --without-gnutls --with-openssl
		#make -j $(nproc --all)
		#make install
		#apt remove build-essential autoconf automake autotools-dev autopoint libtool -qq -y
		apt-get autoremove -qq -y
	fi
	touch /usr/local/bin/aria2.session
	mkdir /usr/share/nginx/aria2/
	chmod 755 /usr/share/nginx/aria2/
	cd ..
	rm -rf aria2-1.35.0
	cat > '/etc/systemd/system/aria2.service' << EOF
[Unit]
Description=Aria2c download manager
Requires=network.target
After=network.target
		
[Service]
Type=forking
User=root
RemainAfterExit=yes
ExecStart=/usr/local/bin/aria2c --conf-path=/etc/aria2.conf --daemon
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
RestartSec=3s
Restart=on-failure
		
[Install]
WantedBy=multi-user.target
EOF
	cat > '/etc/aria2.conf' << EOF
log-level=info
log=/var/log/aria2.log
rlimit-nofile=51200
rpc-secure=false
continue=true
max-concurrent-downloads=50
#split=16
min-split-size=10M
max-connection-per-server=16
lowest-speed-limit=0
disable-ipv6=false
max-tries=0
#retry-wait=0
input-file=/usr/local/bin/aria2.session
save-session=/usr/local/bin/aria2.session
save-session-interval=60
force-save=true
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=false
event-poll=epoll
rpc-listen-port=6800
rpc-secret=$ariapasswd
bt-tracker=$trackers_list
follow-torrent=true
listen-port=$ariaport
enable-dht=true
enable-dht6=true
bt-enable-lpd=true
enable-peer-exchange=true
seed-ratio=0
bt-hash-check-seed=true
bt-seed-unverified=true
bt-save-metadata=true
bt-require-crypto=true
bt-force-encryption=true
dir=/usr/share/nginx/aria2/
file-allocation=none
disk-cache=64M
EOF
	fi
fi
#############################################
if [[ $dnsmasq_install = 1 ]]; then
	if [[ -f /usr/sbin/dnscrypt-proxy ]]; then
		:
	else
	clear
	colorEcho ${INFO} "安装dnscrypt-proxy(Install dnscrypt-proxy ing)"
	dnsmasqstatus=$(systemctl is-active dnsmasq)
		if [[ $dnsmasqdstatus == active ]]; then
			systemctl disable dnsmasq
		fi
	#(echo >/dev/tcp/localhost/80) &>/dev/null && echo "TCP port 53 open" && kill $(lsof -t -i:53) || echo "Moving on"
	curl -LO --progress-bar https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.0.39/dnscrypt-proxy-linux_x86_64-2.0.39.tar.gz
	#wget https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.0.39/dnscrypt-proxy-linux_x86_64-2.0.39.tar.gz
	tar -xvf dnscrypt-proxy-linux_x86_64-2.0.39.tar.gz
	rm dnscrypt-proxy-linux_x86_64-2.0.39.tar.gz
	cd linux-x86_64
	cp -f dnscrypt-proxy /usr/sbin/dnscrypt-proxy
	chmod +x /usr/sbin/dnscrypt-proxy
	cd ..
	rm -rf linux-x86_64
	cat > '/etc/blacklist.txt' << EOF

###########################
#        Blacklist        #
###########################

## Rules for name-based query blocking, one per line
##
## Example of valid patterns:
##
## ads.*         | matches anything with an "ads." prefix
## *.example.com | matches example.com and all names within that zone such as www.example.com
## example.com   | identical to the above
## =example.com  | block example.com but not *.example.com
## *sex*         | matches any name containing that substring
## ads[0-9]*     | matches "ads" followed by one or more digits
## ads*.example* | *, ? and [] can be used anywhere, but prefixes/suffixes are faster

#ad.*
#ads.*

####Block 360####
*.cn
*.360.com
*.360jie.com
*.360kan.com
*.360taojin.com
*.i360mall.com
*.qhimg.com
*.qhmsg.com
*.qhres.com
*.qihoo.com
*.nicaifu.com
*.so.com
####Block Xunlei###
*.xunlei.com
####Block Baidu###
*baidu.*
*.bdimg.com
*.bdstatic.com
*.duapps.com
*.quyaoya.com
*.tiebaimg.com
*.xiaodutv.com
*.sina.com
EOF
ipv6_true="false"
block_ipv6="true"
if [[ -n $myipv6 ]]; then
	ping -6 ipv6.google.com -c 2
	if [[ $? -eq 0 ]]; then
		ipv6_true="true"
		block_ipv6="false"
	fi
fi
    cat > '/etc/dnscrypt-proxy.toml' << EOF
listen_addresses = ['127.0.0.1:53']
max_clients = 250
ipv4_servers = true
ipv6_servers = $ipv6_true
dnscrypt_servers = true
doh_servers = true
require_dnssec = false
require_nolog = true
require_nofilter = true
disabled_server_names = ['cisco', 'cisco-ipv6', 'cisco-familyshield']
force_tcp = false
timeout = 5000
keepalive = 30
lb_estimator = true
log_level = 2
log_file = '/var/log/dnscrypt-proxy.log'
cert_refresh_delay = 720
tls_disable_session_tickets = true
#tls_cipher_suite = [4865]
fallback_resolvers = ['1.1.1.1:53', '8.8.8.8:53']
ignore_system_dns = true
netprobe_timeout = 60
netprobe_address = '1.1.1.1:53'
# Maximum log files size in MB - Set to 0 for unlimited.
log_files_max_size = 0
# How long to keep backup files, in days
log_files_max_age = 7
# Maximum log files backups to keep (or 0 to keep all backups)
log_files_max_backups = 0
block_ipv6 = $block_ipv6
## Immediately respond to A and AAAA queries for host names without a domain name
block_unqualified = true
## Immediately respond to queries for local zones instead of leaking them to
## upstream resolvers (always causing errors or timeouts).
block_undelegated = true
## TTL for synthetic responses sent when a request has been blocked (due to
## IPv6 or blacklists).
reject_ttl = 600
cache = true
cache_size = 4096
cache_min_ttl = 2400
cache_max_ttl = 86400
cache_neg_min_ttl = 60
cache_neg_max_ttl = 600

[query_log]

  file = '/var/log/query.log'
  format = 'tsv'

[blacklist]

  blacklist_file = '/etc/blacklist.txt'

[sources]

  ## An example of a remote source from https://github.com/DNSCrypt/dnscrypt-resolvers

  [sources.'public-resolvers']
  urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md']
  cache_file = 'public-resolvers.md'
  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
  prefix = ''

  [sources.'opennic']
  urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/opennic.md', 'https://download.dnscrypt.info/dnscrypt-resolvers/v2/opennic.md']
  cache_file = 'opennic.md'
  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
  prefix = ''

  ## Anonymized DNS relays

  [sources.'relays']
  urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/relays.md', 'https://download.dnscrypt.info/resolvers-list/v2/relays.md']
  cache_file = 'relays.md'
  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
  refresh_delay = 72
  prefix = ''
EOF
	cat > '/lib/systemd/system/dnscrypt-proxy.service' << EOF
[Unit]
Description=DNSCrypt client proxy
Documentation=https://github.com/DNSCrypt/dnscrypt-proxy/wiki
After=network.target

[Service]
Type=simple
ExecStart=/usr/sbin/dnscrypt-proxy -config /etc/dnscrypt-proxy.toml
User=root
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
systemctl enable dnscrypt-proxy
	fi
fi
clear
#############################################
if [[ $install_tor = 1 ]]; then
	clear
	if [[ -f /usr/bin/tor ]]; then
		:
		else
		colorEcho ${INFO} "安装Tor(Install Tor Relay ing)"
	if [[ $dist = centos ]]; then
		yum install -y -q epel-release || true
		yum install -y -q tor  || true
 elif [[ $dist = ubuntu ]] || [[ $dist = debian ]]; then
	export DEBIAN_FRONTEND=noninteractive
	touch /etc/apt/sources.list.d/tor.list
	cat > '/etc/apt/sources.list.d/tor.list' << EOF
deb https://deb.torproject.org/torproject.org $(lsb_release -cs) main
deb-src https://deb.torproject.org/torproject.org $(lsb_release -cs) main
EOF
	curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
	gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
	apt-get update
	apt-get install deb.torproject.org-keyring tor tor-arm tor-geoipdb -qq -y || true
	service tor stop
 else
	clear
	TERM=ansi whiptail --title "error can't install tor" --infobox "error can't install tor" 8 78
		exit 1;
 fi
	cat > '/etc/tor/torrc' << EOF
SocksPort 0
RunAsDaemon 1
ORPort 9001
#ORPort [$myipv6]:9001
Nickname $tor_name
ContactInfo $domain [tor-relay.co]
Log notice file /var/log/tor/notices.log
DirPort 9030
ExitPolicy reject6 *:*, reject *:*
EOF
service tor start
systemctl restart tor@default
	fi
fi
#############################################
if [[ $install_netdata = 1 ]]; then
	if [[ -f /usr/sbin/netdata ]]; then
		:
		else
		clear
		colorEcho ${INFO} "安装Netdata(Install netdata ing)"
		bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --disable-telemetry
		#bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait --disable-telemetry
		#sed -i 's/# bind to = \*/bind to = 127.0.0.1/g' /etc/netdata/netdata.conf
		wget -O /opt/netdata/etc/netdata/netdata.conf http://localhost:19999/netdata.conf
		sed -i 's/# bind to = \*/bind to = 127.0.0.1/g' /opt/netdata/etc/netdata/netdata.conf
		sleep 1
		colorEcho ${INFO} "重启Netdata(Restart netdata ing)"
		systemctl restart netdata || true
		cd
	fi
fi
clear
#############################################
if [[ -f /etc/trojan/trojan.crt ]] && [[ -f /etc/trojan/trojan.key ]]; then
	:
	else
	curl -s https://get.acme.sh | sh
	~/.acme.sh/acme.sh --upgrade --auto-upgrade
fi
#############################################
if [[ $install_trojan = 1 ]]; then
	if [[ -f /usr/local/bin/trojan ]]; then
		:
		else
	clear
	colorEcho ${INFO} "安装Trojan-GFW(Install Trojan-GFW ing)"
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
	systemctl daemon-reload
	clear
	colorEcho ${INFO} "配置(configing) trojan-gfw"
	if [[ -f /etc/trojan/trojan.pem ]]; then
		colorEcho ${INFO} "DH已有，跳过生成。。。"
		else
		:
		#openssl dhparam -out /etc/trojan/trojan.pem 2048
		fi
	fi
	ipv4_prefer="true"
	if [[ -n $myipv6 ]]; then
		ping -6 ipv6.google.com -c 2
		if [[ $? -eq 0 ]]; then
			ipv4_prefer="false"
		fi
	fi
	cat > '/usr/local/etc/trojan/config.json' << EOF
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$password1",
        "$password2"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/trojan/trojan.crt",
        "key": "/etc/trojan/trojan.key",
        "key_password": "",
        "cipher": "$cipher_server",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": $ipv4_prefer,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": true,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": ""
    }
}
EOF
	touch /usr/share/nginx/html/client1-$password1.json || true
	touch /usr/share/nginx/html/client2-$password2.json || true
	cat > "/usr/share/nginx/html/client1-$password1.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$myip",
	"remote_port": 443,
	"password": [
		"$password1"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "$domain",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
	cat > "/usr/share/nginx/html/client2-$password2.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$myip",
	"remote_port": 443,
	"password": [
		"$password2"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "$domain",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
if [[ -n $myipv6 ]]; then
	touch /usr/share/nginx/html/clientv6-$password1.json || true
	cat > "/usr/share/nginx/html/clientv6-$password1.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$myipv6",
	"remote_port": 443,
	"password": [
		"$password1"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "$domain",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
fi
fi
	clear
	if [[ $install_bbr = 1 ]]; then
	colorEcho ${INFO} "设置(setting up) TCP-BBR boost technology"
	cat > '/etc/sysctl.d/99-sysctl.conf' << EOF
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.accept_ra = 2
net.core.netdev_max_backlog = 100000
net.core.netdev_budget = 50000
net.core.netdev_budget_usecs = 5000
#fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.somaxconn = 4096
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_syn_backlog = 30000
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
	sysctl -p || true
	cat > '/etc/systemd/system.conf' << EOF
[Manager]
#DefaultTimeoutStartSec=90s
DefaultTimeoutStopSec=30s
#DefaultRestartSec=100ms
DefaultLimitCORE=infinity
DefaultLimitNOFILE=51200
DefaultLimitNPROC=51200
EOF
		cat > '/etc/security/limits.conf' << EOF
* soft nofile 51200
* hard nofile 51200
EOF
if grep -q "ulimit" /etc/profile
then
	:
else
echo "ulimit -SHn 51200" >> /etc/profile
fi
if grep -q "pam_limits.so" /etc/pam.d/common-session
then
	:
else
echo "session required pam_limits.so" >> /etc/pam.d/common-session || true
fi
systemctl daemon-reload
	fi
	timedatectl set-timezone Asia/Hong_Kong || true
	timedatectl set-ntp on || true
	if [[ $dist != centos ]]; then
		ntpdate -qu 1.hk.pool.ntp.org > /dev/null || true
	fi
	clear
}
#########Open ports########################
openfirewall(){
	set +e
	colorEcho ${INFO} "设置 firewall"
	#sh -c 'echo "1\n" | DEBIAN_FRONTEND=noninteractive update-alternatives --config iptables'
	iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT
	iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
	iptables -I OUTPUT -j ACCEPT
	ip6tables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT
	ip6tables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
	ip6tables -I OUTPUT -j ACCEPT
	if [[ $dist = centos ]]; then
	setenforce 0
	cat > '/etc/selinux/config' << EOF
SELINUX=disabled
SELINUXTYPE=targeted
EOF
	firewall-cmd --zone=public --add-port=80/tcp --permanent
	firewall-cmd --zone=public --add-port=443/tcp --permanent
	systemctl stop firewalld
	systemctl disable firewalld
 elif [[ $dist = ubuntu ]]; then
	export DEBIAN_FRONTEND=noninteractive
	ufw allow http
	ufw allow https
	apt-get install iptables-persistent -qq -y > /dev/null
 elif [[ $dist = debian ]]; then
	export DEBIAN_FRONTEND=noninteractive 
	apt-get install iptables-persistent -qq -y > /dev/null
 else
	clear
	TERM=ansi whiptail --title "error can't install iptables-persistent" --infobox "error can't install iptables-persistent" 8 78
	exit 1;
 fi
}
########Nginx config for Trojan only##############
nginxtrojan(){
	set +e
	clear
	colorEcho ${INFO} "配置(configing) nginx"
rm -rf /etc/nginx/sites-available/*
rm -rf /etc/nginx/sites-enabled/*
rm -rf /etc/nginx/conf.d/*
touch /etc/nginx/conf.d/trojan.conf
if [[ $install_trojan = 1 ]]; then
	cat > '/etc/nginx/conf.d/trojan.conf' << EOF
server {
	listen 127.0.0.1:80;
	server_name $domain;
	if (\$http_user_agent = "") { return 444; }
	if (\$host != "$domain") { return 404; }
	add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
	add_header X-Frame-Options SAMEORIGIN always;
	add_header X-Content-Type-Options "nosniff" always;
	add_header Referrer-Policy "no-referrer";
	#add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://ssl.google-analytics.com https://assets.zendesk.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com https://assets.zendesk.com; style-src 'self' https://fonts.googleapis.com https://assets.zendesk.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://assets.zendesk.com https://www.facebook.com https://s-static.ak.facebook.com https://tautt.zendesk.com; object-src 'none'";
	add_header Feature-Policy "geolocation none;midi none;notifications none;push none;sync-xhr none;microphone none;camera none;magnetometer none;gyroscope none;speaker self;vibrate none;fullscreen self;payment none;";
	location / {
		root /usr/share/nginx/html/;
			index index.html;
		}
EOF
	else
	cat > '/etc/nginx/conf.d/trojan.conf' << EOF
server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	ssl_certificate       /etc/trojan/trojan.crt;
	ssl_certificate_key   /etc/trojan/trojan.key;
	ssl_protocols         TLSv1.3 TLSv1.2;
	ssl_ciphers $cipher_server;
	ssl_prefer_server_ciphers on;
	ssl_early_data on;
	ssl_session_cache   shared:SSL:40m;
	ssl_session_timeout 1d;
	ssl_session_tickets off;
	ssl_stapling on;
	ssl_stapling_verify on;
	#ssl_dhparam /etc/nginx/nginx.pem;

	resolver 1.1.1.1;
	resolver_timeout 10s;
	server_name           $domain;
	#add_header alt-svc 'quic=":443"; ma=2592000; v="46"';
	add_header X-Frame-Options SAMEORIGIN always;
	add_header X-Content-Type-Options "nosniff" always;
	add_header X-XSS-Protection "1; mode=block" always;
	add_header Referrer-Policy "no-referrer";
	add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
	#add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://ssl.google-analytics.com https://assets.zendesk.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com https://assets.zendesk.com; style-src 'self' https://fonts.googleapis.com https://assets.zendesk.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://assets.zendesk.com https://www.facebook.com https://s-static.ak.facebook.com https://tautt.zendesk.com; object-src 'none'";
	#add_header Feature-Policy "geolocation none;midi none;notifications none;push none;sync-xhr none;microphone none;camera none;magnetometer none;gyroscope none;speaker self;vibrate none;fullscreen self;payment none;";
	if (\$http_user_agent = "") { return 444; }
	if (\$host != "$domain") { return 404; }
	location / {
		root /usr/share/nginx/html;
		index index.html;
	}
EOF
fi
if [[ $install_aria = 1 ]]; then
echo "    location $ariapath {" >> /etc/nginx/conf.d/trojan.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:6800/jsonrpc;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_qbt = 1 ]]; then
echo "    location $qbtpath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass              http://127.0.0.1:8080/;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header        X-Forwarded-Host        \$server_name:\$server_port;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_hide_header       Referer;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_hide_header       Origin;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header        Referer                 '';" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header        Origin                  '';" >> /etc/nginx/conf.d/trojan.conf
echo "        # add_header              X-Frame-Options         "SAMEORIGIN"; # not needed since 4.1.0" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_file = 1 ]]; then
echo "    location $filepath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:8081/;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_tracker = 1 ]]; then
echo "    location $trackerpath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:8000/announce;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
echo "    location $trackerstatuspath {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://127.0.0.1:8000/stats;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_intercept_errors on;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        error_page 502 = @errpage;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
if [[ $install_netdata = 1 ]]; then
echo "    location ~ $netdatapath(?<ndpath>.*) {" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header Host \$host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-Host \$host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-Server \$host;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_http_version 1.1;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass_request_headers on;" >> /etc/nginx/conf.d/trojan.conf
echo '        proxy_set_header Connection "keep-alive";' >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_store off;" >> /etc/nginx/conf.d/trojan.conf
echo "        proxy_pass http://netdata/\$ndpath\$is_args\$args;" >> /etc/nginx/conf.d/trojan.conf
echo "        gzip on;" >> /etc/nginx/conf.d/trojan.conf
echo "        gzip_proxied any;" >> /etc/nginx/conf.d/trojan.conf
echo "        gzip_types *;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
fi
echo "        location @errpage {" >> /etc/nginx/conf.d/trojan.conf
echo "        return 404;" >> /etc/nginx/conf.d/trojan.conf
echo "        }" >> /etc/nginx/conf.d/trojan.conf
echo "}" >> /etc/nginx/conf.d/trojan.conf
echo "" >> /etc/nginx/conf.d/trojan.conf
echo "server {" >> /etc/nginx/conf.d/trojan.conf
echo "    listen 80;" >> /etc/nginx/conf.d/trojan.conf
echo "    listen [::]:80;" >> /etc/nginx/conf.d/trojan.conf
echo "    server_name $domain;" >> /etc/nginx/conf.d/trojan.conf
echo "    return 301 https://$domain;" >> /etc/nginx/conf.d/trojan.conf
echo "}" >> /etc/nginx/conf.d/trojan.conf
echo "" >> /etc/nginx/conf.d/trojan.conf
echo "server {" >> /etc/nginx/conf.d/trojan.conf
echo "    listen 80 default_server;" >> /etc/nginx/conf.d/trojan.conf
echo "    listen [::]:80 default_server;" >> /etc/nginx/conf.d/trojan.conf
echo "    server_name _;" >> /etc/nginx/conf.d/trojan.conf
echo "    return 444;" >> /etc/nginx/conf.d/trojan.conf
echo "}" >> /etc/nginx/conf.d/trojan.conf
if [[ $install_netdata = 1 ]]; then
	echo "upstream netdata {" >> /etc/nginx/conf.d/trojan.conf
	echo "    server 127.0.0.1:19999;" >> /etc/nginx/conf.d/trojan.conf
	echo "    keepalive 64;" >> /etc/nginx/conf.d/trojan.conf
	echo "}" >> /etc/nginx/conf.d/trojan.conf
fi
nginx -t
systemctl restart nginx || true
htmlcode=$(shuf -i 1-3 -n 1)
curl -LO --progress-bar https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/$htmlcode.zip
unzip -o $htmlcode.zip -d /usr/share/nginx/html/
rm -rf $htmlcode.zip
rm -rf /usr/share/nginx/html/readme.txt
}
##########Auto boot start###############
start(){
	set +e
	colorEcho ${INFO} "启动(starting) trojan-gfw and nginx ing..."
	systemctl daemon-reload
	if [[ $install_qbt = 1 ]]; then
		systemctl start qbittorrent.service
	fi
	if [[ $install_tracker = 1 ]]; then
		systemctl start tracker
	fi
	if [[ $install_file = 1 ]]; then
		systemctl start filebrowser
	fi
	if [[ $install_aria = 1 ]]; then
		systemctl start aria2
	fi
	if [[ $install_trojan = 1 ]]; then
		systemctl start trojan
	fi
	systemctl restart nginx
}
bootstart(){
	set +e
	colorEcho ${INFO} "设置开机自启(auto boot start) ing..."
	systemctl daemon-reload
	if [[ $install_qbt = 1 ]]; then
		systemctl enable qbittorrent
	fi
	if [[ $install_tracker = 1 ]]; then
		systemctl enable tracker
	fi
	if [[ $install_file = 1 ]]; then
		systemctl enable filebrowser
	fi
	if [[ $install_aria = 1 ]]; then
		systemctl enable aria2
	fi
	if [[ $install_trojan = 1 ]]; then
		systemctl enable trojan
	fi
	systemctl enable nginx
}
##########Check for update############
checkupdate(){
	set +e
	cd
	apt-get update
	apt-get upgrade -y
	if [[ -f /usr/local/bin/trojan ]]; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
	fi
}
###########Trojan share link########
sharelink(){
	set +e
	cd
	clear
		if [[ $install_trojan = 1 ]]; then
			if [[ $dist = centos ]]; then
		colorEcho ${ERROR} "QR generate Fail ! Because your os does not support python3-qrcode,Please consider change your os!"
		elif [[ $(lsb_release -cs) = xenial ]] || [[ $(lsb_release -cs) = trusty ]] || [[ $(lsb_release -cs) = jessie ]]
		then
		colorEcho ${ERROR} "QR generate Fail ! Because your os does not support python3-qrcode,Please consider change your os!"
		else
		apt-get install python3-qrcode -qq -y > /dev/null
		wget https://github.com/trojan-gfw/trojan-url/raw/master/trojan-url.py -q
		chmod +x trojan-url.py
		#./trojan-url.py -i /etc/trojan/client.json
		./trojan-url.py -q -i /usr/share/nginx/html/client1-$password1.json -o $password1.png
		./trojan-url.py -q -i /usr/share/nginx/html/client2-$password2.json -o $password2.png
		cp $password1.png /usr/share/nginx/html/
		cp $password2.png /usr/share/nginx/html/
		rm -rf trojan-url.py
		rm -rf $password1.png
		rm -rf $password2.png
		apt-get remove python3-qrcode -qq -y > /dev/null
		fi
	fi
	cat > "/usr/share/nginx/html/result.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="author" content="John Rosen">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Vps Toolbox Result</title>
</head>
<style>
body {
  background-color: #cccccc;
}

.menu{
    position: relative;
    background-color: #B2BEB5;  
    font-family: sans-serif;
    font-size: 2em;
    margin-top: -10px;
    padding-top: 0px;
    text-align: center;
    width: 100%;
    height: 8%;
}

.menu ul{
    list-style-type: none;
    overflow: hidden;
    margin: 0;
    padding: 0;
}

.menu li{
    float: left;
}
.menu a{
    display: inline;
    color: white;
    text-align: center;
    padding-left: 100px;
    padding-right: 100px;
    text-decoration: none;
}

.menu li:hover {
    background-color: #CC99FF;
}

.tt{
    position: absolute;
    border:1px #00f none;
    border-radius: 5px;
    width: 75%;
    margin-left: 150px;
    margin-top: 20px;
    font-size: 1.2em;
    font-family: sans-serif;
    font-weight: bold;
    padding-left: 50px;
    padding-right: 50px;
    padding-bottom: 10px;
    background-color: #E6FFFB;
    overflow: visible;
}
.tt a {
    text-decoration: none;
    color: #8095ff;
    font-size: 1.3em;
}

.tt img{
    width: 550px;
    height: 40%;
}

.tt li {
    padding-top: 10px;
}
.subtt{
    text-align: center;
    margin: auto;
    font-size: 2em;
    padding-top: 10px;
}

.t1{
    font-size: 1.2em;
}

footer{
    padding-top: 0;
    position: fixed;
    margin: 0;
    background-color: #B2BEB5;
    width: 100%;
    height: 50px;
    bottom: 0;
}

footer p{
    color: #fff;
    text-align: center;
    font-size: 1em;
    font-family: sans-serif;
}

footer a{
    color: #fff;
}

footer a:link {
    text-decoration: none;
}

@media (max-width: 560px){
    .menu{
        font-size: 1.2em;
    }
    .sidebar {
        display: none;
    }

    .cate {
        display: none;
    }
    .tt{
        position: absolute;
        width: 80%;
        margin-left: 0;
    }
    .menu{
        padding-top: 0px;
    }
}

@media (max-width: 750px){
    .sidebar {
        display: none;
    }
    .cate{
        display: none;
    }
}
::-webkit-scrollbar {
    width: 11px;
}

::-webkit-scrollbar-track {
    background: #CCFFEE;
    border-radius: 10px;
}

::-webkit-scrollbar-thumb {
    background: #B3E5FF;
    border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
    background: #156; 
}
</style>
<body>
    <div>
        <div>
            <article>
                <div class="tt">
                    <h4 class="subtt">Vps Toolbox Result</h3>
                    <p>If you did not choose any of the softwares during the installation below, just ignore them.</p>
                    <p>如果你安装的时候没有选择相应的软件，请自动忽略相关内容！</p>
                    <p>以下所有链接以及信息都是有用的，请在提任何问题或者issue前仔细阅读相关内容！</p>
                    <p><a href="https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way/blob/master/README-zh_CN.md" target="_blank">提问的智慧</a></p>
                    <h2>Trojan-GFW</h2>
                    <p>一。 Trojan-GFW 客户端(client) 配置文件(config profiles)</p>
                    <p>1. <a href="client1-$password1.json" target="_blank">Profile 1</a></p>
                    <p>2. <a href="client2-$password2.json" target="_blank">Profile 2</a></p>
                    <p>3. <a href="clientv6-$password1.json" target="_blank">IPV6 Profile</a>(only click this when your server has a ipv6 address,or 404 will occur!)</p>
                    <p>二。 Trojan-GFW 分享链接(Share Links) are</p>
                    <p>1. trojan://$password1@$domain:443</p>
                    <p>2. trojan://$password2@$domain:443</p>
                    <p>三。 Trojan-GFW 二维码(QR codes Centos等不支援python3-prcode的系统会404!)</p>
                    <p>1.<a href="$password1.png" target="_blank">QR code 1</a></p>
                    <p>2.<a href="$password2.png" target="_blank">QR code 2</a></p>
                    <p>四。 相关链接(Related Links)</p>
                    <p><a href="https://github.com/trojan-gfw/igniter/releases" target="_blank">安卓客户端(android client)</a></p>
                    <p><a href="https://apps.apple.com/us/app/shadowrocket/id932747118" target="_blank">苹果客户端(ios client)</a></p>
                    <p><a href="https://github.com/trojan-gfw/trojan/releases/latest" target="_blank">Windows客户端(win client)</a></p>
                    <p><a href="https://github.com/trojan-gfw/trojan/wiki/Mobile-Platforms" target="_blank">https://github.com/trojan-gfw/trojan/wiki/Mobile-Platforms</a></p>
                    <p><a href="https://github.com/trojan-gfw/trojan/releases/latest" target="_blank">https://github.com/trojan-gfw/trojan/releases/latest</a></p>
                    <p><a href="https://www.johnrosen1.com/trojan/" target="_blank">Trojan-GFW --一把通往自由互联网世界的万能钥匙</a></p>
                    <h2>Qbittorrent</h2>
                    <p>你的Qbittorrent信息(Your Qbittorrent Information)</p>
                    <p><a href="https://$domain$qbtpath" target="_blank">https://$domain$qbtpath</a> 用户名(username): admin 密碼(password): adminadmin</p>
                    <p>Tips:</p>
                    <p>1. 请将Qbittorrent下载目录改为 /usr/share/nginx/qbt/ ！！！否则拉回本地将不起作用！！！</p>
                    <p>2. 请将Qbittorrent中的Bittorrent加密選項改为 強制加密(Require encryption) ！！！否则會被迅雷吸血！！！</p>
                    <p>3. 请在Qbittorrent中添加Trackers <a href="https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt" target="_blank">https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt</a> ！！！否则速度不會快的！！！</p>
                    <p>附：优秀的BT站点推荐(Related Links)</p>
                    <p><a href="https://thepiratebay.org/" target="_blank">https://thepiratebay.org/</a></p>
                    <p><a href="https://sukebei.nyaa.si/" target="_blank">https://sukebei.nyaa.si/</a></p>
                    <p><a href="https://rarbgprx.org/torrents.php" target="_blank">https://rarbgprx.org/torrents.php</a></p>
                    <p>相关链接(Related Links)</p>
                    <p><a href="https://www.qbittorrent.org/download.php" target="_blank">win等平台下载页面</a></p>
                    <p><a href="https://github.com/qbittorrent/qBittorrent" target="_blank">Github页面</a></p>
                    <p><a href="https://play.google.com/store/apps/details?id=com.lgallardo.qbittorrentclientpro" target="_blank">Android远程操控客户端</a></p>
                    <p><a href="https://www.qbittorrent.org/" target="_blank">https://www.qbittorrent.org/</a></p>
                    <p><a href="https://www.johnrosen1.com/qbt/" target="_blank">https://www.johnrosen1.com/qbt/</a></p>
                    <h2>Bittorrent-trackers</h2>
                    <p>你的Bittorrent-Tracker信息(Your Bittorrent-Tracker Information)</p>
                    <p>https://$domain:443$trackerpath</p>
                    <p>http://$domain:8000/announce</p>
                    <p>你的Bittorrent-Tracker信息（查看状态用）(Your Bittorrent-Tracker Status Information)</p>
                    <p><a href="https://$domain:443$trackerstatuspath" target="_blank">https://$domain:443$trackerstatuspath</a></p>
                    <p>Tips:</p>
                    <p>1. 请手动将此Tracker添加于你的BT客户端中，发布种子时记得填上即可。</p>
                    <p>2. 请记得将此Tracker分享给你的朋友们。</p>
                    <p>相关链接(Related Links)</p>
                    <p><a href="https://github.com/webtorrent/bittorrent-tracker" target="_blank">https://github.com/webtorrent/bittorrent-tracker</a></p>
                    <p><a href="https://lifehacker.com/whats-a-private-bittorrent-tracker-and-why-should-i-us-5897095" target="_blank">What's a Private BitTorrent Tracker, and Why Should I Use One?</a></p>
                    <p><a href="https://www.howtogeek.com/141257/htg-explains-how-does-bittorrent-work/" target="_blank">How Does BitTorrent Work?</a></p>
                    <h2>Aria2</h2>
                    <p>你的Aria2信息，非分享链接，仅供参考(Your Aria2 Information)</p>
                    <p>$ariapasswd@https://$domain:443$ariapath</p>
                    <p>相关链接（Related Links)</p>
                    <p><a href="https://github.com/mayswind/AriaNg/releases" target="_blank">Aria客户端(远程操控)</a></p>
                    <p><a href="https://github.com/aria2/aria2" target="_blank">https://github.com/aria2/aria2</a></p>
                    <p><a href="https://aria2.github.io/manual/en/html/index.html" target="_blank">https://aria2.github.io/manual/en/html/index.html</a>官方文档</p>
                    <p><a href="https://play.google.com/store/apps/details?id=com.gianlu.aria2app" target="_blank">https://play.google.com/store/apps/details?id=com.gianlu.aria2app</a></p>
                    <h2>Filebrowser</h2>
                    <p>你的Filebrowser信息，非分享链接，仅供参考(Your Filebrowser Information)</p>
                    <p><a href="https://$domain:443$filepath" target="_blank">https://$domain:443$filepath</a> 用户名(username): admin 密碼(password): admin</p>
                    <p>Tips:</p>
                    <p>1. 请修改默认用户名和密码！。</p>
                    <p>相关链接(Related Links)</p>
                    <p><a href="https://github.com/filebrowser/filebrowser" target="_blank">https://github.com/filebrowser/filebrowser</a></p>
                    <p><a href="https://filebrowser.xyz/" target="_blank">https://filebrowser.xyz/</a></p>
                    <h2>Netdata</h2>
                    <p>你的netdata信息，非分享链接，仅供参考(Your Netdata Information)</p>
                    <p><a href="https://$domain:443$netdatapath" target="_blank">https://$domain:443$netdatapath</a></p>
                    <p>相关链接（Related Links)</p>
                    <p><a href="https://play.google.com/store/apps/details?id=com.kpots.netdata" target="_blank">https://play.google.com/store/apps/details?id=com.kpots.netdata</a></p>
                    <p><a href="https://github.com/netdata/netdata" target="_blank">https://github.com/netdata/netdata</a></p>
                    <h2>自定义配置方法</h2>
                    <p>Nginx: sudo nano /etc/nginx/conf.d/trojan.conf</p>
                    <p>sudo systemctl start/restart/status nginx</p>
                    <p>Trojan-GFW: sudo nano /usr/local/etc/trojan/config.json</p>
                    <p>sudo systemctl start/restart/status trojan</p>
                    <p>Dnscrypt-proxy: sudo nano /etc/dnscrypt-proxy.toml</p>
                    <p>sudo systemctl start/restart/status dnscrypt-proxy</p>
                    <p>Aria2: sudo nano /etc/aria2.conf</p>
                    <p>sudo systemctl start/restart/status aria2</p>
                    <p>Netdata: sudo nano /opt/netdata/etc/netdata/netdata.conf</p>
                    <p>sudo systemctl start/restart/status netdata</p>
                    <p>Tor: sudo nano /etc/tor/torrc</p>
                    <p>sudo systemctl start/restart/status tor@default</p>
                    <br>
                    <br>
                </div>
            </article>
            <footer>
                <p><a href="https://github.com/johnrosen1/trojan-gfw-script">VPS Toolbox</a> Copyright &copy; 2020 Johnrosen</p>
            </footer>
        </div>
    </div>
</body>
</html>
EOF
}
##########Remove Trojan-Gfw##########
uninstall(){
	set +e
	cd
	if [[ -f /usr/local/bin/trojan ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) trojan?" 8 78); then
		systemctl stop trojan
		systemctl disable trojan
		rm -rf /etc/systemd/system/trojan*
		rm -rf /usr/local/etc/trojan/*
		rm -rf /root/.trojan/autoupdate.sh
		fi
	fi
	if [[ -f /usr/sbin/nginx ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) nginx?" 8 78); then
		systemctl stop nginx
		systemctl disable nginx
		$pack remove nginx
		rm -rf /etc/apt/sources.list.d/nginx.list
		fi
	fi
	if [[ -f /usr/sbin/dnscrypt-proxy ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) dnscrypt-proxy?" 8 78); then
			systemctl stop dnscrypt-proxy
			systemctl disable dnscrypt-proxy
			rm -rf /usr/sbin/dnscrypt-proxy
		fi
	fi
	if [[ -f /usr/bin/qbittorrent-nox ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) qbittorrent?" 8 78); then
		systemctl stop qbittorrent
		systemctl disable qbittorrent
		$pack remove qbittorrent-nox
		fi
	fi
	if [[ -f /usr/bin/bittorrent-tracker ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) bittorrent-tracker?" 8 78); then
		systemctl stop tracker
		systemctl disable tracker
		rm -rf /usr/bin/bittorrent-tracker
		fi
	fi
	if [[ -f /usr/local/bin/aria2c ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) aria2?" 8 78); then
		systemctl stop aria
		systemctl disable aria
		rm -rf /etc/aria.conf
		rm -rf /usr/local/bin/aria2c
		fi
	fi
	if [[ -f /usr/local/bin/filebrowser ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) filebrowser?" 8 78); then
		systemctl stop filebrowser
		systemctl disable filebrowser
		rm /usr/local/bin/filebrowser
		fi
	fi
	if [[ -f /usr/sbin/netdata ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) netdata?" 8 78); then
		systemctl stop netdata
		systemctl disable netdata
		rm -rf /usr/sbin/netdata
		fi
	fi
	if [[ -f /usr/bin/tor ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) tor?" 8 78); then
		systemctl stop tor
		systemctl disable tor
		systemctl stop tor@default
		$pack remove tor
		rm -rf /etc/apt/sources.list.d/tor.list
		fi
	fi
	if (whiptail --title "api" --yesno "卸载 (uninstall) acme.sh?" 8 78); then
		~/.acme.sh/acme.sh --uninstall
	fi
	cat > '/root/.trojan/config.json' << EOF
{
  "installed": "0"
}
EOF
	cat > '/root/.trojan/license.json' << EOF
{
  "license": "0"
}
EOF
	apt-get update
	systemctl daemon-reload || true
	colorEcho ${INFO} "卸载完成"
}
###########Status#################
statuscheck(){
	set +e
	if [[ -f /usr/local/bin/trojan ]]; then
		trojanstatus=$(systemctl is-active trojan)
		if [[ $trojanstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Trojan-GFW状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Trojan-GFW状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart trojan
		fi
	fi
	if [[ -f /usr/sbin/nginx ]]; then
		nginxstatus=$(systemctl is-active nginx)
		if [[ $nginxstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Nginx状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Nginx状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart nginx
		fi
	fi
	if [[ -f /usr/sbin/dnscrypt-proxy ]]; then
		dnsmasqstatus=$(systemctl is-active dnscrypt-proxy)
		if [[ $dnsmasqstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "dnscrypt-proxy状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "dnscrypt-proxy状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart dnscrypt-proxy
		fi
	fi
	if [[ -f /usr/bin/qbittorrent-nox ]]; then
		qbtstatus=$(systemctl is-active qbittorrent)
		if [[ $qbtstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Qbittorrent状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Qbittorrent状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart qbittorrent
		fi
	fi
	if [[ -f /usr/bin/bittorrent-tracker ]]; then
		trackerstatus=$(systemctl is-active tracker)
		if [[ $trackerstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Bittorrent-Tracker状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Bittorrent-Tracker状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart tracker
		fi
	fi
	if [[ -f /usr/local/bin/aria2c ]]; then
		aria2status=$(systemctl is-active aria2)
		if [[ $nginxstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Aria2状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Aria2状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart aria2
		fi
	fi
	if [[ -f /usr/local/bin/filebrowser ]]; then
		filestatus=$(systemctl is-active filebrowser)
		if [[ $filestatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Filebrowser状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Filebrowser状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart filebrowser
		fi
	fi
	if [[ -f /usr/sbin/netdata ]]; then
		netdatastatus=$(systemctl is-active netdata)
		if [[ $netdatastatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Netdata状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Netdata状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart netdata
		fi
	fi
	if [[ -f /usr/bin/tor ]]; then
		torstatus=$(systemctl is-active tor)
		if [[ $torstatus == active ]]; then
			echo ""
			colorEcho ${INFO} "Tor状态：正常运行中(Normal)"
			else
			echo ""
			colorEcho ${INFO} "Tor状态：服务状态异常,尝试重启服务(Not Running)"
			systemctl restart tor
		fi
	fi
	echo ""
	colorEcho ${INFO} "状态检查完成(Status Check complete)"
}
##################################
autoupdate(){
	if [[ $install_trojan == 1 ]]; then
cat > '/root/.trojan/autoupdate.sh' << EOF
#!/bin/bash
trojanversion=$(curl -s "https://api.github.com/repos/trojan-gfw/trojan/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c2-999)
/usr/local/bin/trojan -v &> /root/.trojan/trojan_version.txt
if cat /root/.trojan/trojan_version.txt | grep \$trojanversion > /dev/null; then
   	echo "no update required" >> /root/.trojan/update.log
    else
    echo "update required" >> /root/.trojan/update.log
    wget -q https://github.com/trojan-gfw/trojan/releases/download/v\$trojanversion/trojan-\$trojanversion-linux-amd64.tar.xz
    tar -xf trojan-\$trojanversion-linux-amd64.tar.xz
    rm -rf trojan-\$trojanversion-linux-amd64.tar.xz
    cd trojan
    chmod +x trojan
    cp -f trojan /usr/local/bin/trojan
    systemctl restart trojan
    cd
    rm -rf trojan
    echo "Update complete" >> /root/.trojan/update.log
fi
EOF
crontab -l | grep -q '0 * * * * bash /root/.trojan/autoupdate.sh'  && echo 'cron exists' || echo "0 * * * * bash /root/.trojan/autoupdate.sh" | crontab
#echo "0 * * * * bash /root/.trojan/autoupdate.sh" | crontab
	fi
}
###################################
logcheck(){
	set +e
	readconfig
	clear
	if [[ -f /usr/local/bin/trojan ]]; then
		colorEcho ${INFO} "Trojan Log"
		journalctl -a -u trojan.service
		less /root/.trojan/update.log
	fi
	if [[ -f /usr/sbin/dnscrypt-proxy ]]; then
		colorEcho ${INFO} "dnscrypt-proxy Log"
		less /var/log/dnscrypt-proxy.log
		less /var/log/query.log
	fi
	if [[ -f /usr/local/bin/aria2c ]]; then
		colorEcho ${INFO} "Aria2 Log"
		less /var/log/aria2.log
	fi
	colorEcho ${INFO} "Nginx Log"
	less /var/log/nginx/error.log
	less /var/log/nginx/access.log
}
##################################
bandwithusage(){
	set +e
	colorEcho ${INFO} "流量使用情况(bandwithusage) 接收(Receive) 发送(Transmit)"
	tail -n +3 /proc/net/dev | awk '{print $1 " " $2 " " $10}' | numfmt --to=iec --field=2,3
	colorEcho ${INFO} "Done !"
}
##################################
advancedMenu() {
	Mainmenu=$(whiptail --clear --ok-button "吾意已決 立即安排" --backtitle "hi" --title "VPS ToolBox Menu" --menu --nocancel "Choose an option: https://github.com/johnrosen1/trojan-gfw-script
运行此脚本前请在控制面板中开启80 443端口并关闭Cloudflare CDN!" 13 78 4 \
	"1" "安裝(Install)" \
	"2" "结果(Result)" \
	"3" "日志(Log)" \
	"4" "流量(Bandwith)" \
	"5" "状态(Status)" \
	"6" "更新(Update)" \
	"7" "卸載(Uninstall)" \
	"8" "退出(Quit)" 3>&1 1>&2 2>&3)
	case $Mainmenu in
		1)
		cd
		clear
		userinput
		installdependency
		openfirewall
		issuecert
		nginxtrojan
		bootstart
		start
		sharelink
		rm results || true
		prasejson
		autoupdate
		if [[ $dnsmasq_install -eq 1 ]]; then
			if [[ $dist = ubuntu ]]; then
	 			systemctl stop systemd-resolved || true
	 			systemctl disable systemd-resolved || true
 			fi
			if [[ $(systemctl is-active dnsmasq) == active ]]; then
				systemctl disable dnsmasq
				systemctl stop dnsmasq
			fi
		rm /etc/resolv.conf || true
		touch /etc/resolv.conf || true
		echo "nameserver 127.0.0.1" > '/etc/resolv.conf' || true
		systemctl start dnscrypt-proxy || true
		systemctl enable dnscrypt-proxy || true
		fi
		if [[ $password1 == "" ]]; then
		password1=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo '' )
		fi
		mv /usr/share/nginx/html/result.html /usr/share/nginx/html/$password1.html
		clear
		if grep -q "attention" /etc/motd
		then
		:
		else
		echo "***************************************************************************************" >> /etc/motd
		echo "*                                   Pay attention!                                    *" >> /etc/motd
		echo "*     请访问下面的链接获取结果(Please visit the following link to get the result)       *" >> /etc/motd
		echo "*                       https://$domain/$password1.html         *" >> /etc/motd
		echo "*           若访问失败，请运行以下两行命令自行检测服务是否正常:active(running)为正常  *" >> /etc/motd
		echo "*                       sudo systemctl status trojan                                  *" >> /etc/motd
		echo "*                       sudo systemctl status nginx                                   *" >> /etc/motd
		echo "***************************************************************************************" >> /etc/motd
		fi
		echo "请访问下面的链接获取结果(Please visit the following link to get the result)" > /root/.trojan/result.txt
		echo "https://$domain/$password1.html" >> /root/.trojan/result.txt
		#whiptail --title "Install Success" --textbox --scrolltext /root/.trojan/result.txt 8 120
		if [[ $install_bbrplus = 1 ]]; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh)"
		fi
		if (whiptail --title "Reboot" --yesno "安装成功(success)！ 重启 (reboot) 使配置生效,重新SSH连接后将自动出现结果 (to make the configuration effective)?" 8 78); then
		reboot
		fi
		;;
		2)
		cd
		whiptail --title "Install Success" --textbox --scrolltext /root/.trojan/result.txt 8 120
		advancedMenu
		;;
		3)
		cd
		logcheck
		advancedMenu
		;;
		4)
		cd
		bandwithusage
		;;
		5)
		cd
		statuscheck
		;;
		6)
		cd
		checkupdate
		colorEcho ${SUCCESS} "RTFM: https://github.com/johnrosen1/trojan-gfw-script"
		;;
		7)
		cd
		uninstall
		colorEcho ${SUCCESS} "Remove complete"
		;;
		8)
		exit
		whiptail --title "脚本已退出" --msgbox "脚本已退出(Bash Exited) RTFM: https://github.com/johnrosen1/trojan-gfw-script" 8 78
		;;
		esac
}
cd
system_upgrade=0
install_bbr=0
install_bbrplus=0
install_trojan=0
dnsmasq_install=0
install_tor=0
install_qbt=0
install_tracker=0
install_aria=0
install_file=0
install_netdata=0
tls13only=0
osdist
setlanguage
license="$( jq -r '.license' "/root/.trojan/license.json" )"
if [[ $license != 1 ]]; then
if (whiptail --title "Accept LICENSE?" --yesno "已阅读并接受MIT License(Please read and accept the MIT License)? https://github.com/johnrosen1/trojan-gfw-script/blob/master/LICENSE" 8 78); then
	cat > '/root/.trojan/license.json' << EOF
{
  "license": "1"
}
EOF
	else
		whiptail --title "Accept LICENSE required" --msgbox "你必须阅读并接受MIT License才能继续(You must read and accept the MIT License to continue !!!)" 8 78
		exit 1
	fi
fi
clear
ip1=$(curl -s https://ipinfo.io?token=56c375418c62c9)
myip=$(curl -s https://ipinfo.io/ip?token=56c375418c62c9)
localip=$(ip a | grep inet | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
myipv6=$(ip -6 a | grep inet6 | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
advancedMenu
