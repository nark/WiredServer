//
//  WHAppDelegate.h
//  Wired Server Helper
//
//  Created by Rafaël Warnault on 26/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WPWiredManager, WHStatusController;

@interface WHAppDelegate : NSObject <NSApplicationDelegate> {
	IBOutlet NSMenu                 *_statusMenu;
	
	NSStatusItem                    *_statusItem;
	WPWiredManager                  *_wiredManager;
	WHStatusController              *_statusController;
	WIDateFormatter                 *_dateFormatter;
}

@property (assign)              IBOutlet NSMenu                 *statusMenu;

@property (readwrite, retain)   NSStatusItem                    *statusItem;

@property (readwrite, retain)   WPWiredManager                  *wiredManager;
@property (readwrite, retain)   WHStatusController              *statusController;
@property (readwrite, retain)   WIDateFormatter                 *dateFormatter;

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)open:(id)sender;


@end
