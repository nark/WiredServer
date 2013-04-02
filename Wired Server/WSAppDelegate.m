//
//  WSAppDelegate.m
//  Wired Server
//
//  Created by Rafaël Warnault on 24/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import "WSAppDelegate.h"
#import "WSSettingsController.h"

@implementation WSAppDelegate


#pragma mark -

@synthesize settingsController  = _settingsController;



#pragma mark -

- (id)init {
    self = [super init];
    if (self) {
        _settingsController     = [[WSSettingsController alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_settingsController release];
    
    [super dealloc];
}




#pragma mark -

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.settingsController showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}



#pragma mark -

- (IBAction)exportSettings:(id)sender {
    [self.settingsController exportSettings:sender];
}

- (IBAction)importSettings:(id)sender {
    [self.settingsController importSettings:sender];
}

- (IBAction)releaseNotes:(id)sender {
    [self.settingsController releaseNotes:sender];
}

- (IBAction)showHelp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.read-write.fr/wired/wiki/wiredserver/wiredserver_osx"]];
}

@end
