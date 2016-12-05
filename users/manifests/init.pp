class users {
  user { 'jaakko':
		comment => 'Jaakko Jokinen',
		ensure => 'present',
		password => '$1$jtPJgp5A$NhvTLEmj2V5qxCs1N6DhJ0',
		managehome => true,
  }

}

