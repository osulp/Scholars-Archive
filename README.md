# Development with Docker

## Requirements
The details provided assume that the official Docker daemon is running in the background. Download and install Docker Community Edition from https://www.docker.com/community-edition.

**Suggested:** If using ohmyzsh (http://ohmyz.sh/), add the docker-compose plugin to the .zshrc for better command-line aliases and integration.

**Important:** _By default, using the included `.env` file, docker will run the services in the context of `RAILS_ENV=development`_.

# Docker Compose basics
## Build the base application container
`$ docker-compose build`

## Start all of the services

`$ docker-compose up` : Start the containers in the foreground
`$ docker-compose up -d` : Start the containers in the background

## Run any command on the web application container
_$ docker-compose exec web [COMMAND]_

`$ docker-compose exec web bundle exec rails c` : Open the rails console

`$ docker-compose exec web bundle exec rspec` : Run the tests

### Running commands that alter the local filesystem
When you do anything that changes the filesystem (rake tasks or otherwise), you may want to pass through your user ID so that on your local filesystem you still own the files:

`$ docker-compose exec -u 1000 workers rake -T`
(Your user id may or may not be 1000 - use id -g or similar to find your actual user id)

Ohmyzsh with the docker-compose plugin makes executing these types of commands easier:

`$ dce web bundle exec rails c` : Equivilent for docker-compose exec ...

# Local development
Use Docker to expose the app to localhost (so you can just visit http://localhost instead of finding the app's IP address assigned by Docker), do this:

`$ cp docker-compose.override.example.yml docker-compose.override.yml`

You can also customize that file to expose ports for things like Solr or Fedora, Redis, etc.

# Attaching a debugger to the web application
`$ cp docker-compose.override.example.yml docker-compose.override.yml`

Uncomment the line that runs the application using rdebug-ide:

`#command: bash -c "rm -f tmp/pids/server.pid && bundle exec rdebug-ide --host 0.0.0.0 --port 1234 -- bin/rails server -p 3000 -b 0.0.0.0"`

Attach the debugger to the container, the steps to do this are specific to the IDE;
-  RubyMine: Create a new debug configuration and point it at localhost, port 1234, with the dispatcher port 26162 (these are the standard defaults for Ruby), and use the remote work directory `/data`.
- VSCode: Open the debug view, edit the `launch.json` by clicking the gear icon. Update the launch configuration titled "Listen for rdebug-ide" to match the following:
```
{
  "name": "Listen for rdebug-ide",
  "type": "Ruby",
  "request": "attach",
  "cwd": "${workspaceRoot}",
  "remoteHost": "localhost",
  "remotePort": "1234",
  "remoteWorkspaceRoot": "/data",
  "showDebuggerOutput": true
},
```

# Running specs
Docker and local configurations are structured such that setting `RAILS_ENV=test` before bringing up the docker services will set SOLR and Fedora connections to use the proper index/repository. There are two database services configured (best practice for MySQL in docker), and the other services are configured to handle both `development` and `test` environments properly.

## Bring up docker in the test environment
```
$ docker-compose down
$ RAILS_ENV=test docker-compose up

# after the services have finished booting, in another window

$ docker-compose run web bundle exec rspec
# ... watch the tests run
```
