# Code optimization.
MINIFIER     = ./$(NODE_MODULES)/.bin/uglifyjs
MINIFIED     = $(MINI_PATH)main.js
MINI_PATH    = $(PATH_BASE)lib/

# GNU tools.
RM           = rm -f
MKDIR        = mkdir -p
CP           = cp

# Other utilities.
NPM          = npm
NODE         = node

GARBAGE      = $(shell find build/ -type f)
NODE_MODULES = node_modules
PATH_RELEASE = build/release/
SOURCE_FILES = $(shell find lib/ -type f -iname '*.js*')
SOURCE_MAIN  = lib/main.js
NPM_PACKAGE  = package.json

ifeq (,$(shell which $(NPM)))
$(error Cannot find "npm" in PATH. Please install node.js and try again)
endif

# User commands.

release:
	@$(MAKE) auto-release PATH_BASE="$(PATH_RELEASE)" --no-print-directory

clean:
	@$(MAKE) auto-clean --no-print-directory

run:
	$(NODE) $(SOURCE_MAIN)

help:
	@echo "make release - Builds using release configuration."
	@echo "make clean   - Removes existing builds."
	@echo "make run     - Starts server in debug mode."
	@echo "make help    - Displays this help message."

# Automatic commands. Don't use these directly.

auto-release: $(MINIFIED) $(PATH_BASE)$(NPM_PACKAGE)

auto-clean:
	$(foreach FILE,$(wildcard $(GARBAGE)),$(RM) $(FILE)$(\n))

$(PATH_BASE):
	@$(MKDIR) $@

$(MINI_PATH): $(PATH_BASE)
	@$(MKDIR) $@

$(PATH_BASE)$(NPM_PACKAGE): $(NPM_PACKAGE)
	$(CP) $< $@

$(NODE_MODULES):
	$(NPM) install

$(MINIFIER): $(NODE_MODULES)

$(MINIFIED): $(SOURCE_FILES) $(MINIFIER) $(MINI_PATH)
	$(MINIFIER) $(SOURCE_FILES) --mangle --compress "warnings=false" -o $@

.PHONY: auto-clean release clean version test run

define \n


endef

