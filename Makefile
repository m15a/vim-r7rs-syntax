BUILD := _build

.PHONY: clean

$(BUILD)/atdef.txt:
ifndef GAUCHE_DOC
	$(error Please set GAUCHE_DOC to gauche doc path (*.texi are there))
endif
	mkdir -p $(BUILD)
	fd . -e texi $(GAUCHE_DOC) -x grep '^@def' '{}' \
		| sort \
		| uniq \
		> $(BUILD)/atdef.txt

clean:
	rm -rf _build
