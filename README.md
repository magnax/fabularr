# What is this?

Fabular is a free, browser-based, fabular game / society simulator.
It is text-based, slow pace, role-playing game (RPG), where you can interact with other players, build, travel and explore.

# Tech stack

Ruby: 3.4
Rails: 8.1.2
PostgreSQL: 18

# Local installation

## Prerequisites

### libsass

Unfortunately in Omarchy 4 there is one caveat with `sass-rails` gem. You have to install `libsass` package and then create symlink from `/usr/lib/libsass.so` to `sassc` gem directory.

### redis

You have to install redis and run redis server in order to be able to process background jobs.

### docker & docker compose

### Overmind (convenience)

Overmind is a process manager for `Procfile` files, like `foreman` but with some improvements.
Install it with:
```
gem install overmind
```

and then use commands:
`overmind start` - start all processes from Procfile,
`overmind stop` - stop all processes
`overmind connect [name]` - connect to process (ie. 'web')

## .env file

Create `.env` file with correct credentials in your app folder.

## DB create and seed:

```
rails db:create
rails db:migrate
rails db:seed
```

After this you should have some test data in your database.
