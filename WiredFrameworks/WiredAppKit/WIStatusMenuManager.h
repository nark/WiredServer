//
//  WSStatusManager.h
//  Wired Server
//
//  Created by Rafaël Warnault on 26/03/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class WPError;
 
@interface WIStatusMenuManager : NSObject

+ (void) setStartAtLogin:(NSString *)bundleID enabled:(BOOL)enabled;

+ (void) startHelper:(NSURL *)itemURL;
+ (void) stopHelper: (NSURL *)itemURL;
+ (BOOL) isHelperRunning;

@end
