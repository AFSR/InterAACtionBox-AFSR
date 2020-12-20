# https://docs.fedoraproject.org/en-US/fedora/f33/install-guide/appendixes/Kickstart_Syntax_Reference/

# Configure installation method
install
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-33&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f33&arch=x86_64" --cost=0
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-33&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-33&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-33&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-33&arch=x86_64" --cost=0

# Configure Boot Loader
bootloader --location=mbr --driveorder=sda

# Remove all existing partitions
clearpart --all --drives=sda

# Create Physical Partition
part /boot --size=512 --asprimary --ondrive=sda --fstype=xfs
part swap --size=10240 --ondrive=sda
part / --size=8192 --grow --asprimary --ondrive=sda --fstype=xfs

# zerombr
zerombr

# Configure Firewall
firewall --enabled

# Configure Network Interfaces
network --onboot=yes --bootproto=dhcp --hostname=InterAACtionBox

# Configure Keyboard Layouts
keyboard fr

# Configure Language During Installation
lang fr_FR

# Services to enable/disable
services --disabled=mlocate-updatedb,mlocate-updatedb.timer,bluetooth,bluetooth.target,geoclue,avahi-daemon

# Configure Time Zone
timezone Europe/Paris

# Configure X Window System
xconfig --startxonboot

# Set Root Password
rootpw --iscrypted --lock 735927c6f8d4f916c9e584ccf82e7b696c42f7d2fa25906a0bddcf42595792bb

# Create User Account
user --name=interaactionbox --password=735927c6f8d4f916c9e584ccf82e7b696c42f7d2fa25906a0bddcf42595792bb --iscrypted --groups=wheel

# Package Selection
%packages
-openssh-server
-gssproxy
-nfs-utils
-sssd*
-abrt*
@anaconda-tools
@core
@standard
@hardware-support
@base-x
-@firefox
@fonts
-@libreoffice
@multimedia
@networkmanager-submodules
@printing
@xfce-desktop
-@development-tools
vim
NetworkManager-openvpn-gnome
-keepassxc
redshift-gtk
anaconda
anaconda-install-env-deps
anaconda-live
chromium
dracut-live
nodejs
-gimp
-gnucash
-duplicity
-calibre
irssi
nmap
tcpdump
ansible
-thunderbird
vlc
calc
gstreamer-plugins-ugly
gstreamer1-plugins-ugly
redhat-rpm-config
rpmconf
strace
-wireshark
ffmpeg
system-config-printer
git-review
gcc-c++
readline-devel
gcc-gfortran
libX11-devel
libXt-devel
zlib-devel
bzip2-devel
xz-devel
pcre-devel
libcurl-devel
python3-virtualenvwrapper
python3-devel
-golang
mariadb-server
transmission-gtk
libffi-devel
sqlite
exfat-utils
fuse-exfat
-jq
icedtea-web
-ristretto
argon2
-xournal
pykickstart
-evince
firejail
-ShellCheck
geteltorito
genisoimage
%end

# Post-installation Script
%post
# Disable IPv6
cat <<EOF >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

#Enable GPG keys for installed repos
cat <<EOF >> /etc/yum.repos.d/google-chrome.repo
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

#Push Chromium AFSR Policies
curl 'https://raw.githubusercontent.com/AFSR/kickstart-fedora-afsr/master/afsr_policy.json' > /etc/chromium/policies/managed/afsr_policy.json

#GazePlay Installation
cd ~/
git clone https://github.com/AFSR/GazePlay-AFSR.git GazePlay-AFSR
cd ~/GazePlay-AFSR
./gradlew release

#InterAACtionScene Installation
cd ~/
git clone https://github.com/AFSR/InteraactionScene-AFSR.git InteraactionScene-AFSR
cd ~/InteraactionScene-AFSR
npm install -g @angular/cli
npm install --save-dev @angular-devkit/build-angular
ng build

#AugCom Installation
cd ~/
git clone https://github.com/AFSR/AugCom-AFSR.git AugCom-AFSR
cd ~/AugCom-AFSR
ng build

%end

# Reboot After Installation
reboot --eject
