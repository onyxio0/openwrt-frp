include $(TOPDIR)/rules.mk

PKG_NAME:=frp
PKG_VERSION:=0.65.0
PKG_RELEASE:=1

# 将 OpenWrt 架构映射到 frp 架构
ifeq ($(ARCH),aarch64)
  FRP_ARCH:=arm64
else ifeq ($(ARCH),arm)
  ifeq ($(findstring cortex-a7,$(CPU_TYPE)),cortex-a7)
    FRP_ARCH:=arm
  else
    FRP_ARCH:=arm
  endif
else ifeq ($(ARCH),mipsel)
  FRP_ARCH:=mipsle
else ifeq ($(ARCH),mips)
  FRP_ARCH:=mips
else ifeq ($(ARCH),x86_64)
  FRP_ARCH:=amd64
else ifeq ($(ARCH),i386)
  FRP_ARCH:=386
else
  $(error Unsupported architecture: $(ARCH))
endif

PKG_SOURCE:=frp_$(PKG_VERSION)_linux_$(FRP_ARCH).tar.gz
PKG_SOURCE_URL:=https://github.com/fatedier/frp/releases/download/v$(PKG_VERSION)/
PKG_HASH:=skip

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Xingwang Liao <kuoruan@gmail.com>

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
