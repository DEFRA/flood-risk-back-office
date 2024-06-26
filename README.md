# Flood risk back office

![Build Status](https://github.com/DEFRA/flood-risk-back-office/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_flood-risk-back-office&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_flood-risk-back-office)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_flood-risk-back-office&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_flood-risk-back-office)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

A Ruby on Rails application delivering the [Flood risk activity exemptions service](https://register-flood-risk-exemption.service.gov.uk).

This is a thin, host application which mounts and provides styling for the [flood_risk_engine](https://github.com/DEFRA/flood-risk-engine) rails engine, and adds functionality specific to internal users. The engine is responsible for the service implementation.

## Prerequisites

Please make sure the following are installed:

- [Ruby 3.2.2](https://www.ruby-lang.org) installed for example via [RVM](https://rvm.io) or [Rbenv](https://github.com/sstephenson/rbenv/blob/master/README.md)
- [Bundler](http://bundler.io/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Postgresql](http://www.postgresql.org/download)
- [Phantomjs](https://github.com/teampoltergeist/poltergeist#installing-phantomjs)

## Installation

Clone the repository and install its gem dependencies

```bash
git clone https://github.com/DEFRA/flood-risk-back-office.git
cd flood-risk-back-office
bundle
```

### .env

The project uses the [dotenv](https://github.com/bkeepers/dotenv) gem to load environment variables when the app starts. **Dotenv** expects to find a `.env` file in the project root.

Duplicate `.env.example` and rename the copy as `.env`

Open it and update `SECRET_KEY_BASE` and the settings for database, email etc.

### Database

The usual rails commands can be used to manage the databases for example

```bash
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

Add `RAILS_ENV=test` to the commands when preparing the test database.

### Geospatial Queries

The application uses [PostGIS](https://postgis.net/) [rgeo](https://rubygems.org/gems/rgeo) for geospatial queries. The [activerecord-postgis-adapter](https://github.com/rgeo/activerecord-postgis-adapter) gem adds geospatial datatypes to PotgreSQL and supports geospatial queries. The adapter is enabled by defining the database adapter as `postgis` instead of `postgresql` in `database.yml`:

```
adapter: postgis
```

The application also uses [rgeo-geojson](https://github.com/rgeo/rgeo-geojson) to parse an Environment Agency dataset of Water Management Area boundaries. A copy of the dataset is stored in JSON format in a zip archive under `lib/fixtures/files` and loaded using the once-off Rake task `load_admin_areas`.

Note that postgis is also required when running automated unit tests within GitHub CI. To support this, `ci.yml` specifies the use of a docker image which runs `PostgreSQL` with the `postgis` adapter:

```
image: postgis/postgis:10-2.5
```

## Running the app

To start the service locally run

```bash
bundle exec rails s
```

You can then access the web site at http://localhost:3000

## GOV.UK Notify

The project uses [Notify](https://www.notifications.service.gov.uk/using-notify/get-started) to send email. It does this using Notify's [web API](https://docs.notifications.service.gov.uk/ruby.html). The key difference is that the templates for all emails are stored in Notify. Any mailer views found in the project code are there purely as reference to what the Notify templates contain and to allow us to replicate the email body.

### Intercepting email in development

You can use [Mailcatcher](https://mailcatcher.me/) to intercept emails sent out during development.

Make sure you have the following in your `.env` or `.env.development` file:

    EMAIL_USERNAME=''
    EMAIL_PASSWORD=''
    EMAIL_APP_DOMAIN=''
    EMAIL_HOST='localhost'
    EMAIL_PORT='1025'

Install **Mailcatcher** (`gem install mailcatcher`) and run it by just calling `mailcatcher`

Then navigate to [http://127.0.0.1:1080](http://127.0.0.1:1080) in your browser.

> Note that [mail_safe](https://github.com/myronmarston/mail_safe) maybe also be running in which case any development email will seem to be sent to your global git config email address.

## Users and roles

Being a back office system you need to have a valid user account to access it. It also features different roles which have different levels of access to the features in the system.

### Roles

The following roles exist

| Name                       | Symbol       | Description  |
|----------------------------|--------------|---|
| System user                | :system      | Can do anything including inviting new users. |
| Administrative super user  | :super_agent | Approve or reject registrations. Edit all registrations. Export data. |
| Administrative user        | :admin_agent | View, edit in-progress registrations and add new. |
| Data user                  | :data_agent  | Can only search, view and export registrations. |

### Seeded users

When seeding the development environment databases a number of generic accounts (one per role) will created for you.

The email for each is in the format of **[symbol]_user@example.gov.uk**, and the password for all is **Abcde12345**.

So for example the login for the data user is

- email **data_agent_user@example.gov.uk**
- password **Abcde12345**

## Tests

We use [RSpec](http://rspec.info/) and the project contains both feature and unit tests which focus on the functionality added specifically for internal users. Unit testing for the application process is generally done in [flood _risk_engine](https://github.com/DEFRA/flood-risk-engine) and acceptance tests in [Flood risk acceptance tests](https://github.com/DEFRA/flood-risk-acceptance-tests).

To run the rspec test suite

```bash
bundle exec rake
```

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
