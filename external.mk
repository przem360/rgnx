include $(BR2_EXTERNAL_RGNX_PATH)/toolchain-fix.mk
include $(sort $(wildcard $(BR2_EXTERNAL_RGNX_PATH)/package/*/*.mk))
