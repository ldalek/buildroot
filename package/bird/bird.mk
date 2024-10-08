################################################################################
#
# bird
#
################################################################################

BIRD_VERSION = 2.15.1
BIRD_SITE = https://bird.network.cz/download
BIRD_LICENSE = GPL-2.0+
BIRD_LICENSE_FILES = README
BIRD_CPE_ID_VENDOR = nic
BIRD_SELINUX_MODULES = bird
BIRD_DEPENDENCIES = host-flex host-bison

BIRD_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

# 0001-configure.ac-fix-build-with-autoconf-2.70.patch
BIRD_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_BIRD_CLIENT),y)
BIRD_CONF_OPTS += --enable-client
BIRD_DEPENDENCIES += ncurses readline
else
BIRD_CONF_OPTS += --disable-client
endif

ifeq ($(BR2_PACKAGE_LIBSSH),y)
BIRD_CONF_OPTS += --enable-libssh
BIRD_DEPENDENCIES += libssh
else
BIRD_CONF_OPTS += --disable-libssh
endif

BIRD_PROTOCOLS = \
	$(if $(BR2_PACKAGE_BIRD_BFD),bfd) \
	$(if $(BR2_PACKAGE_BIRD_BABEL),babel) \
	$(if $(BR2_PACKAGE_BIRD_BGP),bgp) \
	$(if $(BR2_PACKAGE_BIRD_MRT),mrt) \
	$(if $(BR2_PACKAGE_BIRD_OSPF),ospf) \
	$(if $(BR2_PACKAGE_BIRD_PERF),perf) \
	$(if $(BR2_PACKAGE_BIRD_PIPE),pipe) \
	$(if $(BR2_PACKAGE_BIRD_RADV),radv) \
	$(if $(BR2_PACKAGE_BIRD_RIP),rip) \
	$(if $(BR2_PACKAGE_BIRD_RPKI),rpki) \
	$(if $(BR2_PACKAGE_BIRD_STATIC),static)

BIRD_CONF_OPTS += --with-protocols=$(subst $(space),$(comma),$(strip $(BIRD_PROTOCOLS)))

$(eval $(autotools-package))
