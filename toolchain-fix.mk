define TOOLCHAIN_EXTERNAL_CUSTOM_FIX_SYMLINK
	@echo "--- RGNX FIX: Creating symlink for musl toolchain structure ---"
	mkdir -p $(HOST_DIR)/opt/ext-toolchain/i486-linux-musl/usr
	if [ ! -L $(HOST_DIR)/opt/ext-toolchain/i486-linux-musl/usr/include ]; then \
		ln -sf ../include $(HOST_DIR)/opt/ext-toolchain/i486-linux-musl/usr/include; \
	fi
endef

TOOLCHAIN_EXTERNAL_CUSTOM_POST_EXTRACT_HOOKS += TOOLCHAIN_EXTERNAL_CUSTOM_FIX_SYMLINK
