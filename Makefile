BUILD := _build

VIM_NAMES := \
	macro \
	specialform \
	function \
	variable \
	constant \
	module
	# class
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

$(BUILD)/macro.vim: $(BUILD)/atdef.tsv
	./build.sh macro $< > $@

$(BUILD)/specialform.vim: $(BUILD)/atdef.tsv
	./build.sh specialform $< > $@

$(BUILD)/function.vim: $(BUILD)/atdef.tsv
	./build.sh function $< > $@

$(BUILD)/variable.vim: $(BUILD)/atdef.tsv
	./build.sh variable $< > $@

$(BUILD)/constant.vim: $(BUILD)/atdef.tsv
	./build.sh constant $< > $@

$(BUILD)/module.vim: $(BUILD)/atdef.tsv
	./build.sh module $< > $@

$(BUILD)/class.vim: $(BUILD)/atdef.tsv
	./build.sh class $< > $@

$(BUILD)/atdef.tsv:
	mkdir -p $(BUILD)
	./build.sh tsv $(TEXI_NAMES) > $@
