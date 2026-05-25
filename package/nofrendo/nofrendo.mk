################################################################################
#
# nofrendo
#
################################################################################

NOFRENDO_VERSION = local
NOFRENDO_SITE = $(BR2_EXTERNAL_RGNX_PATH)/package/nofrendo/src
NOFRENDO_SITE_METHOD = local

NOFRENDO_DEPENDENCIES = sdl zlib

NOFRENDO_AUTORECONF = YES

NOFRENDO_CONF_ENV = \
	LIBS="-lSDL -lz -lm" \
	SDL_CONFIG="$(STAGING_DIR)/usr/bin/sdl-config"

define NOFRENDO_PREPARE_SOURCES
	sed -i 's/\r//' $(@D)/configure.in
	sed -i 's/\r//' $(@D)/Makefile.am
	find $(@D) -name "Makefile.am" -exec sed -i 's/\r//' {} \;
	touch $(@D)/ChangeLog $(@D)/NEWS
	
	if [ -f $(@D)/src/sdl/sdl.c ]; then \
		sed -i 's/\bround\b/local_round/g' $(@D)/src/sdl/sdl.c; \
	fi
endef
NOFRENDO_POST_RSYNC_HOOKS += NOFRENDO_PREPARE_SOURCES

$(eval $(autotools-package))
