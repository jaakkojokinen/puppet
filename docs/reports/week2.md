## Week 2
### The Agent / Master Architecture
Assignment was to Assingment was to control agent computer(s) over the network with Puppet. First I configured new hostnames to computers. 

### Test environment
- Macbook Pro (early 2011) 
- Xubuntu 16.04 on VirtualBox (5.0.28 r111378) / Puppet version 3.8.5
- Raspberry Pi 3 model B / Raspbian GNU/Linux 8 (jessie) / Puppet version 3.7.2
- Raspberry Pi 1 model B+ / Raspbian GNU/Linux 8 (jessie) / Puppet version 3.7.2


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
