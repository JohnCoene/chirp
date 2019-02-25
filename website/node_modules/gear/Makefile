BIN = ./node_modules/.bin

all: browser test coverage

browser:
	-$(BIN)/browserify lib/index.js -s Gear -o build/gear.js
	-@node bin/gear.js

test:
	npm test

coverage: lib-cov
	-@GEAR_COVER=1 $(BIN)/mocha --require should --reporter mocha-istanbul

lib-cov:
	@$(BIN)/istanbul instrument --output lib-cov --no-compact --variable global.__coverage__ lib

clean: clean-coverage

clean-coverage:
	-rm -rf lib-cov
	-rm -rf html-report

.PHONY: test
