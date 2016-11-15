class terminal {
	file { "/etc/xdg/xdg-xubuntu/xfce4/terminal/terminalrc":
		ensure => "file",
		content => template("terminal/terminalrc.erb"),
	}
}
