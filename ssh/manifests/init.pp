class ssh {
	file { '/etc/ssh/sshd_config':
		content => template('ssh/sshd_config.erb'),
	}
}
