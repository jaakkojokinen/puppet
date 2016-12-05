### Week 4
## Yarn module 

Assignment was to look for public Puppet modules and try to use them in own configurations. I tried couple of modules from USGCB and from Github but then I got side tracked and tried something different. 

When I wrote this module, there was no Yarn dpkg package for Ubuntu available so I tried to automate the installation with Puppet. Staying loyal to assignment, I got the idea for the module from this Github repository: https://github.com/artberri/puppet-yarn

Yarn is faster (than npm) package manager for nodejs.

```puppet
class yarn {
  package { 'curl': ensure => installed }
  package { 'nodejs': ensure => 'latest' }

  exec { 'curl':
    command => 'curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -',
    onlyif => 'dpkg --list curl',
    path => '/usr/local/bin/:/bin/:/usr/bin',
  }

  exec { 'echo':
    command => 'echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list',
    path => '/usr/local/bin/:/bin/:/usr/bin',
  }

  exec { 'npm_install_yarn':
    command => 'sudo apt-get update && sudo apt-get install yarn',
    onlyif => 'dpkg --list nodejs',
    path => '/usr/local/bin/:/bin/:/usr/bin',
  }
}
```

This module might still be useful if latest versions of nodejs and yarn are required in development. 

```
sudo puppet apply -e 'class{yarn:}'
```

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-12-05%20at%2014.53.53.png?raw=true)

### Sources

https://github.com/artberri/puppet-yarn
https://yarnpkg.com/en/docs/install#linux-tab
https://github.com/yarnpkg/yarn

https://usgcb.nist.gov/usgcb/rhel/download_rhel5.html
