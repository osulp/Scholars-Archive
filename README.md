# Development with docker-stack

## Install Docker and dependencies
Using homebrew, install docker and related programs with:
```
$ brew install docker
$ brew install docker-machine
$ brew install docker-compose
```
Ensure a default machine is built, started, and necessary ENV variables are set. *Consider adding the `eval "$(docker-machine env)"` to your shell init (.zshrc, or .bashrc).*
```
$ docker-machine create default
$ docker-machine start default
$ eval "$(docker-machine env)"
```
## Verify `config/local_env.yml` is properly configured
- ### Find docker-machine's IP address and take note of it
```
$ docker-machine ip
# 192.168.99.100
```
This configuration holds the environment variables for running a server locally for development. The `config/local_env.example.yml` is a great example to start with.

When using docker-stack, special consideration should be made for the configurations related to fedora, solr, and redis. **You must change the hostname/url from `localhost` to match the docker-machine `IP` address for these configurations to work within the docker hosted servers.**
## Start a development environment
- ### Run docker-stack (currently for fedora, solr, redis)
```
$ bundle exec rails docker:dev:up
```
- ### Run rails server
```
$ bundle exec rails s
```
- ### Run sidekiq
```
$ bundle exec sidekiq
```
