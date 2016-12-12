class users {
  user { 'jaakko':
		comment => 'Jaakko Jokinen',
		ensure => 'present',
		password => '$1$j.zjP0iG$RaopTvU99StlZCyFq/oE51',
		managehome => true,
  }

}

