class terminal {
	file { "/home/xubuntu/.config/xfce4/terminal/terminalrc":
		ensure => "file",
		content => template("terminal/terminalrc.erb"),
	}
}
