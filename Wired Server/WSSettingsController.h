//
//  UPreferences.h
//  DicomX
//
//  Created by nark on 20/03/11.
//  Copyright 2011 Read-Write. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sparkle/SUUpdater.h>
#import "WPPortChecker.h"


@class WPAccountManager, WPConfigManager, WPExportManager;
@class WPWiredManager, WPPortChecker, WPLogManager;



enum WPPruneEventsType {
	WPPruneEventsNone		= 0,
	WPPruneEventsDaily		= 1,
	WPPruneEventsWeekly		= 2,
	WPPruneEventsMonthly	= 3,
	WPPruneEventsYearly		= 4
	
} typedef WPPruneEventsType;



@interface WSSettingsController : NSWindowController {
	IBOutlet NSToolbar						*_toolbar;
	IBOutlet NSView							*_generalPreferenceView;
	IBOutlet NSView							*_networkPreferenceView;
	IBOutlet NSView							*_filesPreferenceView;
	IBOutlet NSView							*_advancedPreferenceView;
	IBOutlet NSView							*_logsPreferenceView;
	IBOutlet NSView							*_updatePreferenceView;
	IBOutlet NSTextField					*_versionTextField;
	IBOutlet NSButton						*_installButton;
	IBOutlet NSProgressIndicator			*_installProgressIndicator;
	IBOutlet NSButton						*_revealButton;
	IBOutlet NSImageView					*_statusImageView;
	IBOutlet NSTextField					*_statusTextField;
	IBOutlet NSButton						*_startButton;
	IBOutlet NSProgressIndicator			*_startProgressIndicator;
	IBOutlet NSButton						*_launchAutomaticallyButton;
	IBOutlet NSButton						*_enableStatusMenuyButton;
	IBOutlet NSTableView					*_logTableView;
	IBOutlet NSTableColumn					*_logTableColumn;
	IBOutlet NSButton						*_openLogButton;
	IBOutlet NSPopUpButton					*_filesPopUpButton;
	IBOutlet NSMenuItem						*_filesMenuItem;
	IBOutlet NSTextField					*_filesIndexTimeTextField;
	IBOutlet NSButton						*_filesIndexButton;
	IBOutlet NSTextField					*_portTextField;
	IBOutlet NSImageView					*_portStatusImageView;
	IBOutlet NSTextField					*_portStatusTextField;
	IBOutlet NSButton						*_mapPortAutomaticallyButton;
	IBOutlet NSButton						*_checkPortAgainButton;
	IBOutlet NSTextField					*_accountStatusTextField;
	IBOutlet NSImageView					*_accountStatusImageView;
	IBOutlet NSButton						*_setPasswordButton;
	IBOutlet NSButton						*_createAdminButton;
	IBOutlet NSButton						*_setPasswordForAdminButton;
	IBOutlet NSButton						*_createNewAdminUserButton;
	IBOutlet NSPopUpButton					*_pruneEventsPopUpButton;
	IBOutlet NSButton						*_snapshotEnableButton;
	IBOutlet NSTextField					*_snapshotTextField;
	IBOutlet NSButton						*_exportSettingsButton;
	IBOutlet NSButton						*_importSettingsButton;
	IBOutlet NSButton						*_automaticallyCheckForUpdate;
	IBOutlet NSPanel						*_passwordPanel;
	IBOutlet NSSecureTextField				*_newPasswordTextField;
	IBOutlet NSSecureTextField				*_verifyPasswordTextField;
	IBOutlet NSTextField					*_passwordMismatchTextField;
    IBOutlet NSWindow                       *_activityWindow;
    IBOutlet NSProgressIndicator			*_activityProgressIndicator;
    IBOutlet NSTextField					*_activityTextField;
    
	SUUpdater					*_updater;
	
	WPAccountManager			*_accountManager;
	WPConfigManager				*_configManager;
	WPExportManager				*_exportManager;
	WPLogManager				*_logManager;
	WPWiredManager				*_wiredManager;
	
	WPPortChecker				*_portChecker;
	WPPortCheckerStatus			_portCheckerStatus;
	NSUInteger					_portCheckerPort;
	
	NSInteger					_currentViewTag;
	
	NSImage						*_greenDropImage;
	NSImage						*_redDropImage;
	NSImage						*_grayDropImage;
	
	WIDateFormatter				*_dateFormatter;
	NSMutableArray				*_logLines;
	NSMutableArray				*_logRows;
	NSDictionary				*_logAttributes;
    
    NSOperationQueue            *_queue;
}

/** UI Outlets */
@property (assign) IBOutlet NSToolbar                   *toolbar;

@property (assign) IBOutlet NSView                      *generalPreferenceView;
@property (assign) IBOutlet NSView                      *networkPreferenceView;
@property (assign) IBOutlet NSView                      *filesPreferenceView;
@property (assign) IBOutlet NSView                      *advancedPreferenceView;
@property (assign) IBOutlet NSView                      *logsPreferenceView;
@property (assign) IBOutlet NSView                      *updatePreferenceView;

@property (assign) IBOutlet NSTextField                 *versionTextField;
@property (assign) IBOutlet NSButton					*installButton;
@property (assign) IBOutlet NSProgressIndicator         *installProgressIndicator;
@property (assign) IBOutlet NSButton					*revealButton;

@property (assign) IBOutlet NSImageView                 *statusImageView;
@property (assign) IBOutlet NSTextField                 *statusTextField;
@property (assign) IBOutlet NSButton					*startButton;
@property (assign) IBOutlet NSProgressIndicator         *startProgressIndicator;

@property (assign) IBOutlet NSButton					*launchAutomaticallyButton;
@property (assign) IBOutlet NSButton					*enableStatusMenuyButton;

@property (assign) IBOutlet NSTableView                 *logTableView;
@property (assign) IBOutlet NSTableColumn				*logTableColumn;
@property (assign) IBOutlet NSButton					*openLogButton;

@property (assign) IBOutlet NSPopUpButton				*filesPopUpButton;
@property (assign) IBOutlet NSMenuItem					*filesMenuItem;
@property (assign) IBOutlet NSTextField					*filesIndexTimeTextField;
@property (assign) IBOutlet NSButton					*filesIndexButton;

@property (assign) IBOutlet NSTextField                 *portTextField;
@property (assign) IBOutlet NSImageView                 *portStatusImageView;
@property (assign) IBOutlet NSTextField                 *portStatusTextField;
@property (assign) IBOutlet NSButton                    *mapPortAutomaticallyButton;
@property (assign) IBOutlet NSButton                    *checkPortAgainButton;

@property (assign) IBOutlet NSTextField                 *accountStatusTextField;
@property (assign) IBOutlet NSImageView                 *accountStatusImageView;
@property (assign) IBOutlet NSButton					*setPasswordButton;
@property (assign) IBOutlet NSButton					*createAdminButton;
@property (assign) IBOutlet NSButton					*setPasswordForAdminButton;
@property (assign) IBOutlet NSButton					*createNewAdminUserButton;

@property (assign) IBOutlet NSPopUpButton				*pruneEventsPopUpButton;
@property (assign) IBOutlet NSButton					*snapshotEnableButton;
@property (assign) IBOutlet NSTextField					*snapshotTextField;

@property (assign) IBOutlet NSButton					*exportSettingsButton;
@property (assign) IBOutlet NSButton					*importSettingsButton;

@property (assign) IBOutlet NSButton					*automaticallyCheckForUpdate;

@property (assign) IBOutlet NSPanel                     *passwordPanel;
@property (assign) IBOutlet NSSecureTextField			*newPasswordTextField;
@property (assign) IBOutlet NSSecureTextField			*verifyPasswordTextField;
@property (assign) IBOutlet NSTextField                 *passwordMismatchTextField;

/** Attributes */
@property (readwrite, retain) SUUpdater					*updater;

@property (readwrite, retain) WPAccountManager			*accountManager;
@property (readwrite, retain) WPConfigManager			*configManager;
@property (readwrite, retain) WPExportManager			*exportManager;
@property (readwrite, retain) WPLogManager				*logManager;
@property (readwrite, retain) WPWiredManager			*wiredManager;

@property (readwrite, retain) WPPortChecker				*portChecker;
@property (readwrite)         WPPortCheckerStatus       portCheckerStatus;
@property (readwrite)         NSUInteger				portCheckerPort;

@property (readwrite)         NSInteger                 currentViewTag;

@property (readwrite, retain) NSImage					*greenDropImage;
@property (readwrite, retain) NSImage					*redDropImage;
@property (readwrite, retain) NSImage					*grayDropImage;

@property (readwrite, retain) WIDateFormatter           *dateFormatter;
@property (readwrite, retain) NSMutableArray            *logLines;
@property (readwrite, retain) NSMutableArray            *logRows;
@property (readwrite, retain) NSDictionary              *logAttributes;


- (IBAction)switchView:(id)sender;

- (IBAction)install:(id)sender;
- (IBAction)uninstall:(id)sender;
- (IBAction)releaseNotes:(id)sender;

- (IBAction)checkForUpdate:(id)sender;
- (IBAction)automaticallyCheckForUpdate:(id)sender;

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;

- (IBAction)launchAutomatically:(id)sender;
- (IBAction)enableStatusMenuItem:(id)sender;

- (IBAction)openLog:(id)sender;
- (IBAction)crashReports:(id)sender;

- (IBAction)other:(id)sender;
- (IBAction)index:(id)sender;
- (IBAction)reveal:(id)sender;

- (IBAction)port:(id)sender;
- (IBAction)mapPortAutomatically:(id)sender;
- (IBAction)checkPortAgain:(id)sender;

- (IBAction)pruneEvents:(id)sender;
- (IBAction)snapshotEnable:(id)sender;

- (IBAction)setPasswordForAdmin:(id)sender;
- (IBAction)createNewAdminUser:(id)sender;
- (IBAction)submitPasswordSheet:(id)sender;

- (IBAction)exportSettings:(id)sender;
- (IBAction)importSettings:(id)sender;

@end
