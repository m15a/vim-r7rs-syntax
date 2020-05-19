BUILD := _build

syntax/gauche.vim: $(BUILD)/macro.vim $(BUILD)/special.vim
	./build.sh syntax $^ > $@

$(BUILD)/macro.vim: $(BUILD)/data.txt
	./build.sh macro $< > $@

$(BUILD)/special.vim: $(BUILD)/data.txt
	./build.sh special $< > $@

$(BUILD)/data.txt:
	mkdir -p $(BUILD)
	./build.sh data > $@

.PHONY: clean
clean:
	rm -rf _build
