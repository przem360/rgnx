################################################################################
#
# tcc - Tiny C Compiler
#
################################################################################

TCC_SITE = $(BR2_EXTERNAL_RGNX_PATH)/package/tcc/src
TCC_SITE_METHOD = local

define TCC_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--prefix=/usr \
		--cpu=i386 \
		--cc="$(TARGET_CC)" \
		--ar="$(TARGET_AR)" \
		--config-musl \
		--sysincludepaths=/usr/include \
		--libpaths=/usr/lib \
		--crtprefix=/usr/lib \
		--elfinterp=/lib/ld-musl-i386.so.1 \
	)
endef

define TCC_BUILD_CMDS
	# 1. Budujemy bazowe tcc
	-$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" \
		HELP2MAN=true \
		MAKEINFO=true

	# 2. Ukrywamy i486-tcc w bezpiecznym miejscu
	mv $(@D)/tcc $(@D)/tcc.target

	# 3. Tworzymy wrapper dla GCC/AR
	echo '#!/bin/sh' > $(@D)/tcc
	echo 'if [ "$${1}" = "-ar" ]; then' >> $(@D)/tcc
	echo '    shift' >> $(@D)/tcc
	echo '    exec $(TARGET_AR) "$$@"' >> $(@D)/tcc
	echo 'else' >> $(@D)/tcc
	echo '    exec $(TARGET_CC) "$$@"' >> $(@D)/tcc
	echo 'fi' >> $(@D)/tcc
	chmod +x $(@D)/tcc

	# 4. Budujemy libtcc1.a za pomocą wrappera
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/lib \
		CC="$(TARGET_CC)" \
		AR="$(TARGET_AR)"

	# 5. Przywracamy oryginalną binarkę tcc
	rm -f $(@D)/tcc
	mv $(@D)/tcc.target $(@D)/tcc
endef

define TCC_INSTALL_TARGET_CMDS
	@echo "TCC: Pomijam instalacje automatyczna. Uzyj tcc_pack.sh."
endef

$(eval $(generic-package))
