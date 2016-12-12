class express {
	package { 'nodejs':
		ensure => '4.2.*',
		allowcdrom => 'true',
	}

	package { 'npm':
		ensure => 'installed',
		allowcdrom => 'true',
	}

	file { ['/opt/express', '/opt/express/app', '/opt/express/app/models']: 
		ensure => 'directory',
	}

	file { '/opt/express/server.js':
		content => template('express/server.erb'),
 	}

	file { '/opt/express/app/models/plant.js':
 		content => template('express/plant.erb'),
	}

	file { '/opt/express/package.json':
		content => template('express/package.erb'),
	}

	Exec { path => '/usr/local/bin/:/bin/:/usr/bin' }

	exec { 'install':
		command => 'npm install',
		creates => '/opt/express/node_modules',
		cwd => '/opt/express/',
	}

	exec { 'pm2':
		command => 'npm install pm2 -g',
		creates => '/usr/local/lib/node_modules/pm2',
	}

	exec { 'run':
		command => 'pm2 start server.js',
		unless => 'ps auxww |grep "[s]erver.js"',
    cwd => '/opt/express/',
		logoutput => 'true',
	}
}
