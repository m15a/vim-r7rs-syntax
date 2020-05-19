BUILD := _build

.PHONY: build clean
build: syntax/gauche.vim ftplugin/gauche.vim

clean:
	rm -rf _build

syntax/gauche.vim: $(BUILD)/macro.vim $(BUILD)/special.vim
	./build.sh syntax $^ > $@

ftplugin/gauche.vim: $(BUILD)/macro.vim $(BUILD)/special.vim
	./build.sh ftplugin $^ > $@

$(BUILD)/macro.vim: $(BUILD)/data.txt
	./build.sh macro $< > $@

$(BUILD)/special.vim: $(BUILD)/data.txt
	./build.sh special $< > $@

$(BUILD)/data.txt:
	mkdir -p $(BUILD)
	./build.sh data > $@
