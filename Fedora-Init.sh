#!/bin/sh

# Initialize Fedora fastly
# version 0.1
#
# Variables
b='\033[1m' # 字体加粗 blod
u='\033[4m' #　下划线
bl='\e[30m' # black
r='\e[31m' # red
g='\e[32m' # green
y='\e[33m' # yellow
bu='\e[34m' # blue
m='\e[35m' # magenta 品红
c='\e[36m' # cyan 青色
endc='\e[0m'
enda='\033[0m'
# Functions
## show logo
function showlogo {
  clear
  figlet -c -f slant "NUAA-FUG"
  echo -e "This script is under GPLv3 License"
  echo
}

## ROOT User check
function checkroot {
  if [[ $(id -u) = 0 ]]; then
    echo -e " Checking For ROOT: ${g}PASSED${endc}"
  else
    echo -e " Checking For ROOT: ${r}FAILED${endc}
    ${y}This Script Needs To Run As ROOT${endc}"
    echo -e " ${b}Fedora-Init.sh${enda} Will Now Exit"
    
    echo
    sleep 1
    exit
  fi
}

## For Chinese user
function forcn {
  echo -en "${m}Are you a Chinese?${endc}[Y/N](default Y)";
  read isChinese
  if [ $isChinese = "n" -o $isChinese = "N" ]; then
  echo -e "You choose No"
  sleep 2
  else
  echo -e "${bu}Preparing to install Shadowsocks${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  pip3 install git+https://github.com/shadowsocks/shadowsocks.git@master
  echo -e "${b}${g}Shadowsocks has installed${enda}";
  echo -e "${bu}Generate config file for shadowsocks${endc}";
  mkdir /etc/shadowsocks
  echo "{
    \"server\":\"your_server_ip\",
    \"server_port\":\"your_server_port\",
    \"local_address\":\"127.0.0.1\",
    \"local_port\":\"your_local_port\",
    \"password\":\"your_password\",
    \"timeout\":500,
    \"method\":\"your_encrypt_method\",
    \"fast_open\": true,
    \"workers\": 1
    }" > /etc/shadowsocks/config.json

  echo -e "${b}${g}config file has generated${enda}"
  echo -e "${bu}Preparing to install shadowsocks-qt5 and other plugins relate to Shadowsocks${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}shadowsocks-qt5 Installing ... ${endc}";
  dnf copr enable librehat/shadowsocks
  dnf check-update
  dnf install shadowsocks-qt5 -y
  echo -e "${b}${g}ss-qt5 has installed${enda}";
  echo ""
  echo -e "${bu}Preparing to install libsodium proxychains and genpac${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y libsodium
  dnf install -y proxychains-ng
  pip3 install genpac
  echo -e "${b}${g}libsodium proxychains and genpac have installed${enda}";
  echo -e "${bu}Config proxychains and genpac${endc}";
  sed -i '$d' /etc/proxychains.conf
  sed -i '$d' /etc/proxychains.conf
  sed -i '$i socks5 127.0.0.1 1080' /etc/proxychains.conf
  genpac --format=pac --pac-proxy="SOCKS5 127.0.0.1:1080" -o /etc/pac.txt
  echo -e "${b}${c}Finished${enda}";
  fi
}

## Requirements Check 
### xterm check
# function checkxterm {
#   which xterm > /dev/null 2>&1
#   if [ "$?" -eq "0" ]; then
#   echo -e "${b}${g}Xterm has installed";
#   else
#   echo -e "${r}[Warning]: this script need Xterm${endc}";
#   echo ""
#   echo -e "${u}Installing Xterm ...${enda}";
#   dnf install xterm -y
#   echo "" 
#   fi
#   sleep 2
# }

### figlet check
function checkfiglet {
  which figlet > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
  echo -e "${b}${g}Xterm has installed";
  else
  echo -e "${r}[Warning]: this script need figlet${endc}";
  echo ""
  echo -e "${u}Installing figlet...${enda}";
  dnf install figlet -y
  echo ""
  fi
  sleep 2
}
### Install Function
function updatesystem {
  showlogo
  echo -e "${bu}UPDATE SYSTEM${endc}";
  dnf update -y
  echo -e "${b}${c}Finished ${enda}";
}

## add rpm fusion repo
function AddRpmFusionRepo {
  showlogo
  echo -e "${bu}Add RPM Fusion Repository${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Adding ...${endc}"
  dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  dnf check-update
  echo -e "${b}${c}Finished${enda}";
}

## Install basic applications
function installbasicapp {
  showlogo
  echo -e "${bu}Preparing to install vim curl vlc and ffmpeg${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y vim 
  echo -e "${b}${g}vim has installed${enda}"
  echo ""
  dnf install -y vlc
  echo -e "${b}${g}vlc has installed${enda}"
  echo ""
  dnf install -y ffmpeg
  echo -e "${b}${c}Finished${enda}";
}

## Install NetworkManager plugins
function installnetman {
  showlogo
  echo -e "${bu}Preparing to install NetworkManager plugins${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y NetworkManager-*
  echo -e "${b}${c}Finished${enda}";
}

## Some tools to support NTFS and exFAT filesystem
function installfsupport {
  showlogo
  echo -e "${bu}Preparing to install some tools to support NTFS and exFAT filesystem${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y ntfs-3g
  dnf install -y fuse fuse-libs
  dnf install -y fuse-exfat
  echo -e "${b}${c}Finished${enda}";
}

## Install Visual Studio Code
function installvscode {
  showlogo
  echo -e "${bu}Preparing to install Visual Studio Code${endc}"
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  dnf install -y code
  echo -e "${b}${c}Finished${enda}";
}

## Install Sublime Text 3
function installsublime {
  showlogo
  echo -e "${bu}Preparing to install Sublime Text 3${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
  dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
  dnf install -y sublime-text
  echo -e "${b}${c}Finished${enda}";
}

## Install Zeal
function installzeal {
  showlogo
  echo -e "${bu}Preparing to install Zeal${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y zeal
  echo -e "${b}${c}Finished${enda}";
}

## Install OBS
function installobs {
  showlogo
  echo -e "${bu}Preparing to install OBS${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y obs-studio
  echo -e "${b}${c}Finished${enda}";
}

## Install Anki
function installanki {
  showlogo
  echo -e "${bu}Preparing to install Anki${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y anki
  echo -e "${b}${c}Finished${enda}";
}

## Install uget
function installuget {
  showlogo
  echo -e "${bu}Preparing to install uget${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y uget
  echo -e "${b}${c}Finished${enda}";
}

## Install MkVToolNix
function installmkvtool {
  showlogo
  echo -e "${bu}Preparing to install MKVToolNix${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y mkvtoolnix-gui
  echo -e "${b}${c}Finished${enda}";
}

## Install flash tools
function installflashtools {
  showlogo
  echo -e "${bu}Preparing to install Fedora Media Writer WoeUSB and Etcher${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y mediawriter
  echo -e "${b}${g}Fedora Media Writer has installed${enda}"
  echo ""
  dnf install -y WoeUSB
  echo -e "${b}${g}WoeUSB has installed${enda}"
  echo ""
  wget https://bintray.com/resin-io/redhat/rpm -O /etc/yum.repos.d/bintray-resin-io-redhat.repo
  dnf install -y etcher-electron
  echo -e "${b}${c}Finished${enda}";
}

## Install environment tools
function installenvtools {
  showlogo
  echo -e "${bu}Preparing to install Xsensors ibus-rime Tweak and Chrome GNOME Shell${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y xsensors
  dnf install -y ibus-rime
  ibus restart
  sleep 1
  dnf install -y gnome-tweak-tool
  dnf install -y chrome-gnome-shell
  echo -e "${b}${c}Finished${enda}";
}

## Install Google Chrome
function installchrome {
  showlogo
  echo -e "${bu}Preparing to install Chrome${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  sh -c 'echo -e "[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64 \nenabled=1\ngpgcheck=1\ngpgkey=https://dl.google.com/linux/linux_signing_key.pub
" > /etc/yum.repos.d/google-chrome.repo'
  dnf check-update
  dnf install -y google-chrome-stable
  echo -e "${b}${c}Finished${enda}";
}

## Install Telegram Desktop
function installtg {
  showlogo
  echo -e "${bu}Preparing to install Telegram${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y telegram-desktop
  echo -e "${b}${c}Finished${enda}";
}

## Install Calibre
function installcalibre {
  showlogo
  echo -e "${bu}Preparing to install Calibre${endc}";
  echo && echo -en "${y}Press Enter To Continue${endc}";
  read input
  echo -e "${g}Installing ... ${endc}";
  dnf install -y calibre
  echo -e "${b}${c}Calibre was installed${enda}"
}

######
# Start Initiation
checkroot && sleep 1
# checkxterm && checkfiglet && sleep 1
checkfiglet && sleep 1
showlogo && echo -e " ${y} Let's start${endc}"
updatesystem && sleep 1
AddRpmFusionRepo && sleep 1
forcn && sleep 2
installbasicapp && sleep 1
installnetman && sleep 1
installfsupport && sleep 1
installvscode && sleep 1
installsublime && sleep 1
installzeal && sleep 1
installobs && sleep 1
installanki && sleep 1
installuget && sleep 1
installmkvtool && sleep 1
installflashtools && sleep 1
installenvtools && sleep 1
installchrome && sleep 1
installtg && sleep 1
installcalibre && sleep 1

