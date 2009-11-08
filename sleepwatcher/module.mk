############################################################
# SleepWatcher
############################################################
local_dir := SleepWatcher
files := .sleep .wakeup
sw_files := $(addprefix $(HOME)/, $(files))

sleepwatcher: $(sw_files)

$(sw_files): $(PREFIX)%: $(local_dir)/%
	$(file-attach)
