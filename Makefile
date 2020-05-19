BUILD := _build

syntax/gauche.vim: $(BUILD)/macro.vim
	./builder/syntax.sh $^ > $@

$(BUILD)/macro.vim: $(BUILD)/atdef.txt
	./builder/syntax_macro.sh $< > $@

$(BUILD)/atdef.txt:
	mkdir -p $(BUILD)
	./builder/atdef.sh > $@

.PHONY: clean
clean:
	rm -rf _build
