class helloworld {
	file { '/tmp/helloworld':
		ensure => present,
		mode => "0444",
		content => "hello world\n"
	}
}
