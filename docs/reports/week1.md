### Week 1
## First Puppet module

First assignment was to write a Puppet module that use at least two different resource types. 

### Test environment
- Macbook Pro (early 2011) 
- Xubuntu 16.04 on VirtualBox (5.0.28 r111378) / Puppet version 3.8.5

## Apache module

I tested a simplified version of apache module posted by Tero Karvinen to terokarvinen.com at 27th of October 2016. 

```puppet
class apache {
	package { "apache2":
		ensure => "installed",
		allowcdrom => "true",
	}

	file { "/var/www/html/index.html":
		content => template("apache/index.erb"),
	}

	service { "apache2":
		ensure => "true",
		enable => "true",
		provider => 'systemd',		
	}
}
```

This module installs apache2 package, overwrites default apache server page and enables apache service at boot. 

```
sudo puppet apply -e 'class{apache:}'
```

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-12-05%20at%2014.40.23.png?raw=true)

### Sources

http://terokarvinen.com/2016/aikataulu-palvelinten-hallinta-ict4tn022-1-5-op-uusi-ops-loppusyksy-2016

