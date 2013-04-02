//
//  WPDatabaseManager.h
//  Wired Server
//
//  Created by Rafaël Warnault on 08/01/12.
//  Copyright (c) 2012 Read-Write. All rights reserved.
//

#import <sqlite3.h>

typedef void (^WPDatabaseResultsBlock)(NSDictionary *results);

@interface WPDatabaseManager : WIObject {
    NSString                    *_dbPath;
    BOOL                        _isOpen;
}

+ (id)databaseManagerWithPath:(NSString *)string;

- (id)initWithDatabasePath:(NSString *)string;

- (BOOL)open;
- (void)close;

- (BOOL)executeQuery:(NSString *)string withBlock:(WPDatabaseResultsBlock)block;

- (BOOL)isOpen;

@end
