################################################################################
#
# gnuboy
#
################################################################################

GNUBOY_VERSION = local
GNUBOY_SITE = $(BR2_EXTERNAL_RGNX_PATH)/package/gnuboy/src
GNUBOY_SITE_METHOD = local

GNUBOY_LICENSE = GPL-2.0+
GNUBOY_DEPENDENCIES = sdl

GNUBOY_CONF_OPTS = \
	--with-sdl \
	--without-sdl2 \
	--without-x \
	--disable-x11 \
	--disable-asm

define GNUBOY_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 $(@D)/sdlgnuboy $(TARGET_DIR)/usr/bin/sdlgnuboy
	$(INSTALL) -m 755 $(@D)/fbgnuboy $(TARGET_DIR)/usr/bin/fbgnuboy
endef

$(eval $(autotools-package))
