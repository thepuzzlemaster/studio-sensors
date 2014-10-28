
========================================================================================================================================
=========================================================================================================================================
==========================================================================================================================================

seattle studio sensor scheme: SS|SS

==========================================================================================================================================
=========================================================================================================================================
========================================================================================================================================

It is at present living here: 

http://162.242.237.33:3000/view?begindate=24032014&begintime=1600&enddate=24032014&endtime=1700

That's how you pull dates. This is how you pull zones:

http://162.242.237.33:3000/view?zone=1

Here's what it looks like:

[{"id":134,"sensor_id":1,"time":"2014-03-24T23:48:55.442Z","light":1,"sound":114,"movement":1,"temp":18,"humidity":147,"brightness":0},
{"id":135,"sensor_id":1,"time":"2014-03-24T23:49:20.120Z","light":1347,"sound":562,"movement":0,"temp":34,"humidity":3,"brightness":0}]

Whoa. That's JSON! That's right, JSON! Holy Shit!

The frog studio sensors log all their data up there to my server every 15 seconds. 

Ok, so we have a few things in there:

sensor_id: what sensor is it?
studio: what studio is it in?
zone: what part of the studio is it in?
time: that's a timestamp (ignore the Z, it just means it's using the current timezone, which, yeah, it is)
sound: scale from 50 - 400 (afaict)
movement: has anything moved in that zone in the last 30 seconds?
humidity: what's the relative humidity (percent)
temperature: Celsius
light: light frequency in values from 100-2000 with the relative color temperature of the light sensor
brightness: not being used right now

The arduino just logs its data using a URL like:

http://162.242.237.33:3000/?i=1&l=343&s=232&t=22&h=33&m=0

we're trying to keep the URL as short and simple as possible so that we can save space on the Arduino because it hardly has any memory.

Everything is in git but at present or until someone can figure out how the local server stuff is supposed to work, this badboy is staying simple and living on my server.

===============================================
SERVER INFO
===============================================

I have my server set up to use upstart to start up our node application, it's logging to :"/etc/init/studioapi.conf" at the moment so you can see what's going on with it.

I'm using ec2 ubuntu.

To get things set up I just did the following:

`sudo apt-get install postgres node`

then 

`sudo vim /etc/postgresql/9.3/main/postgresql.conf`

uncomment the line that says: `#listen_addresses = 'localhost' `
then
`sudo vim /etc/postgresql/9.3/main/pg_hba.conf`

then

`sudo service postgresql start`

then

```
sudo -i -u postgres
ubuntu@ip-172-31-30-171:~$ sudo -i -u postgres
postgres@ip-172-31-30-171:~$ psql
psql (9.3.5)
Type "help" for help.

ALTER USER postgres WITH PASSWORD '$password';
```

===============================================
DB INFO
===============================================

Creating the DB is pretty simple:

create database sensordata;

create table sensors ( studio varchar(3), zone varchar(10), id integer, constraint uid unique(id), ip varchar(16) );

create table readings ( id serial, sensor id int not null, time timestamp with time zone not null, light int not null, sound int not null, movement int not null, temp int not null, humidity int not null, brightness int not null, zone varchar(30) not null, studio varchar(30) not null);


