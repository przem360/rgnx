################################################################################
#
# picodrive
#
################################################################################

PICODRIVE_VERSION = 1.97
PICODRIVE_SITE = $(BR2_EXTERNAL_RGNX_PATH)/package/picodrive/src
PICODRIVE_SITE_METHOD = local
PICODRIVE_DEPENDENCIES = sdl zlib

define PICODRIVE_CONFIGURE_CMDS
    (cd $(@D); \
        CC="$(TARGET_CC)" \
        CXX="$(TARGET_CXX)" \
        AS="$(TARGET_AS)" \
        LD="$(TARGET_LD)" \
        STRIP="$(TARGET_STRIP)" \
        ./configure --platform=generic)
endef

define PICODRIVE_BUILD_CMDS
    $(MAKE) -C $(@D)
endef

define PICODRIVE_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/PicoDrive $(TARGET_DIR)/usr/bin/picodrive
    mkdir -p $(TARGET_DIR)/usr/bin/skin
    cp -r $(@D)/skin/* $(TARGET_DIR)/usr/bin/skin/
endef

$(eval $(generic-package))
