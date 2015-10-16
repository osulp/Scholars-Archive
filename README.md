Scholars Archive
===========================
[![Circle CI](https://circleci.com/gh/osulp/Scholars-Archive.svg?style=svg)](https://circleci.com/gh/osulp/Scholars-Archive)
[![Coverage Status](https://coveralls.io/repos/osulp/Scholars-Archive/badge.svg)](https://coveralls.io/r/osulp/Scholars-Archive)

Project Hydra powered institutional repository for Oregon State University
Libraries & Press


Setup
-----------------
1. Run `bundle install`
2. Run 'cp config/config.example.yml config/config.yml '
3. Run `rake db:migrate`
4. Run `rake jetty:clean`
5. Run `rake sufia:jetty:config`
6. Run `rake jetty:start`

All rails commands after that should work appropriately.
