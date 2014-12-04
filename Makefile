# Code optimization.
MINIFIER     = ./$(NODE_MODULES)/.bin/uglifyjs
MINIFIED     = $(MINI_PATH)main.js
MINI_PATH    = $(PATH_BASE)lib/

# Unit test runner.
TESTER       = ./$(NODE_MODULES)/.bin/nodeunit

# Dockerfile template.
DOCKR_INPUT  = templates/Dockerfile.t
DOCKR_OUTPUT = $(PATH_BASE)Dockerfile

# GNU tools.
RM           = rm -f
MKDIR        = mkdir -p
CP           = cp
SED          = sed
AWK          = awk

# Other utilities.
GIT          = git
NPM          = npm
NODE         = node
DOCKER       = docker

GARBAGE      = $(shell find build/ -type f)
NODE_MODULES = node_modules
PATH_RELEASE = build/release/
SOURCE_FILES = $(shell find lib/ -type f -iname '*.js*')
SOURCE_MAIN  = lib/main.js
NPM_PACKAGE  = package.json
TEST_FILES   = $(shell find test/ -type f -iname '*.js')
VERSION      = $(shell $(GIT) describe --tags | $(SED) "s/[^0-9]/ /g" | \
			   $(AWK) '{printf "%d.%d.%d", $$1, $$2, $$3}')

ifeq (,$(shell which $(GIT)))
$(error Cannot find "git" in PATH. Please install it and try again)
endif

ifeq (,$(shell which $(NPM)))
$(error Cannot find "npm" in PATH. Please install node.js and try again)
endif

# User commands.

release:
	@$(MAKE) auto-release PATH_BASE="$(PATH_RELEASE)" --no-print-directory

clean:
	@$(MAKE) auto-clean --no-print-directory

version:
	@echo $(VERSION)

test:
	@echo "Running unit tests ..."
	@$(foreach FILE,$(TEST_FILES),$(TESTER) $(FILE))

run:
	$(NODE) $(SOURCE_MAIN)

docker:
ifeq (,$(shell which docker))
	@echo "Docker not installed. Please install it and try again."
else
	@$(MAKE) auto-docker PATH_BASE="$(PATH_RELEASE)" --no-print-directory
endif

help:
	@echo "make release - Builds using release configuration."
	@echo "make clean   - Removes existing builds."
	@echo "make version - Prints current application version."
	@echo "make test    - Runs unit tests."
	@echo "make run     - Starts server in debug mode."
	@echo "make docker  - Creates docker image of game release version."
	@echp "make help    - Displays this help message."

# Automatic commands. Don't use these directly.

auto-release: $(MINIFIED) $(PATH_BASE)$(NPM_PACKAGE)

auto-clean:
	$(foreach FILE,$(wildcard $(GARBAGE)),$(RM) $(FILE)$(\n))

auto-docker: auto-clean auto-release $(DOCKR_OUTPUT)
	cd $(PATH_BASE) && sudo docker build -t mastery-server:v$(VERSION) .

$(PATH_BASE):
	@$(MKDIR) $@

$(MINI_PATH): $(PATH_BASE)
	@$(MKDIR) $@

$(PATH_BASE)$(NPM_PACKAGE): $(NPM_PACKAGE)
	$(CP) $< $@

$(NODE_MODULES):
	$(NPM) install

$(DOCKR_OUTPUT): $(DOCKR_INPUT) $(PATH_BASE)
	$(CP) $< $@

$(MINIFIER): $(NODE_MODULES)

$(MINIFIED): $(SOURCE_FILES) $(MINIFIER) $(MINI_PATH)
	$(MINIFIER) $(SOURCE_FILES) --mangle \
		--compress "warnings=false" -o $@

.PHONY: auto-release auto-clean release clean version test run

define \n


endef


