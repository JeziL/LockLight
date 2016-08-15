include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LockLightPB
LockLightPB_FILES = LockLightPB.mm
LockLightPB_INSTALL_PATH = /Library/PreferenceBundles
LockLightPB_FRAMEWORKS = UIKit
LockLightPB_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LockLightPB.plist$(ECHO_END)
