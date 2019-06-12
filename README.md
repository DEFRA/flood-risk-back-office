# Flood risk back office

A Ruby on Rails application delivering the [Flood risk activity exemptions service](https://register-flood-risk-exemption.service.gov.uk).

This is a thin, host application which mounts and provides styling for the [flood_risk_engine](https://github.com/DEFRA/flood-risk-engine) rails engine, and adds functionality specific to internal users. The engine is responsible for the service implementation.

## Prerequisites

Please make sure the following are installed:

- [Ruby 2.3.1](https://www.ruby-lang.org) installed for example via [RVM](https://rvm.io) or [Rbenv](https://github.com/sstephenson/rbenv/blob/master/README.md)
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

#### Seeding in Heroku

To seed on Heroku where the environment is PRODUCTION, connect to a non-visitor and non-office network and run

```bash
heroku run bash -a [heroku_app_name]
bundle exec rails c
require './db/seeds/development.rb'
FloodRiskEngine::Engine.load_seed # loads exemptions seed data
exit
exit
```

## Running the app

To start the service locally run

```bash
bundle exec rails s
```

You can then access the web site at http://localhost:3000

## Email

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

## Quality and conventions

The project is linked to [Circle CI](https://circleci.com/gh/DEFRA/flood-risk-back-office) and all pushes to the **GitHub** are automatically checked.

The checks include running all tests plus **Rubocop**, but also tools like [HTLMHint](https://github.com/yaniswang/HTMLHint) and [i18n-tasks](https://github.com/glebm/i18n-tasks). Check the `circle.yml` for full details, specifically the `test:pre` section.

It is left to each developer to setup their environment such that these checks all pass before presenting their code for review and merging.

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
