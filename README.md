# template-craft
    
Craft template with local setup with Docker and deployment via Docker containers


### Table of Contents

1. [Project Links](#project-links)
2. [Getting Started](#getting-started)
3. [Front-End Development](#front-end-development)
4. [Craft CMS Content Modeling](#craft-cms-content-modeling)
5. [Useful Resources](#useful-resources)


## Project Links

* Localhost: [http://localhost/](http://localhost/)
* Localhost control panel: [http://localhost/admin](http://localhost/admin)
* Staging: TBD
* Staging control panel: TBD
* Production: TBD
* Production control panel: TBD


## Getting Started

To run this code you'll need to 
* use a UNIX operating system
* have [Docker](https://www.docker.com/) installed


### Quick Start

Locally, using docker is the easiest and fastest way to get up and running. The `docker-compose.yaml` file will start the following services for you:  
*  PHP v8.0 running with FPM proxied by nginx mapped locally to port 80
*  Craft CMS console running PHP v8.0 by default running the craft queue/listen command
*  PostgreSQL v13 database mapped locally to port 5432
*  Composer v2 to install composer dependencies

The local PostgreSQL database credentials are set in the `docker-compose.yaml` file:  
*  Database: craft
*  Username: craft
*  Password: secret

1. Clone the repository and change directory into the cloned repo

```bash
git clone git@github.com:noahjahn/cms.git
cd cm
```


3. Start docker containers (this will take a while the first time, grab a cup of coffee)

    - First time start will set the `APP_ID` and `SECURITY_KEY` and generate a `config/license.key` for you. If you need to setup an existing environment (ex: production) locally, be sure to use the values of the previously mentioned items configured for that specific environment

```bash
./start
```


4. If applicable, replace your local database with content in staging (or production):

    a. Login in to the control panel of the site you want to pull down

    b. Open Utilities > Database Backup

    c. Check "Download backup" and click on Backup

    d. Extract the database script from the zip file and move it in the root of your project directory

    e. With the containers running, run the Craft database restore script in the already running docker container locally:

    ```bash
    docker-compose exec php-fpm-nginx ./craft db/restore name-of-database-backup.sql
    ```


5. Once completed, if all is successful, navigate to http://localhost to see the site


## Dependencies

Since the project doesn't require you to have PHP or composer installed, you can install and add new composer dependencies with docker using the service defined in the `docker-compose.yaml` file. For example, to install a new composer dependency you can run:

```bash
./composer require craftcms/cms
```

OR

```bash
export UID
docker-compose run --rm composer require craftcms/cms
```

You can run any composer command needed in the way shown above.

*It's important to export your users' `UID` to your current shell before running the commands so dependencies are installed as your user in the container.*

*The `--rm` flag will remove the container when it completes*

You can run any composer command needed in the examples shown above.


## Database

Entry content is not synced in the Craft CMS project config so whenever you need to replace your database with content in production or staging, follow these steps:

1. Login in to the control panel of the site you want to pull down

2. Open Utilities > Database Backup

3. Check "Download backup" and click on Backup

4. Extract the database script from the zip file and move it in the root of your project directory

5. With the containers running, run the Craft database restore script in the already running docker container locally:

```bash
docker-compose exec php-fpm-nginx ./craft db/restore name-of-database-backup.sql
```


## Front-End Development

Front-End code is created in the `templates` directory. Craft renders Twig templates.


### Assets

Assets can be found in the `web` directory.

This directory represents the server’s webroot. The public index.php file lives here and this is where any of the local site images, CSS, and JS that is statically served should live.

## Craft CMS Content Modeling

[Get familiar with content modeling in Craft](https://craftcms.com/docs/getting-started-tutorial/configure/modeling.html#get-familiar-with-content-modeling-in-craft)

## Useful Resources
* [Up And Running With Craft Course](https://craftquest.io/courses/craft-cms-3-tutorials)
* [Twig Templating Documentation](https://twig.symfony.com/doc/3.x/)
* [Craft CMS Documentation: Getting Started Tutorial](https://craftcms.com/docs/getting-started-tutorial/)
* [Craft CMS Documentation](https://craftcms.com/docs/3.x/)
* [Craft CMS Discord](https://craftcms.com/blog/discord)
* [CraftCMS Content Builder](https://medium.com/@atchukura/craftcms-content-builder-where-wordpress-finally-came-to-die-add38d6e1e2b)
