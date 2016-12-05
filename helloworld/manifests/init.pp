class helloworld {
	file { '/tmp/helloworld':
		ensure => present,
		mode => "0444",
		content => "helloo world\n"
	}
}
