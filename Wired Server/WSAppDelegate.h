//
//  WSAppDelegate.h
//  Wired Server
//
//  Created by Rafaël Warnault on 24/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WSSettingsController;

@interface WSAppDelegate : NSObject {
	WSSettingsController            *_settingsController;
}

@property (readwrite, retain)   WSSettingsController            *settingsController;

- (IBAction)exportSettings:(id)sender;
- (IBAction)importSettings:(id)sender;
- (IBAction)releaseNotes:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)support:(id)sender;

@end
