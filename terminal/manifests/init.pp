class terminal {
	file { "/etc/nanorc":
		ensure => "file",
		content => template("terminal/nanorc.erb"),
	}
}
