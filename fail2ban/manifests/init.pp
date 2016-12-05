class fail2ban {
        package { 'fail2ban':
                ensure => 'installed',
        }

        service { 'fail2ban':
                enable => 'true',
                ensure => 'true',

        }
}
