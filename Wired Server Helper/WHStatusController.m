//
//  WHStatusController.m
//  Wired Server
//
//  Created by Rafaël Warnault on 26/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import "WHStatusController.h"

#define WIRED_RELATEIVE_ROOT_PATH @"~/Library/Wired"



@interface WHStatusController (Private)
- (NSString *)_statusString;
@end



@implementation WHStatusController


#pragma mark -

@synthesize wiredRoot               = _wiredRoot;

@synthesize version                 = _version;
@synthesize uptime                  = _uptime;

@synthesize currentUsers            = _currentUsers;
@synthesize totalUsers              = _totalUsers;

@synthesize currentDownloads        = _currentDownloads;
@synthesize totalDownloads          = _totalDownloads;
@synthesize currentUploads          = _currentUploads;
@synthesize totalUploads            = _totalUploads;

@synthesize downloadsTraffic        = _downloadsTraffic;
@synthesize uploadsTraffic          = _uploadsTraffic;
@synthesize totalTraffic            = _totalTraffic;

@synthesize currentTrackerServers   = _currentTrackerServers;
@synthesize currentTrackerUsers     = _currentTrackerUsers;
@synthesize currentTrackerFiles     = _currentTrackerFiles;
@synthesize currentTrackerSize      = _currentTrackerSize;



#pragma mark -

- (id)init {
    self = [super init];
    if (self) {
        _wiredRoot = [[WIRED_RELATEIVE_ROOT_PATH stringByExpandingTildeInPath] retain];
    }
    return self;
}

- (void)dealloc {
    [_wiredRoot release];
    [_version release];
    [_uptime release];
    [super dealloc];
}


#pragma mark -

- (BOOL)reloadStatus {
    NSData          *data;
    NSString        *statusPath, *statusString;
    NSArray         *statusComponents;
    
    statusPath      = [self.wiredRoot stringByAppendingPathComponent:@"wired.status"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:statusPath])
        return NO;
    
    data            = [NSData dataWithContentsOfFile:statusPath];
    
    if([data length] == 0)
        return NO;
    
    statusString    = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if([statusString length] == 0)
        return NO;
    
    statusComponents = [statusString componentsSeparatedByString:@" "];
    
    if([statusComponents count] != 13)
        return NO;
        
    self.uptime                 = (NSString*)[NSDate dateWithTimeIntervalSince1970:[[statusComponents objectAtIndex:0] doubleValue]];
    
    self.currentUsers           = [[statusComponents objectAtIndex:1] integerValue];
    self.totalUsers             = [[statusComponents objectAtIndex:2] integerValue];
    
    self.currentDownloads       = [[statusComponents objectAtIndex:3] integerValue];
    self.totalDownloads         = [[statusComponents objectAtIndex:4] integerValue];
    self.currentUploads         = [[statusComponents objectAtIndex:5] integerValue];
    self.totalUploads           = [[statusComponents objectAtIndex:6] integerValue];
    
    self.downloadsTraffic       = [[statusComponents objectAtIndex:7] integerValue];
    self.uploadsTraffic         = [[statusComponents objectAtIndex:8] integerValue];
    self.totalTraffic           = [[statusComponents objectAtIndex:9] integerValue];
    
    self.currentTrackerServers  = [[statusComponents objectAtIndex:10] integerValue];
    self.currentTrackerUsers    = [[statusComponents objectAtIndex:11] integerValue];
    self.currentTrackerFiles    = [[statusComponents objectAtIndex:12] integerValue];
    
    return YES;
}


- (NSString *)_statusString {
    
    NSString *launchPath = [self.wiredRoot stringByAppendingPathComponent:@"wiredctl"];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: launchPath];
    [task setArguments:[NSArray arrayWithObjects:@"status", NULL]];
    
    NSPipe *readPipe = [NSPipe pipe];
    NSFileHandle *readHandle = [readPipe fileHandleForReading];
    
    NSPipe *writePipe = [NSPipe pipe];
    NSFileHandle *writeHandle = [writePipe fileHandleForWriting];
    
    [task setStandardInput: writePipe];
    [task setStandardOutput: readPipe];
    
    [task launch];
    
    [writeHandle closeFile];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSData *readData;
    
    while ((readData = [readHandle availableData])
           && [readData length]) {
        [data appendData: readData];
    }
    
    NSString *strippedString;
    strippedString = [[NSString alloc]
                      initWithData: data
                      encoding: NSASCIIStringEncoding];
    
    [task release];
    [data release];
    [strippedString autorelease];
    
    return (strippedString);
}

@end
