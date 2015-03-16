Scholars Archive
===========================

Project Hydra powered institutional repository for Oregon State University
Libraries & Press


Setup
-----------------
1. Run `bundle install`
2. Run `rake db:migrate`
3. Run `rake jetty:clean`
4. Run `rake sufia:jetty:config`
5. Run `rake jetty:start`

All rails commands after that should work appropriately.
