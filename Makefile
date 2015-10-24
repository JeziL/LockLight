THEOS_DEVICE_IP = 192.168.2.3
ARCHS = armv7 arm64
TARGET = iphone:9.0:9.0

include theos/makefiles/common.mk

TWEAK_NAME = LockLight
LockLight_FILES = Tweak.xm
LockLight_PRIVATE_FRAMEWORKS = Spotlight SpotlightUI IOKit
LockLight_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

i:
	make package install

p:
	make package

after-install::
	install.exec "cat /dev/null > /var/log/syslog"
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += locklightpb
include $(THEOS_MAKE_PATH)/aggregate.mk
