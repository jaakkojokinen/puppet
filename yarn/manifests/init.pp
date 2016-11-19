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
