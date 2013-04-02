//
//  WHAppDelegate.m
//  Wired Server Helper
//
//  Created by Rafaël Warnault on 26/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import "WHAppDelegate.h"
#import "WHStatusController.h"
#import "WPWiredManager.h"


@interface WHAppDelegate (Private)

- (void)_updateStatusMenu;

@end


@implementation WHAppDelegate

@synthesize statusItem          = _statusItem;
@synthesize statusMenu          = _statusMenu;
@synthesize statusController    = _statusController;
@synthesize wiredManager        = _wiredManager;
@synthesize dateFormatter       = _dateFormatter;


#pragma mark -

- (id)init {
    self = [super init];
    if (self) {
        _statusItem             = [[[NSStatusBar systemStatusBar] statusItemWithLength:30.0] retain];
        _statusController       = [[WHStatusController alloc] init];
        _wiredManager           = [[WPWiredManager alloc] init];
        _dateFormatter          = [[WIDateFormatter alloc] init];
        
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setNaturalLanguageStyle:WIDateFormatterNormalNaturalLanguageStyle];
    }
    return self;
}


- (void)dealloc
{
    [_statusItem release];
    [_statusController release];
    [_wiredManager release];
    [_dateFormatter release];
    [super dealloc];
}


#pragma mark -

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusMenu];
    
    [self _updateStatusMenu];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(wiredStatusDidChange:)
     name:WPWiredStatusDidChangeNotification];
}


#pragma mark -

- (void)wiredStatusDidChange:(NSNotification *)notification {
    [self _updateStatusMenu];
}


#pragma mark -

- (void)menuWillOpen:(NSMenu *)menu {
    
    NSString        *string;
    NSMenuItem      *item;
    NSDate			*launchDate;
	
	launchDate = [self.wiredManager launchDate];
    
    [menu removeAllItems];
    
    if([self.wiredManager isInstalled]) {
        
        if([self.wiredManager isRunning]) {
            item = [menu addItemWithTitle:@"Stop Wired Server" action:@selector(stop:) keyEquivalent:@""];
            [item setTarget:self];
            
            if([self.statusController reloadStatus]) { 
                
                [menu addItem:[NSMenuItem separatorItem]];
                
                string = [NSString stringWithFormat:@"Running since %@", [_dateFormatter stringFromDate:launchDate]];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                [menu addItem:[NSMenuItem separatorItem]];
                
                string = [NSString stringWithFormat:@"Current users: %ld", self.statusController.currentUsers];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                string = [NSString stringWithFormat:@"Total users: %ld", self.statusController.totalUsers];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                
                string = [NSString stringWithFormat:@"Current downloads: %ld", self.statusController.currentDownloads];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                string = [NSString stringWithFormat:@"Total downloads: %ld", self.statusController.totalDownloads];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                string = [NSString stringWithFormat:@"Current uploads: %ld", self.statusController.currentUploads];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                string = [NSString stringWithFormat:@"Total uploads: %ld", self.statusController.totalUploads];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                
                string = [NSString stringWithFormat:
                          @"Download traffic: %@", 
                          [NSString humanReadableStringForSizeInBytes:self.statusController.downloadsTraffic]];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                string = [NSString stringWithFormat:
                          @"Uploads traffic: %@", 
                          [NSString humanReadableStringForSizeInBytes:self.statusController.uploadsTraffic]];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                string = [NSString stringWithFormat:
                          @"Total traffic: %@", 
                          [NSString humanReadableStringForSizeInBytes:self.statusController.totalTraffic]];
                item = [menu addItemWithTitle:string action:nil keyEquivalent:@""];
                
                
            } else {
                item = [menu addItemWithTitle:@"No wired.status File Found…" action:nil keyEquivalent:@""];
            }
            
        } else {
            item = [menu addItemWithTitle:@"Start Wired Server" action:@selector(start:) keyEquivalent:@""];
        }
        
    } else {
        item = [menu addItemWithTitle:@"Wired Server in not Installed…" action:nil keyEquivalent:@""];
    }
        
    [menu addItem:[NSMenuItem separatorItem]];
    item = [menu addItemWithTitle:@"Open Wired Server…" action:@selector(open:) keyEquivalent:@""];
    [item setTarget:self];
}



#pragma mark -

- (IBAction)start:(id)sender {
	WPError		*error;

	if(![_wiredManager startWithError:&error]) {

	}
}

- (IBAction)stop:(id)sender {
	WPError		*error;
	
	if(![_wiredManager stopWithError:&error]) {

	}
}

- (IBAction)open:(id)sender {
    [[NSWorkspace sharedWorkspace] launchApplication:@"Wired Server"];
}



#pragma mark -

- (void)_updateStatusMenu {
    if([_wiredManager isRunning]) {
        [self.statusItem setImage:[NSImage imageNamed:@"WiredServerMenu"]];
	} else {
        [self.statusItem setImage:[NSImage imageNamed:@"WiredServerMenuOff"]];
    }
}


@end
