# Development with Docker

## Requirements

The details provided assume that the official Docker daemon is running in the background. Download and install Docker Community Edition from https://www.docker.com/community-edition.

**Suggested:** If using ohmyzsh (http://ohmyz.sh/), add the docker-compose plugin to the .zshrc for better command-line aliases and integration.

# Docker notes

- `$ docker system prune` : A command that will reclaim disk space by deleting stopped containers, networks, dangling images and build cache.
- `$ docker volume ls` : Show a list of named volumes which hold persistent data for containers.
- `$ docker volume rm [VOLUME NAME]` : Remove a named volume, to force the system to rebuild and start that services persistent data from scratch.

# Docker Compose basics

## Build the base application container

**Important:** Rebuilding the docker container is required whenever Gemfile or Dockerfile updates affect the application.

`$ docker-compose build server`

## Start all of the services

- `$ docker-compose up server` : Start the containers in the foreground
- `$ docker-compose up -d server` : Start the containers in the background

## Create admin set and collection types, load workflows, create admin role

- The first time you start the services or after you delete volumes you will need to run:
  `$ docker-compose exec server ./build/firstrun.sh`

## Create an administrator

- Visit the site and login with OSU credentials to create a user account. (http://test.library.oregonstate.edu:3000)
- Create an 'admin' role and add that role to the user account.

```
$ docker-compose exec server bundle exec rails c

# within the Rails Console;
Role.create(name: 'admin')
User.first.roles << Role.first
```

## Run any command on the server application container

_$ docker-compose exec server [COMMAND]_

- `$ docker-compose exec server bash` : Open a terminal session on the server container
- `$ docker-compose exec server bundle exec rails c` : Open the rails console
- `$ docker-compose exec server bundle exec rubocop` : Run rubocop

### Running commands that alter the local filesystem

When you do anything that changes the filesystem (rake tasks or otherwise), you may want to pass through your user ID so that on your local filesystem you still own the files:

`` $ docker-compose exec -u `id -u` workers rake -T ``
(`id -u` will return your user id. Note the use of backticks `` ` `` rather than quotes)

Ohmyzsh with the docker-compose plugin makes executing these types of commands easier:

`$ dce server bundle exec rails c` : Equivalent for docker-compose exec ...

# Local development

Use Docker to expose the app to localhost (so you can just visit http://localhost instead of finding the app's IP address assigned by Docker), do this:

`$ cp docker-compose.override.example.yml docker-compose.override.yml`

Some values in this override will be necessary for certain functionality. Ask a developer for these values.

You can also customize that file to expose ports for things like Solr or Fedora, Redis, etc.

# Attaching a debugger to the web application

`$ cp docker-compose.override.example.yml docker-compose.override.yml`

Uncomment the line that runs the application using rdebug-ide:

`#command: bash -c "rm -f tmp/pids/server.pid && bundle exec rdebug-ide --host 0.0.0.0 --port 1234 -- bin/rails server -p 3000 -b 0.0.0.0"`

Attach the debugger to the container, the steps to do this are specific to the IDE;

- RubyMine: Create a new debug configuration and point it at localhost, port 1234, with the dispatcher port 26162 (these are the standard defaults for Ruby), and use the remote work directory `/data`.
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
$ docker-compose up test

# after the services have finished booting, in another window

$ docker-compose exec test bundle exec rspec
# ... watch the tests run
```

# Help? Something is broken.

## There are no workflows in the system.

This can happen if the rake task fails to load because there are no permission templates in the database to match those in Fedora. At minimum, the Default Admin Set must exist and can be created manually in the Rails console;

`Hyrax::PermissionTemplate.create!(source_id: AdminSet::DEFAULT_ID)`

Following this fix, run the workflow load rake task:

`$ docker-compose exec server bundle exec rails hyrax:workflow:load`

## The server container logged **ERROR: Default admin set exists but it does not have an associated permission template.**

This can happen if the database volume was removed but the Fedora volume was not, these two are out of sync. This can be fixed in a couple of ways on the Rails console:

```
    You could manually create the permission template in the rails console (non-destructive):

      Hyrax::PermissionTemplate.create!(source_id: AdminSet::DEFAULT_ID)

    OR you could start fresh by clearing Fedora and Solr (destructive):

      require 'active_fedora/cleaner'
      ActiveFedora::Cleaner.clean!

    FINALLY you could destroy all volumes and start from scratch (aggressively destructive)

    docker-compose down -v && docker-compose up server
```

Following this fix, run the workflow load rake task:

`$ docker-compose exec server bundle exec rails hyrax:workflow:load`

## Fedora reports 403 Unauthorized error

This is likely due to the Fedora repo address passed to the Rails app being incorrect. Earlier local standards used `local_env.yml` which overrode ENV variables passed in. If Fedora is running and the Rails app can't interact with it, check the ENV value that is passed to Rails. From the console, run `ENV.fetch('SCHOLARSARCHIVE_FEDORA_URL')`
