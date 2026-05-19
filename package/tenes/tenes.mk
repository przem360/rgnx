################################################################################
#
# tenes
#
################################################################################

TENES_VERSION = local
TENES_SITE = $(BR2_EXTERNAL_RGNX_PATH)/package/tenes/src
TENES_SITE_METHOD = local

TENES_LICENSE = GPL-2.0+
TENES_DEPENDENCIES = sdl freetype sdl_image

TENES_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	UNAME="Linux" \
	PREFIX=/usr \
	CFLAGS="$(TARGET_CFLAGS) -Wall -O3 `$(STAGING_DIR)/usr/bin/sdl-config --cflags` `$(PKG_CONFIG_HOST_BINARY) --cflags freetype2` -flax-vector-conversions -DPREFIX=\\\"/usr\\\"" \
	LIBS="$(TARGET_LDFLAGS) -lm -ldl -lSDL `$(STAGING_DIR)/usr/bin/sdl-config --libs` `$(PKG_CONFIG_HOST_BINARY) --libs freetype2` -lSDL_image"

define TENES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(TENES_MAKE_OPTS) all
endef

define TENES_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TENES_MAKE_OPTS) PREFIX=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
