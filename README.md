# Flood Risk Back Office

[![Circle CI](https://circleci.com/gh/EnvironmentAgency/flood-risk-back-office/tree/master.svg?style=svg&circle-token=690d1e5fe311a8bbc2b80af8bb70a0d0876b072e)](https://circleci.com/gh/EnvironmentAgency/flood-risk-back-office/tree/master)

This is a private repo used to build Flood Risk admin features for internal users.

## Installation

Clone the repository, copying the project into a working directory

```bash
git clone https://github.com/EnvironmentAgency/flood-risk-back-office.git
```

Then run

```bash
bundle install
```

to download the dependencies. If you do not have [bundler](http://bundler.io/) you can either install it directly or install the rails gem first which comes with bundler.

## Seeding data

Seed the data (e.g. users) locally with `$ bundle exec rake db:seed`.

To seed on Heroku where the environment is PRODUCTION,
connect to a non-visitor and non-office network and run

```
$ heroku run bash -a [heroku_app_name]
% bundle exec rails c
% require './db/seeds/development.rb'
% FloodRiskEngine::Engine.load_seed # loads exemptions seed data
% exit
% exit
```

## Start the service

To start the service locally simply run

```bash
bundle exec rails s
```

You can then access the web site at <http://localhost:3000>.

## Tests

We use [RSpec](http://rspec.info/) for unit testing

To execute the unit tests simply enter

```bash
bundle exec rspec
```

## License

No License

Copyright [2015] [EnvironmentAgency]
