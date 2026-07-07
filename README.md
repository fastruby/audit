# Audit

Audit is a Rails application that allows users to check for vulnerabilities in their Gemfiles in an efficient and secure manner.

You can see it working in https://audit.fastruby.io

## Requirements

- Ruby version `3.2.11` (see `Gemfile`)
- Node (see `package.json`)
- Docker + Docker Compose (recommended for local development)

## Getting started (Docker)

The easiest way to run the app locally is with Docker Compose, which builds the app image and a Postgres database for you:

    docker compose up --build

This starts:

- `db` — Postgres 13
- `web` — the app on http://localhost:3000, running against the default `Gemfile` (currently Rails 7.1)
- `web_next` — the same image, but with `BUNDLE_GEMFILE=Gemfile.next`, on http://localhost:3001 (see "Dual-boot Rails upgrades" below)

`docker/entrypoint.sh` copies `config/database.yml.sample` / `.env.sample` into place and runs `rails db:prepare` on boot, so no manual DB setup is needed.

## Getting started (without Docker)

    ./bin/setup
    rails server

You should be able to go to http://localhost:3000 and see the landing page.

## Running tests

Inside Docker:

    docker compose run --rm -e RAILS_ENV=test -e DATABASE_HOST=db -e DATABASE_USERNAME=postgres -e DATABASE_PASSWORD=postgres web bin/rails test

Without Docker:

    rails test

Also run before opening a PR:

    bundle exec rubocop
    bundle exec reek

## Dual-boot Rails upgrades

This app uses the [`next_rails`](https://github.com/fastruby/next_rails) dual-boot pattern to upgrade Rails one minor version at a time. `Gemfile.next` is a symlink to `Gemfile`; the `if next?` check in `Gemfile` only switches to the newer Rails constraint when Bundler is invoked with `BUNDLE_GEMFILE=Gemfile.next` (e.g. `web_next` above, or CI). The *default* `Gemfile`/`Gemfile.lock` — what actually runs in production — keeps the older, verified version until a later "make it the default" commit flips both branches over. Check `git log --grep="the default"` for examples of that pattern in this repo's history.

## Deploying / production notes

The app runs on Heroku (`bundler-audit-production`, stack `heroku-26`). Two things worth knowing if you're touching deploy config:

- **`Aptfile` + the `heroku-community/apt` buildpack are required.** `heroku-26`'s runtime image does not ship `git` at all (only the build image does). This app needs `git` at *runtime* because `config/initializers/bundler_audit.rb` (via `lib/bundler_audit_database_preparer.rb`) shells out to `git clone`/`git pull` to keep the local `ruby-advisory-db` checkout (used by `bundler-audit` to scan uploaded `Gemfile.lock`s) up to date on every boot. Without the apt buildpack vendoring `git` into the slug, that clone silently fails and every audit request 500s with `ArgumentError ("... is not a directory")`. The buildpack must be ordered *before* `heroku/ruby` (`heroku buildpacks:add --index 1 heroku-community/apt`) so `git` is available for the whole build+runtime lifecycle.
- If `BundlerAuditDatabasePreparer` logs `[bundler-audit] Could not prepare ruby-advisory-db ...`, that's the underlying `git` failure surfacing — check `heroku logs` for the full error rather than just the generic 500.

## Contributing

  Bug reports and pull requests are welcome on GitHub at [https://github.com/fastruby/audit](https://github.com/fastruby/audit). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


  When Submitting a Pull Request:

  * If your PR closes any open GitHub issues, please include `Closes #XXXX` in your comment

  * Please include a summary of the change and which issue is fixed or which feature is introduced.

  * If changes to the behavior are made, clearly describe what changes.

  * If changes to the UI are made, please include screenshots of the before and after.

## License

  The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

  ## Code of Conduct

  Everyone interacting in the Audit project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](../blob/main/CODE_OF_CONDUCT.md).

  ## Sponsorship

![FastRuby.io | Rails Upgrade Services](app/assets/images/fastruby-logo.png)


`Audit` is maintained and funded by [FastRuby.io](https://fastruby.io). The names and logos for FastRuby.io are trademarks of The Lean Software Boutique LLC.
