BUILD := _build
VIM_NAMES := macro special variable
VIM_FILES = $(addprefix $(BUILD)/, $(addsuffix .vim, $(VIM_NAMES)))

.PHONY: build clean
build: syntax/gauche.vim ftplugin/gauche.vim

clean:
	rm -rf _build

syntax/gauche.vim: $(VIM_FILES)
	./build.sh syntax $^ > $@

ftplugin/gauche.vim: $(VIM_FILES)
	./build.sh ftplugin $^ > $@

$(BUILD)/macro.vim: $(BUILD)/data.txt
	./build.sh macro $< > $@

$(BUILD)/special.vim: $(BUILD)/data.txt
	./build.sh special $< > $@

$(BUILD)/variable.vim: $(BUILD)/data.txt
	./build.sh variable $< > $@

$(BUILD)/data.txt:
	mkdir -p $(BUILD)
	./build.sh data > $@
