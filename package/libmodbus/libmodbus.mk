################################################################################
#
# libmodbus
#
################################################################################

LIBMODBUS_VERSION = 3.1.7
LIBMODBUS_SITE = http://libmodbus.org/releases
LIBMODBUS_LICENSE = LGPL-2.1+
LIBMODBUS_LICENSE_FILES = COPYING.LESSER
LIBMODBUS_CPE_ID_VENDOR = libmodbus
LIBMODBUS_INSTALL_STAGING = YES
LIBMODBUS_CONF_OPTS = --without-documentation --disable-tests

$(eval $(autotools-package))
