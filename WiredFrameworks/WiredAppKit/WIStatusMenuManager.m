//
//  WSStatusManager.m
//  Wired Server
//
//  Created by Rafaël Warnault on 26/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import "WIStatusMenuManager.h"
#import <ServiceManagement/ServiceManagement.h>

@implementation WIStatusMenuManager

+ (void)startHelper:(NSURL *)itemURL {
    [[NSWorkspace sharedWorkspace] openURL:itemURL];
}

+ (void)stopHelper:(NSURL *)itemURL {
    system("killall 'Wired Server Helper'");
}

+ (BOOL)isHelperRunning:(NSString *)bundleID {
    BOOL result = NO;
    NSArray *running = [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleID];
    if ([running count] > 0) {
        result = YES;;
    }
    return result;
}

+ (void) setStartAtLogin:(NSString *)bundleID enabled:(BOOL)enabled
{
    SMLoginItemSetEnabled((__bridge CFStringRef)bundleID, enabled);     
}

@end
