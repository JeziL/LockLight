THEOS_DEVICE_IP = localhost -p 2222
TARGET = iphone:9.3:9.0

include $(THEOS)/makefiles/common.mk

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
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += locklightpb
include $(THEOS_MAKE_PATH)/aggregate.mk
