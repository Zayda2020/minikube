########################################################################
#
# Falco driver kernel module
#
########################################################################

FALCO_MODULE_VERSION = 0.31.1
FALCO_MODULE_SITE = https://github.com/falcosecurity/falco/archive
FALCO_MODULE_SOURCE = $(FALCO_MODULE_VERSION).tar.gz
FALCO_MODULE_DEPENDENCIES += ncurses libyaml
FALCO_MODULE_LICENSE = Apache-2.0
FALCO_MODULE_LICENSE_FILES = COPYING

# see cmake/modules/falcosecurity-libs.cmake
FALCO_MODULE_FALCOSECURITY_LIBS_VERSION = b7eb0dd65226a8dc254d228c8d950d07bf3521d2
FALCO_MODULE_EXTRA_DOWNLOADS = https://github.com/falcosecurity/libs/archive/$(FALCO_MODULE_FALCOSECURITY_LIBS_VERSION).tar.gz

define FALCO_MODULE_FALCOSECURITY_LIBS_SRC
	sed -e 's|URL ".*"|URL "'$(FALCO_MODULE_DL_DIR)/$(FALCO_MODULE_FALCOSECURITY_LIBS_VERSION).tar.gz'"|' -i $(@D)/cmake/modules/falcosecurity-libs-repo/CMakeLists.txt
endef

FALCO_MODULE_POST_EXTRACT_HOOKS += FALCO_MODULE_FALCOSECURITY_LIBS_SRC

FALCO_MODULE_CONF_OPTS = -DFALCO_VERSION=$(FALCO_MODULE_VERSION)
FALCO_MODULE_CONF_OPTS += -DUSE_BUNDLED_DEPS=ON

FALCO_MODULE_MAKE_ENV = $(LINUX_MAKE_ENV)
FALCO_MODULE_MAKE_OPTS = $(LINUX_MAKE_FLAGS) driver KERNELDIR=$(LINUX_DIR)
FALCO_MODULE_INSTALL_OPTS = install_driver
FALCO_MODULE_INSTALL_STAGING_OPTS = INSTALL_MOD_PATH=$(STAGING_DIR) install_driver
FALCO_MODULE_INSTALL_TARGET_OPTS = INSTALL_MOD_PATH=$(TARGET_DIR) install_driver

$(eval $(kernel-module))
$(eval $(cmake-package))
