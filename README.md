# DDTECH Order Tracker

## Production
make sure the mysql socket points to /var/run/mysqld/mysqld.sock  
in neubox server its located in /usr/local/mysql/data/mysql.sock

You can create a symbolic link like so
`ln -s /usr/local/mysql/data/mysql.sock /var/run/mysqld/mysqld.sock`

## Basic Setup
1. Create database

   `$ RAILS_ENV=production rails db:create`

2. Run migrations

   `$ RAILS_ENV=productions rails db:migrate`

3. Install yarn dependencies.

   `$ yarn install`

4. Precompile Assets

   `$ RAILS_ENV=production rails assets:precompile`

5. Set environment variables for the system, these are DB_USER, DB_PASS, MAIL_USER, MAIL_PASS

6. Install wkhtmltopdf binaries for your development system, it could be with the gem wkhtmltopdf-binary or from a package for your system

   ### Ruby Gem

   `$ gem install 'wkhtmltopdf-binary'`

   ### Fedora / CentOs / RedHat

   `$ sudo dnf -y install wkhtmltopdf-devel`

7. Set the environment variable for wkhtmltopdf as WKHTMLTOPDF_PATH
