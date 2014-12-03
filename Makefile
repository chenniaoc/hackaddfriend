include theos/makefiles/common.mk

TWEAK_NAME = hackAddFriend
hackAddFriend_FILES = Tweak.xm
hackAddFriend_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

ARCHS = armv7
TARGET = iphone:6.1:4.3
