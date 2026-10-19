HUGO ?= hugo

.PHONY: help serve build preview upstream clean

help:
	@echo "make serve      live-reloading local server at http://localhost:1313"
	@echo "make build      production build into public/"
	@echo "make preview    build for plain-file hosts (no directory index) into public-artifact/"
	@echo "make upstream   regenerate data/upstream.json from GitHub (needs gh and jq)"
	@echo "make clean      remove build output"

serve:
	$(HUGO) server --disableFastRender

build:
	$(HUGO) --gc --cleanDestinationDir

preview:
	$(HUGO) --gc --cleanDestinationDir --environment artifact --destination public-artifact

upstream:
	./scripts/update-upstream.sh

clean:
	rm -rf public public-artifact resources/_gen .hugo_build.lock
