# How to build a Laravel environment with docker compose?

This repository is for building Laravel environment contains PHP, Node.js, Nginx and MySQL. So you can build a Laravel environment quickly.

This uses these images or binary.

- php:8.2-fpm
- nodejs_18.x
- nginx:1.25-alpine
- mysql:8.0

## How to use?

### 1. Git clone this repository

Git clone this repository to your local machine or somewhere.

### 2. Edit each versions you need

#### 2.1 PHP and Node.js

/docker/app/Dockerfile
```
FROM php:8.2-fpm

...

RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && \
```

For PHP, seach PHP images [here](https://hub.docker.com/_/php).

For Node.js, see Node versions [here](https://github.com/nodesource/distributions). This uses binary distributions, so you can set integer.

ex. 14, 16, 18

#### 2.2 Nginx

/docker/web/Dockerfile
```
FROM nginx:1.25-alpine
```

For Nginx, seach Nginx images [here](https://hub.docker.com/_/nginx).

#### 2.3 MySQL

/docker/db/Dockerfile
```
FROM mysql:8.0
```

For MySQL, seach MySQL images [here](https://hub.docker.com/_/mysql). Of cause you can use other databases you like.

## 3. Let's get started

>Before get started, you can use Makefile like below. In next section, I introduce how to use Makefile to deploy app easier. Go to [Let's get started with Makefile](#4-lets-get-started-with-makefile) if you want.
>
>For example
>
>```
>make up
>```
>
>is
>
>```
>docker-compose up -d
>```

### 3.1 Build docker containers

Before build docker containers, if you use Vite, you need to open 5173 ports for Vite.

```
services:
  app:
    build:
      context: .
      dockerfile: ./docker/app/Dockerfile
    ports:
      - 5173:5173
```

Then

```
docker-compose up -d --build
```

### 3.2. Go to the app container

```
docker-compose exec app bash
```

### 3.3 Clone your Laravel project
Clone your repository or mine for test [here](https://github.com/kiyoshion/laravel-inertia-react-ssr).

You are /app directory in app container. Then
```
git clone https://github.com/kiyoshion/laravel-inertia-react-ssr .
```

When you clone your repository to /app directory, you can see your Laravel project at your local /src directory.

### 3.4 .env
Copy .env.example to .env, then edit it to your environment

```
cp .env.example .env
```

> Be careful, DB settings need same value of docker-compose.yml. In this case, DB_HOST is `db` that is container name at docker-compose.yml.
>
> /docker-compose.yml
> ```
> services:
>   app:
>   ...
>
>   web:
>   ...
>
>   db: // DB_HOST
>     build:
>       context: .
>       dockerfile: ./docker/db/Dockerfile
>     ports:
>       - 3306:3306
>     environment:
>       MYSQL_DATABASE: database
>       MYSQL_USER: user
>       MYSQL_PASSWORD: password
>       MYSQL_ROOT_PASSWORD: password
> ```

/.env
```
APP_NAME=YOUR_APP_NAME
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=YOUR_APP_URL

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=database
DB_USERNAME=user
DB_PASSWORD=password
```

### 3.5. Deploy

Deploy for production. Go into the app container, then

```
composer install
composer install --optimize-autoloader --no-dev
npm install
npm run build
php artisan key:generate
php artisan storage:link
chmod -R 777 storage bootstrap/cache
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate:fresh --seed
```

OR for deveopment

```
composer install
npm install
npm run dev
php artisan key:generate
php artisan storage:link
chmod -R 777 storage bootstrap/cache
php artisan migrate:fresh --seed
```

Congraturations! :tada: You can access YOUR_APP_URL or [http://localhost:8080](http://localhost:8080).

## 4. Let's get started with Makefile

If you had finished above steps manually, you don't need these steps.

### 4.1 Build docker containers

Before build docker containers, if you use Vite, you need to open 5173 ports for Vite.

```
services:
  app:
    build:
      context: .
      dockerfile: ./docker/app/Dockerfile
    ports:
      - 5173:5173
```

Then

```
make build
make up
```

### 4.2 Clone your Laravel project

Go into the app container.

```
make app
```

Then clone your repository at /app directory.

```
git clone https://github.com/kiyoshion/laravel-inertia-react-ssr.git .
```

### 4.3 .env
Copy .env.example to .env

```
cp .env.example .env
```

>Be careful, DB settings need same value of docker-compose.yml. In this case, DB_HOST is `db` that is container name at docker-compose.yml.
>
>/docker-compose.yml
>```
>services:
>  app:
>  ...
>
>  web:
>  ...
>
>  db: // DB_HOST
>    build:
>      context: .
>      dockerfile: ./docker/db/Dockerfile
>    ports:
>      - 3306:3306
>    environment:
>      MYSQL_DATABASE: database
>      MYSQL_USER: user
>      MYSQL_PASSWORD: password
>      MYSQL_ROOT_PASSWORD: password
>```

Then edit .env

```
vim .env
```

/app/.env
```
APP_NAME=YOUR_APP_NAME
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=YOUR_APP_URL

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=database
DB_USERNAME=user
DB_PASSWORD=password
```

### 4.4 Deploy

Deploy below command for production.

```
make prod
```

OR for development

```
make dev
```

Congraturations! :tada: You can access YOUR_APP_URL or [http://localhost:8080](http://localhost:8080).
