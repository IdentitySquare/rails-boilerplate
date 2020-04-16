# Rails Boilerplate

A standard set of gems, libraries and configurations we use for our new projects.

## What is included?

*Backend:*
* PostgreSQL
* Devise
* Omniauth
  * Connect with Google
  * Connect with Facebook
* Kaminari
* Pundit
* Active Admin
  * activeadmin_addons
* Active Storage
* Sidekiq
* Redis
* Friendly IDs

*Frontend*:
* HAML
* Webpacker
* SASS
* Simple Forms
* High Voltage

*Development tools:*
* Better Errors
* Awesome print
* Hirb
* Bullet
* Peek
* Guard live reloads
* Annotate
* Letter opener

*Models:*
* User
* AdminUser (for internal admin)

*Testing:*

* RSPEC
* Shoulda matchers
* Factory bot
* Faker
* Capybara


# Getting started

## 1. Rename Database name
Go to `config/database.yml` to change your database names and authentication methods.

```
 rails db:setup
```


## 2. Setting your secret keys

Add `config/master.key` with the value: `90b6ee492f968d798af41d5f91a532ba`.
DO NOT checking this file to Git.

Opens the encrypted file in an editor. We use atom.

```
  EDITOR="atom --wait" rails credentials:edit
```

Reading variables:
```
  Rails.application.credentials.dig(Rails.env.to_sym, :hello)
  Rails.application.credentials.dig(Rails.env.to_sym, :secret_key)
```


##### Changing the `master.key`
1. Open all the encrypted files, copy the values and save it temporarily.
2. Delete the `master.key` and encrypted files in `config/credentials` folder and the file `config/credentials.yml.enc`.
3. Run the above commands to edit the encrypted files. Which will generate a new `master.key`.
4. Paste in the values of copied in step 1 into the Encrypted files.


## 3. Deploying to Heroku:

1. Create a Heroku App
2. Create a `RAILS_MASTER_KEY` ENV variable. Rails will detect it and use it as your master key, e.g. in Heroku: `heroku config:set RAILS_MASTER_KEY=<your-master-key-here>` OR set ENV variable in the Heroku UI.
3. Deploy your code
4. Add Heroku Postgres addon.
5. Once deploy has completed, run `rails db:migrate` on Heroku. `heroku run rails db:migrate -a <your-heroku-app-name>`.
6. Setup required dynos.
7. Worker setup for Sidekiq
8. Provision Redis for Sidekiq
9. Restart all dynos

## 4. Outbound Emails in production

On Heroku use Mailgun or setup the following ENV variables:

```ruby
  ENV['SMTP_USERNAME']
  ENV['SMTP_PASSWORD']
  ENV['SMTP_ADDRESS']
  ENV['MAILGUN_SMTP_PORT']
```
