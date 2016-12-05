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
