################################################################################
#
# pocketsnes
#
################################################################################

POCKETSNES_VERSION = local
POCKETSNES_SITE = $(BR2_EXTERNAL_RGNX_PATH)/package/pocketsnes/src
POCKETSNES_SITE_METHOD = local

POCKETSNES_DEPENDENCIES = sdl sdl_image zlib libpng

define POCKETSNES_BUILD_CMDS
	$(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" \
		CXX="$(TARGET_CXX)" \
		STRIP="$(TARGET_STRIP)" \
		SYSROOT="$(STAGING_DIR)" \
		TARGET=pocketsnes/pocketsnes
endef

define POCKETSNES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/pocketsnes/pocketsnes \
		$(TARGET_DIR)/usr/bin/pocketsnes
endef

$(eval $(generic-package))
