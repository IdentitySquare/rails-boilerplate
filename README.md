# Rails Boilerplate

A standard set of gems, libraries and configurations we use for our new projects.

## What is included?

* PostgreSQL
* Devise
*


# Getting started

## 1. Rename Database name
Go to `config/database.yml` to change your database names and authentication methods.


## 2. Setting your secret keys

Add `config/master.key` with the value: `90b6ee492f968d798af41d5f91a532ba`.
DO NOT checking this file to Git.

Opens the encrypted file in an editor. We use atom.

All environments:

```
  EDITOR="atom --wait" rails credentials:edit
```

Development specific keys to overwrite the default keys:
```
  rails credentials:edit -e production
  rails credentials:edit -e development
  rails credentials:edit -e test
```

https://medium.com/@thorntonbrenden/rails-and-the-legendary-master-key-15c8be7799f1

##### Changing the `master.key`
1. Open all the encrypted files, copy the values and save it temporarily.
2. Delete the `master.key` and encrypted files in `config/credentials` folder and the file `config/credentials.yml.enc`.
3. Run the above commands to edit the encrypted files. Which will generate a new `master.key`.
4. Paste in the values of copied in step 1 into the Encrypted files.


##### Deploying to Heroku:
Create a `RAILS_MASTER_KEY` ENV variable. Rails will detect it and use it as your master key, e.g. in Heroku: heroku config:set RAILS_MASTER_KEY=<your-master-key-here>.