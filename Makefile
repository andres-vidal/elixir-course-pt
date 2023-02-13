.SILENT: run

install:
	docker pull elixir:latest
run: 
	(docker start elixir || docker run --name elixir -v ${PWD}:/workspace -d -t elixir:latest) >/dev/null 2>&1 && \
	docker exec -it elixir bash