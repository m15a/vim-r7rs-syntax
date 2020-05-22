BUILD := _build

VIM_NAMES := \
	macro \
	specialform \
	function \
	variable \
	constant \
	comparator \
	module \
	class
VIM_FILES = $(addprefix $(BUILD)/, $(addsuffix .vim, $(VIM_NAMES)))

TEXI_NAMES := \
	corelib \
	coresyn \
	macro \
	object \
	modgauche \
	modutil \
	modr7rs \
	modsrfi

.PHONY: build clean
build: syntax/gauche.vim ftplugin/gauche.vim

clean:
	rm -rf _build

syntax/gauche.vim: $(VIM_FILES)
	./build.sh syntax $^ > $@

ftplugin/gauche.vim: $(VIM_FILES)
	./build.sh ftplugin $^ > $@

$(BUILD)/macro.vim: $(BUILD)/atdef.txt
	./build.sh macro $< > $@

$(BUILD)/specialform.vim: $(BUILD)/atdef.txt
	./build.sh specialform $< > $@

$(BUILD)/function.vim: $(BUILD)/atdef.txt
	./build.sh function $< > $@

$(BUILD)/variable.vim: $(BUILD)/atdef.txt
	./build.sh variable $< > $@

$(BUILD)/constant.vim: $(BUILD)/atdef.txt
	./build.sh constant $< > $@

$(BUILD)/comparator.vim: $(BUILD)/atdef.txt
	./build.sh comparator $< > $@

$(BUILD)/module.vim: $(BUILD)/atdef.txt
	./build.sh module $< > $@

$(BUILD)/class.vim: $(BUILD)/atdef.txt
	./build.sh class $< > $@

$(BUILD)/atdef.txt:
	mkdir -p $(BUILD)
	./build.sh atdef $(TEXI_NAMES) > $@
