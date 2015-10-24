#import <Preferences/Preferences.h>

#define donateURL @"http://ezidev.tumblr.com/post/131626791958/donation"
#define myTwitterWeb @"https://twitter.com/EZIdev"
#define myTwitterApp @"twitter://user?screen_name=EZIdev"

@interface LockLightPBListController: PSListController {
}
@end

@implementation LockLightPBListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"LockLightPB" target:self] retain];
	}
	return _specifiers;
}

-(void)donate {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:donateURL]];
}

-(void)twitter {
	 NSURL *myTwitterUrlScheme = [NSURL URLWithString:myTwitterApp];
    if ([[UIApplication sharedApplication] canOpenURL:myTwitterUrlScheme])
        [[UIApplication sharedApplication] openURL:myTwitterUrlScheme];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myTwitterWeb]];
}

-(void)respring {
	system("killall -9 SpringBoard");
}

@end

// vim:ft=objc
