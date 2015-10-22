#include <mach/mach_time.h>
#include <IOKit/hid/IOHIDEvent.h>
#import <UIKit/UIKit.h>

BOOL _lEnabled;
BOOL _pdEnabled;
BOOL _lockEnabled;

extern "C"{
    typedef uint32_t IOHIDEventOptionBits;
    typedef struct __IOHIDEvent *IOHIDEventRef;
    IOHIDEventRef IOHIDEventCreateKeyboardEvent(CFAllocatorRef allocator, AbsoluteTime timeStamp, uint16_t usagePage, uint16_t usage, Boolean down, IOHIDEventOptionBits flags);
}

@interface SBSpotlightSettings
@property(nonatomic) _Bool enableSpotlightOnMinusPage;
- (void)setDefaultValues;
@end

@interface SPUISearchViewController
@property (nonatomic) unsigned int presentsFromEdge;
- (BOOL)_isPullDownSpotlight;
@end

@interface SpringBoard : UIApplication
- (void)_lockButtonUp:(struct __IOHIDEvent *)arg1 fromSource:(int)arg2;
- (void)_lockButtonDown:(struct __IOHIDEvent *)arg1 fromSource:(int)arg2;
@end

static void loadPrefs() {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.ezi.locklight.plist"];
    if(prefs)
    {
        _lEnabled = [prefs objectForKey:@"LEnabled"] ? [[prefs objectForKey:@"LEnabled"] boolValue] : NO;
        _pdEnabled = [prefs objectForKey:@"PDEnabled"] ? [[prefs objectForKey:@"PDEnabled"] boolValue] : NO;
        _lockEnabled = [prefs objectForKey:@"LockEnabled"] ? [[prefs objectForKey:@"LockEnabled"] boolValue] : NO;
    }
    [prefs release];
}

static void lockDevice() {
	SpringBoard *springboard = (SpringBoard *)[%c(SpringBoard) sharedApplication];
    uint64_t abTime = mach_absolute_time();
    IOHIDEventRef event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
    [springboard _lockButtonDown:event fromSource:1];
    CFRelease(event);
    event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
    [springboard _lockButtonUp:event fromSource:1];
    CFRelease(event);
}

%group leftSP2Lock

	%hook SPUISearchViewController

		- (void)didFinishPresenting:(BOOL)arg1 {
			if (arg1 && ![self _isPullDownSpotlight]/*self.presentsFromEdge == 8*/) {
				lockDevice();
			}
			else {
				%orig;
			}
		}

	%end

%end

%group killPullDownSP

	%hook SBSearchScrollView

		- (_Bool)gestureRecognizerShouldBegin:(id)arg1 {
			return NO;
		}

	%end

%end

%group killLeftSP
	
	%hook SBSpotlightSettings

		- (void)setDefaultValues {
			%orig;
			self.enableSpotlightOnMinusPage = NO;
		}

	%end

%end

%ctor {
	loadPrefs();
	if (_lEnabled && _lockEnabled) {
		%init(leftSP2Lock);
	}
	else if (!_lEnabled) {
		%init(killLeftSP);
	}
	if (!_pdEnabled) {
		%init(killPullDownSP);
	}
}