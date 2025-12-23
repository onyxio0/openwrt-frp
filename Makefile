include $(TOPDIR)/rules.mk

PKG_NAME:=frp
PKG_VERSION:=0.65.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)_$(PKG_VERSION)_linux_$(ARCH).tar.gz
PKG_SOURCE_URL:=https://github.com/fatedier/frp/releases/download/v$(PKG_VERSION)/
PKG_HASH:=skip

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Xingwang Liao <kuoruan@gmail.com>

# 不需要编译
PKG_BUILD_DEPENDS:=
PKG_BUILD_PARALLEL:=0

include $(INCLUDE_DIR)/package.mk

define frp/templates
  define Package/$(1)
    TITLE:=A fast reverse proxy ($(1))
    URL:=https://github.com/fatedier/frp
    SECTION:=net
    CATEGORY:=Network
    SUBMENU:=Web Servers/Proxies
  endef

  define Package/$(1)/description
  frp is a fast reverse proxy to help you expose a local server behind a NAT or firewall
  to the internet.
  
  This package contains the $(1).
  endef

  define Package/$(1)/install
	$$(INSTALL_DIR) $$(1)/usr/bin
	$$(INSTALL_BIN) $$(PKG_BUILD_DIR)/$(1) $$(1)/usr/bin/
  endef
endef

FRP_COMPONENTS:=frpc frps

$(foreach component,$(FRP_COMPONENTS), \
  $(eval $(call frp/templates,$(component))) \
  $(eval $(call BuildPackage,$(component))) \
)
