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
