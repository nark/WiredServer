//
//  WHStatusController.h
//  Wired Server
//
//  Created by Rafaël Warnault on 26/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WHStatusController : NSObject {
	NSString *_wiredRoot;
	NSString *_version;
	NSString *_uptime;
	
	NSInteger _currentUsers;
	NSInteger _totalUsers;
	NSInteger _currentDownloads;
	NSInteger _totalDownloads;
	NSInteger _currentUploads;
	NSInteger _totalUploads;
	NSInteger _downloadsTraffic;
	NSInteger _uploadsTraffic;
	NSInteger _totalTraffic;
	NSInteger _currentTrackerServers;
	NSInteger _currentTrackerUsers;
	NSInteger _currentTrackerFiles;
	NSInteger _currentTrackerSize;
}

@property (readwrite, retain) NSString *wiredRoot;
@property (readwrite, retain) NSString *version;
@property (readwrite, retain) NSString *uptime;

@property (readwrite) NSInteger currentUsers;
@property (readwrite) NSInteger totalUsers;

@property (readwrite) NSInteger currentDownloads;
@property (readwrite) NSInteger totalDownloads;
@property (readwrite) NSInteger currentUploads;
@property (readwrite) NSInteger totalUploads;

@property (readwrite) NSInteger downloadsTraffic;
@property (readwrite) NSInteger uploadsTraffic;
@property (readwrite) NSInteger totalTraffic;

@property (readwrite) NSInteger currentTrackerServers;
@property (readwrite) NSInteger currentTrackerUsers;
@property (readwrite) NSInteger currentTrackerFiles;
@property (readwrite) NSInteger currentTrackerSize;

- (BOOL)reloadStatus;

@end
