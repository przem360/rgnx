################################################################################
#
# dgen
#
################################################################################

DGEN_VERSION = local
DGEN_SITE = $(BR2_EXTERNAL_RGNX_PATH)/package/dgen/src
DGEN_SITE_METHOD = local

DGEN_DEPENDENCIES = sdl zlib

DGEN_CONF_OPTS = \
	--disable-hqx \
	--disable-scale2x \
	--disable-ctv \
	--disable-asm \
	--disable-opengl \
	--without-nasm

DGEN_CONF_ENV = \
	SDL_CONFIG="$(STAGING_DIR)/usr/bin/sdl-config"

define DGEN_PREPARE_SOURCES
	find $(@D) -name "configure.ac" -o -name "Makefile.am" -exec sed -i 's/\r//' {} \;
	touch $(@D)/ChangeLog $(@D)/NEWS $(@D)/AUTHORS $(@D)/README
endef
DGEN_POST_RSYNC_HOOKS += DGEN_PREPARE_SOURCES

DGEN_AUTORECONF = YES

$(eval $(autotools-package))
