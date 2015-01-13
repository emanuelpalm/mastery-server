# Build base path.
PATH_BASE    = build/

# Code optimization.
MINIFIER     = ./$(NODE_MODULES)/.bin/uglifyjs
MINIFIER_IN  = $(shell find lib/ -type f -iname '*.js*')
MINIFIER_OUT = $(MINIFIER_IN:%=$(PATH_BASE)%)

# NPM package.
NPMPKG_IN    = package.json
NPMPKG_OUT   = $(PATH_BASE)package.json

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

auto-release: $(NPMPKG_OUT) $(MINIFIER_OUT)
	cd $(PATH_BASE) && $(NPM) install --production

auto-clean:
	$(foreach FILE,$(wildcard $(GARBAGE)),$(RM) $(FILE)$(\n))

$(NPMPKG_OUT): $(NPMPKG_IN)
	$(CP) $< $@

$(NODE_MODULES):
	$(NPM) install

$(MINIFIER): $(NODE_MODULES)

$(PATH_BASE)%.js: %.js $(MINIFIER)
	$(MKDIR) $(dir $@)
	$(MINIFIER) $< --compress "warnings=false" -o $@

.PHONY: $(NPMPKG_OUT) auto-clean release clean version test run

define \n


endef

