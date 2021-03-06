.PHONY: build build-example build-fast clean dump-splices dump-th example-client example-docs example-server ghci haddock haddock-server lint test test-fast upload watch watch-example watch-haddock watch-test
all: build

build:
	stack build

build-fast:
	stack build --fast

build-example:
	stack build --flag servant-checked-exceptions:buildexample

clean:
	stack clean

# dump the template haskell
dump-splices: dump-th
dump-th: test/test-dir/empty-dir
	-stack build --ghc-options="-ddump-splices"
	@echo
	@echo "Splice files:"
	@echo
	@find "$$(stack path --dist-dir)" -name "*.dump-splices" | sort

example-client: build-example
	stack exec -- servant-checked-exceptions-example-client --strict Hello

example-docs: build-example
	stack exec -- servant-checked-exceptions-example-docs

example-server: build-example
	stack exec -- servant-checked-exceptions-example-server

haddock:
	stack build --haddock

# Run ghci using stack.
ghci:
	stack ghci

test/test-dir/empty-dir:
	mkdir -p test/test-dir/empty-dir

test: test/test-dir/empty-dir
	stack test

test-fast: test/test-dir/empty-dir
	stack test --fast


# Run hlint.
lint:
	hlint src/

# This runs a small python websever on port 8001 serving up haddocks for
# packages you have installed.
#
# In order to run this, you need to have run `make build-haddock`.
haddock-server:
	cd "$$(stack path --local-doc-root)" && python -m http.server 8001

# Upload this package to hackage.
upload:
	stack upload .

# Watch for changes.
watch:
	stack build --file-watch --fast .

watch-example:
	stack build --file-watch --fast --flag servant-checked-exceptions:buildexample .

watch-haddock:
	stack build --haddock --file-watch --fast .

watch-test: test/test-dir/empty-dir
	stack test --file-watch --fast .

