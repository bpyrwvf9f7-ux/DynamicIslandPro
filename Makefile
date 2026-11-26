export TARGET = iphone:clang:16.5:15.0
export ARCHS = arm64 arm64e
export THEOS_PACKAGE_SCHEME = rootless
export PACKAGE_VERSION = 1.0.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LingDong
LingDong_FILES = src/LDTweak.m src/LDNotifier.m src/LDIslandViewController.m src/LDNotificationItem.m src/LDPrefs.m
LingDong_CFLAGS = -fobjc-arc -Isrc -Wno-unused-function -Wno-deprecated-declarations
LingDong_FRAMEWORKS = UIKit Foundation QuartzCore CoreGraphics
LingDong_LDFLAGS = -Wl,-undefined,dynamic_lookup

SUBPROJECTS += prefs

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
