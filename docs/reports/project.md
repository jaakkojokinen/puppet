## Mini project 

### Test Environment
- Macbook Pro (early 2011) 
- Xubuntu 16.04 on VirtualBox (Version 5.0.30 r112061)

### Rest API Automation

For the last course assigment I wrote a module that installs and initializes the Express rest API to Ubuntu 16.04 server. In my tests I used mLab's Database-as-a-Service for MongoDB deployment. 

### Project tree

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-12-12%20at%2015.40.41.png?raw=true)

### Init.pp

```puppet
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
```

### Template Files

This application covers the CRUD functions and can be tested with the Postman or with the curl tool straight from the command line. I initially wrote this for another project but ended up to use Firebase backend instead. 

The database item in the example is 'plant', because of the initial project. It can be easily refactored to anything. Also the mongoose.connect URI has to be replaced with the real one if the application is tested.

#### Server.js

```javascript
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
mongoose.connect('mongodb://<dbuser>:<dbpassword>@ds059496.mlab.com:59496/plants');

var Plant = require('./app/models/plant');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 8080;

var router = express.Router(); 

router.use(function(req, res, next) {
	// do logging
	console.log('Something is happening.');
	next(); // make sure we go to the next routes and don't stop here
    });

router.get('/', function(req, res) {
	res.json({ message: 'router get'  });
});

router.route('/plants')
// plant create
    .post(function(req, res) {
        
	    var plant = new Plant();
	    plant.name = req.body.name;

	    plant.save(function(err) {
		    if (err)
			res.send(err);
		    res.json({ message: 'Plant added!' });
		});
	})
		// get plant
	.get(function(req, res) {
		Plant.find(function(err, plants) {
			if (err)
			    res.send(err);
			
			res.json(plants);
		    });
	    });

router.route('/plants/:plant_id')
    .get(function(req, res) {
	    Plant.findById(req.params.plant_id, function(err, plant) {
		    if (err)
			res.send(err);
		    res.json(plant);
		});
	})

    .put(function(req, res) {
	    Plant.findById(req.params.plant_id, function(err, plant) {
		    if (err)
			res.send(err)
		    plant.name = req.body.name;
		    
		    plant.save(function(err) {
			    if (err)
				res.send(err)
			    res.json({ message: 'plant udated!' });
			});
		});
	})

    .delete(function(req, res) {
	    Plant.remove({
		    _id:  req.params.plant_id
			}, function(err, plant) {
		    if (err)
			res.send(err);

		    res.json({ message: 'Successfully deleted' });
		});
	});

app.use('/api', router);

app.listen(port);
console.log('console log on port ' + port);
```

#### Plant.js

```javascript
var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var PlantSchema   = new Schema({
	name: String
});

module.exports = mongoose.model('Plant', PlantSchema);
```

Templates also include package.json which is not presented here. 

### Results

```
sudo puppet apply -e 'class{express:}'
```

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-12-12%20at%2016.19.57.png?raw=true)

Test for http GET.

```
curl -i -H "Accept: application/json" -H "Content-Type: application/json" http://10.0.1.6:8080/api/plants/
```

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-12-12%20at%2016.28.05.png?raw=true)

Test for http POST.

```
curl --data "param1=name&param2=shrubbery" http://10.0.1.6:8080/api/plants/
```

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-12-12%20at%2016.54.05.png?raw=true)


### References

http://terokarvinen.com/2016/aikataulu-linuxin-keskitetty-hallinta-ict4tn011-10-loppusyksy-2016

https://scotch.io/tutorials/build-a-restful-api-using-node-and-express-4

https://mlab.com

https://www.puppetcookbook.com

https://docs.puppet.com/puppet/3.8/

http://askubuntu.com/questions/299870/http-post-and-get-using-curl-in-linux




