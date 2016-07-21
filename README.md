Scholars Archive
===========================
[![Circle
CI](https://circleci.com/gh/osulp/Scholars-Archive.svg?style=svg)](https://circleci.com/gh/osulp/Scholars-Archive)
[![Coverage
Status](https://coveralls.io/repos/osulp/Scholars-Archive/badge.svg)](https://coveralls.io/r/osulp/Scholars-Archive)

Project Hydra powered institutional repository for Oregon State University
Libraries & Press


Setup
-----------------
1. Run `bundle install`
2. Run `cp config/config.example.yml config/config.yml`
3. Make appropriate configuration changes to config/config.yml for CAS
3. Run `rake db:migrate`
4. To run a development environment, in another terminal run `rake scholars_archive:server`

Testing
-----------------
The rake task, `scholars_archive:ci` will setup the test environment and run the test suite.

All rails commands after that should work appropriately.

CAS will need to be set up for logins to work, values go in config/config.yml.
Also when developing locally an approved site URL must make the request, so you
will need to edit your hosts file so localhost or similar is not sent to the CAS
service.
