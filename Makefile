# All documents to be used in spell check.
ALL_DOC := $(shell find . -name '*.md' -type f | sort)

MISSPELL=misspell
MISSPELL_CORRECTION=misspell -w

.PHONY: travis-ci
travis-ci: misspell

.PHONY: misspell
misspell:
	@MISSPELLOUT=`$(MISSPELL) $(ALL_DOC) 2>&1`; \
	if [ "$$MISSPELLOUT" ]; then \
		echo "$(MISSPELL) FAILED => clean the following typos: (make misspell-correction)\n"; \
		echo "$$MISSPELLOUT\n"; \
		exit 1; \
	else \
	    echo "Misspell finished successfully"; \
	fi

.PHONY: misspell-correction
misspell-correction:
	$(MISSPELL_CORRECTION) $(ALL_DOC)

.PHONY: install-tools
install-tools:
	GO111MODULE=on go install \
	  github.com/client9/misspell/cmd/misspell
