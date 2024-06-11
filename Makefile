PWD = $(shell pwd)
ASCIIDOCTOR     = asciidoctor -r asciidoctor-kroki
ASCIIDOCTOR_WEB_PDF = asciidoctor-web-pdf -r asciidoctor-kroki
PYTHON = python3

TARGETS += $(TARGETS_WITHOUT_HTML) index.html
TARGETS_WITHOUT_HTML += $(PROCESSED_CHARTS) $(wildcard scripts/*.adoc)

VEGA_CHART_FILES = $(shell find assets -name '*.vl.json')
VEGA_DATA_FILES = $(addprefix assets/,$(shell grep -Poh "[^\"]+.csv" $(VEGA_CHART_FILES) /dev/null | sort | sed 's/^\.\///' | uniq))
PROCESSED_CHARTS = $(addprefix processed-assets/,$(notdir $(VEGA_CHART_FILES)))

# .EXTRA_PREREQS:=Makefile
.PHONY: all pdf preview test
all: Readme.pdf test
preview: paper-preview

SCSS_FILES = $(wildcard styles/*.scss) $(wildcard styles/*/*.scss) $(wildcard styles/*/*/*.scss)

paper.css: $(SCSS_FILES)
	cd styles ; sass --update --sourcemap=none paper.scss:../paper.css

%.html: %.adoc paper.css $(TARGETS_WITHOUT_HTML) $(PROCESSED_CHARTS)
	$(ASCIIDOCTOR) -S unsafe $< -o $@

%-web-preview: %.html
	$(PYTHON) scripts/serve.py $<

%.pdf: %.adoc paper.css $(TARGETS_WITHOUT_HTML) $(PROCESSED_CHARTS)
	$(ASCIIDOCTOR_WEB_PDF) $< -o $@

%-preview: %.adoc paper.css $(TARGETS_WITHOUT_HTML) $(PROCESSED_CHARTS)
	$(ASCIIDOCTOR_WEB_PDF) --preview $<

# Preprocess vega charts
process-charts: $(PROCESSED_CHARTS)

$(PROCESSED_CHARTS) : processed-assets/%.vl.json : assets/%.vl.json $(VEGA_DATA_FILES)
	mkdir -p $(dir $@)
	bash scripts/process_chart.sh $< > $@
	touch $@

clean:
	rm -rf compare-implementations simple-aes openssl-aes invert-sbox key-recovery *.pcm *.html *.css

dist-clean: clean
	rm -rf $(TARGETS)

.PHONY: clean all dist-clean process-charts data

simple-aes: src/simple-aes.cpp
	clang++ --std=c++20 -O3 -Wall $< -o $@ -lcrypto

openssl-aes: src/openssl-aes.cpp
	clang++ --std=c++20 -O3 -Wall $< -o $@ -lcrypto

invert-sbox: src/invert-sbox.cpp
	clang++ --std=c++20 -O3 -Wall $< -o $@

%.pcm: src/%.cppm
	clang++ -std=c++20 -O3 -Wall $< --precompile -o $@

key-recovery: src/key-recovery.cpp AesFunctions.pcm
	clang++ -std=c++20 -O3 -Wall -fprebuilt-module-path=. $^ -o $@ -lcrypto

compare-implementations: src/compare-implementations.cpp AesFunctions.pcm
	clang++ -std=c++20 -O3 -Wall -fprebuilt-module-path=. $^ -o $@ -lcrypto

# Verify that the implementations work
test:	compare-implementations simple-aes openssl-aes invert-sbox key-recovery
	./compare-implementations
	./simple-aes
	./openssl-aes
	./invert-sbox
	./key-recovery
	