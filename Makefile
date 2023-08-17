install:
	@make up
	@make composer
	docker compose exec app cp .env.example .env
	@make setup
dev:
	@make up
	@make composer
	docker compose exec app npm install
	docker compose exec -d app npm run dev
	@make setup
	@make clear
	@make migrate
prod:
	@make up
	@make composer
	docker compose exec app composer install --optimize-autoloader --no-dev
	docker compose exec app npm install
	docker compose exec app npm run build
	@make setup
	@make clear
	@make cache
	@make migrate
up:
	docker compose up -d --build
down:
	docker compose down --remove-orphans
web:
	docker compose exec web bash
app:
	docker compose exec app bash
db:
	docker compose exec db bash
composer:
	docker compose exec app composer update
	docker compose exec app composer install
setup:
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
migrate:
	docker compose exec app php artisan migrate:fresh --seed
clear:
	docker compose exec app php artisan route:clear
	docker compose exec app php artisan cache:clear
	docker compose exec app php artisan config:clear
	docker compose exec app php artisan view:clear
cache:
	docker compose exec app php artisan config:cache
	docker compose exec app php artisan route:cache
	docker compose exec app php artisan view:cache
