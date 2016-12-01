### Week 1
This is documentation for the Linux configuration management course by Tero Karvinen in Haaga-Helia University of Applied Sciences. 

### Test environment
- Macbook Pro (early 2011) 
- Xubuntu 16.04 on VirtualBox (5.0.28 r111378) / Puppet version 3.8.5
- Raspberry Pi 3 model B / Raspbian GNU/Linux 8 (jessie) / Puppet version 3.7.2
- Raspberry Pi 1 model B+ / Raspbian GNU/Linux 8 (jessie) / Puppet version 3.7.2

### The Agent / Master Architecture
Assingment was to control agent computer(s) over the network with Puppet. First I configured new hostnames to computers. 
```
sudo hostnamectl set-hostname archvm
sudoedit /etc/hosts
```
Inside the file I added hostname archvm after jaakko-VirtualBox.
```
127.0.0.1       localhost
127.0.1.1       jaakko-VirtualBox archvm
```
With RasPis the file content differs. I used two agents and named them puppi & puppit.
```
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

127.0.1.1       raspberrypi puppi
```
```
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

127.0.1.1       raspberrypi puppit
```
Restart of the avahi daemon is required.
```
sudo service avahi-daemon restart
```
Now I was able to ping between the computers using the new hostnames.
```
pi@puppi:/etc/puppet $ ping -c 1 archvm.local
PING archvm.local (10.0.1.15) 56(84) bytes of data.
64 bytes from 10.0.1.15: icmp_seq=1 ttl=64 time=8.47 ms

--- archvm.local ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 8.473/8.473/8.473/0.000 ms
```
```
jaakko@archvm:/etc/puppet$ ping -c 1 puppi.local
PING puppi.local (10.0.1.12) 56(84) bytes of data.
64 bytes from 10.0.1.12: icmp_seq=1 ttl=64 time=13.4 ms

--- puppi.local ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, 
```

### Configuring Master
```
sudo apt-get update
sudo apt-get install -y puppetmaster
```
To create new certificates, the puppet process has to be stopped and default ssl directory needs to be removed. With sudo ls it is possible to check the contents of directory and sudo rm -r to destroy it. It is good to stop to think again before executing sudo rm -r in any conditions.
```
sudo service puppetmaster stop
sudo ls /var/lib/puppet/ssl/
sudo rm -r /var/lib/puppet/ssl/
```

```
sudoedit /etc/puppet/puppet.conf
```
New hostname is added into the puppet.conf file. This goes under the [master] section. 
```
dns_alt_names = archvm.local
```
Then starting the puppet will generate new /var/lib/puppet/ssl/ directory with new certificate.
```
sudo service puppet start
```

### Configuring agent

```
sudo apt-get update
sudo apt-get install -y puppet 
```
Add new [agent] section and set the master there inside the config file.
```
sudoedit /etc/puppet/puppet.conf
```
```
[agent]
server = archvm.local
```

```
sudo puppet agent --enable
sudo service puppet restart
```

### Sign the Cert from master and test from agents

```
sudo puppet cert --sign puppi.pp.htv.fi
sudo puppet cert --sign puppit.pp.htv.fi
```

```
sudo puppet agent -t
```

I used helloworld module to test how agents are taking orders. Here are the results in printscreens.
This module can be found from repository of this page. 

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/prints.png?raw=true)

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/prints2.png?raw=true)

### Sources

This document is heavily based on 2012 post by Tero Karvinen http://terokarvinen.com/2012/puppetmaster-on-ubuntu-12-04

https://docs.puppet.com/puppet/3.8/reference/config_file_main.html



## Week 3

### Test environment
- Macbook Pro (early 2011) 
- Xubuntu 16.04 on VirtualBox (5.0.28 r111378) / Puppet version 3.8.5

### Configuring terminal settings with puppet
Assingment was to configure desktop settings with puppet and to push them to VCS. I tried to configure terminal color settings because I always change those anyway. First I created the init.pp file.

```puppet
class terminal {
	file { "/home/jaakko/.config/xfce4/terminal/terminalrc":
		ensure => "file",
		content => template("terminal/terminalrc.erb"),
	}
}
```

I also tested with another file path. This will change the colors for all the users, not just me.

```puppet
class terminal {
	file { "/etc/xdg/xdg-xubuntu/xfce4/terminal/terminalrc":
		ensure => "file",
		content => template("terminal/terminalrc.erb"),
	}
}
```

Default terminal settings can be found from file ~/.config/xfce4/terminal/terminalrc or from /etc/xdg/xdg-xubuntu/xfce4/terminal/terminalrc. The latter is for configuring settings system wide. 

/etc/xdg/xdg-xubuntu/xfce4/terminal/terminalrc
```
[Configuration]
FontName=DejaVu Sans Mono 9
ColorForeground=#b7b7b7
ColorBackground=#131926
ColorPalette=#000000;#aa0000;#44aa44;#aa5500;#0039aa;#aa22aa;#1a92aa;#aaaaaa;#777777;#ff8787;#4ce64c;#ded82c;#295fcc;#cc58cc;#4ccce6;#ffffff
ColorSelection=#163b59
ColorSelectionUseDefault=FALSE
ColorCursor=#0f4999
ColorBold=#ffffff
ColorBoldUseDefault=FALSE
TabActivityColor=#0f4999
```

~/.config/xfce4/terminal/terminalrc
```
[Configuration]
ColorForeground=#b7b7b7
ColorBackground=#131926
ColorCursor=#93a1a1
ColorSelection=#163b59
ColorSelectionUseDefault=FALSE
ColorBoldUseDefault=FALSE
ColorPalette=#000000;#aa0000;#44aa44;#aa5500;#0039aa;#aa22aa;#1a92aa;#aaaaaa;#777777;#ff8787;#4ce64c;#ded82c;#295fcc;#cc58cc;#4ccce6;#ffffff
FontName=DejaVu Sans Mono 9
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=80x24
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscToolbarDefault=FALSE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscScrollAlternateScreen=TRUE
TabActivityColor=#0f4999
```

New values for the keys ColorForeground, ColorBackground and ColorPalette. I defined these in the templates/terminalrc.erb file.

```
ColorForeground=#93a1a1
ColorBackground=#002b36
ColorPalette=#002b36;#dc322f;#859900;#b58900;#268bd2;#6c71c4;#2aa198;#93a1a1;#657b83;#cb4b16;#073642;#586e75;#839496;#eee8d5;#d33682;#fdf6e3
```

```
sudo puppet apply -e 'class{terminal:}'
sudo apt-get update
sudo apt-get install -y tree
```

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-11-15%20at%2014.02.21.png?raw=true)


### Sources
https://www.puppetcookbook.com

List of ready-to-use color configurations
https://github.com/chriskempson/base16-xfce4-terminal

http://askubuntu.com/questions/151403/xubuntu-how-to-restore-default-terminal-text-coloring


## Week 5

### Test environment
- Macbook Pro (early 2011) 
- Xubuntu 16.04 on VirtualBox (5.0.28 r111378)
- Lenovo ThinkPad X200s
- Cisco epc3010
- Cisco epc3825

### Netboot and OS installation

This week I tried to install operation system (Linux Xubuntu) to another computer over the network. I had to rethink and setup my home network to be able to connect new computer via ethernet cable. Normally I just use wifi and my router-in-use has no ethernet cable ports. This is what my home network looked like during the test:

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/hnw.jpg?raw=true)

### Tools and DHCP

First I installed required packages and configured DHCP server.

```
sudo apt-get update
sudo apt-get install -y arpwatch
sudo apt-get install -y wakeonlan
```

I checked the mac address of the target computer and tested wakeonlan.

```
wakeonlan 00:1f:16:13:0e:bd
```


I logged in to the epc3825 setting to turn off the dhcp server. Settings page can be found from 192.168.0.1. After this I checked the ip-address with ifconfig. Before turning off the DHCP server from the modem, I got the ip from space 192.168.0.* but now it changed to 82.181.247.8. More packages needed at this point.

```
sudo apt-get install -y isc-dhcp-server
ifconfig
sudoedit /etc/default/isc-dhcp-server
```

The file isc-dhcp-server must include the network adapter name of the host computer.

```
INTERFACES="enp0s3"
```

The final version of dhcpd.conf file looks like this. I had to change and test 10 different configurations before getting it work to the point I got with this assignment.
I used a template made by Tero Karvinen. http://terokarvinen.com/2016/aikataulu-palvelinten-hallinta-ict4tn022-1-5-op-uusi-ops-loppusyksy-2016

```
sudoedit /etc/dhcp/dhcpd.conf
```
```
ddns-update-style none;
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;
default-lease-time 600;
max-lease-time 7200;
log-facility local7;

authoritative; 

next-server 82.181.247.8; # TFTP server ip address
filename "pxelinux.0"; # name of bootloader image

subnet 82.181.240.0 netmask 255.255.248.0 {
	host jaakko {
		hardware ethernet 00:1f:16:13:0e:bd;
		fixed-address 82.181.240.1;
		option subnet-mask 255.255.248.0;
		option routers 82.181.247.254;
		option domain-name-servers 8.8.8.8;
		option domain-name "archvm";
	}
}
```

```
sudo service isc-dhcp-server restart
```

Then I tried to wakeonlan again, with the result 

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/IMG_1874.jpg?raw=true)

## TFTP and preseed  

I downloaded netboot installer from archive.ubuntu.com, extracted the contents, installed the tftp-hpa & tftpd-hpa packages and copied the contents to correct location.

```
wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-i386/current/images/netboot/netboot.tar.gz
tar xf netboot.tar.gz 
sudo apt-get -y install tftp-hpa tftpd-hpa
rm netboot.tar.gz
sudo cp -r * /var/lib/tftpboot/
```

My target computer has 32bit processor, so I used installer-i386 image. I used syslinux.cfg template made by Joona Leppälahti. 

```
sudoedit /var/lib/tftpboot/ubuntu-installer/i386/boot-screens/syslinux.cfg 
```

```
# D-I config version 2.0
# search path for the c32 support libraries (libcom32, libutil etc.)
path ubuntu-installer/i386/boot-screens/
include ubuntu-installer/i386/boot-screens/menu.cfg
default ubuntu-installer/i386/boot-screens/vesamenu.c32

label pxemania
        kernel ubuntu-installer/i386/linux append initrd=ubuntu-installer/i386/initrd.gz auto=true auto url=tftp://82.181.247.8/ubuntu-installer/i386/preseed.cfg locale=en_US.UTF-8 classes=minion DEBCONF_DEBUG=5priority=critical preseed/url/=ubuntu-installer/i386/preseed.cfg netcfg/choose_interface=auto

prompt 1
timeout 5
default pxemania
```

With preseed it's possible to automate installation by defining the anwsers for installation questions. I tried to use Joona's preseed file but it didn't work out in my environment. I could access the boot manager, but always got the "Bad archive mirror" error message. 

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/IMG_1890.jpg?raw=true)

## Conclusions

I'm not sure what was the reason for bad mirror error. During the test I also tried netboot with DHCP server turned on from epc3825 settings. With that I couldn't get in the boot manager at all. 

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/IMG_1887.jpg?raw=true)

It could have been better to do this assignment in school's laboratory environment because then I wouldn't have to think about router configs and reset them. During the test my router obviously updated itself with newer firmware and the config pages changed and some settings turned inaccessible. Anyway this assignment was very instructive and fun to do.

## Sources

https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-8/
http://terokarvinen.com/2016/aikataulu-palvelinten-hallinta-ict4tn022-1-5-op-uusi-ops-loppusyksy-2016
http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-i386/current/images/netboot/ 
https://wiki.debian.org/DebianInstaller/Preseed
