class users {
  user { 'jaakko':
		comment => 'Jaakko Jokinen',
		ensure => 'present',
		password => '',
		managehome => true,
  }

}

