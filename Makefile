build: Dockerfile config.ru web.rb .env Gemfile Gemfile.lock config/unicorn.rb
	docker build -t s3player .

stop:
	docker ps --filter="name=s3player_web1" -q | xargs docker stop

start:
	docker run --rm --name s3player_web1 -d -p 4567:4567 s3player bundle exec unicorn -E development -p 4567 -c ./config/unicorn.rb

lock: Gemfile
	docker run --rm s3player cat Gemfile.lock > Gemfile.lock

log:
	docker ps --filter="name=s3player_web1" -q | xargs docker logs

shell:
	docker run --rm -it s3player sh

respown:
	make stop
	make build
	make start
