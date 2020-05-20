BUILD := _build
VIM_NAMES := macro specialform function variable constant comparator
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

$(BUILD)/specialform.vim: $(BUILD)/data.txt
	./build.sh specialform $< > $@

$(BUILD)/function.vim: $(BUILD)/data.txt
	./build.sh function $< > $@

$(BUILD)/variable.vim: $(BUILD)/data.txt
	./build.sh variable $< > $@

$(BUILD)/constant.vim: $(BUILD)/data.txt
	./build.sh constant $< > $@

$(BUILD)/comparator.vim: $(BUILD)/data.txt
	./build.sh comparator $< > $@

$(BUILD)/data.txt:
	mkdir -p $(BUILD)
	./build.sh data > $@
