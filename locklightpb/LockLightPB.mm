#import <Preferences/PSListController.h>

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

-(void)viewGitHubRepo {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/JeziL/LockLight"]];
}

-(void)respring {
	system("killall -9 SpringBoard");
}

@end

// vim:ft=objc
