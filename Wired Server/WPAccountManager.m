/* $Id$ */

/*
 *  Copyright (c) 2003-2009 Axel Andersson
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "WPAccountManager.h"
#import "WPDatabaseManager.h"
#import "WPError.h"



@interface WPAccountManager (Private)
- (BOOL)_deleteUserAccountWithName:(NSString *)name error:(NSError **)error;
@end


@implementation WPAccountManager

- (id)initWithDatabasePath:(NSString *)dbpath {
	self = [super init];
    
    _dbPath = [dbpath retain];
	
	_dateFormatter = [[WIDateFormatter alloc] init];
	[_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[_dateFormatter setDateStyle:NSDateFormatterShortStyle];

	return self;
}



- (void)dealloc {

	[_dbPath release];
	[_dateFormatter release];
	
	[super dealloc];
}



#pragma mark -

- (WPAccountStatus)hasUserAccountWithName:(NSString *)name password:(NSString **)password {
    
    __block BOOL        found       = NO;
    __block NSString    *aPassword  = nil;
    
    WPDatabaseManager *dbManager;
    NSString *query;
    
    query = @"SELECT `name`,`password` FROM users WHERE name = 'admin'";
    dbManager = [WPDatabaseManager databaseManagerWithPath:_dbPath];
    
    if(![dbManager open])
        return WPAccountFailed;
    
    [dbManager executeQuery:query withBlock:^(NSDictionary *results) {
        
        if(results)
            aPassword = [results objectForKey:@"password"];
        
        found = YES;
    }];
    
    [dbManager close];
    
    if(found) {
        if(aPassword && password) {
            *password = [aPassword retain];
            return WPAccountOK;
        }
        return WPAccountNotFound;
    } else
        return WPAccountNotFound;
}



#pragma mark -

- (BOOL)setPassword:(NSString *)password forUserAccountWithName:(NSString *)name andWriteWithError:(WPError **)error {
    
    __block BOOL        succes       = YES;
    
    WPDatabaseManager *dbManager;
    NSString *query;
    
    query = [NSString stringWithFormat:@"UPDATE users SET password='%@' WHERE name = '%@'", [password SHA1], name];
    dbManager = [WPDatabaseManager databaseManagerWithPath:_dbPath];
    
    if(![dbManager open]) {
		*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersReadFailed];
		return NO;
	}
    
    if(![dbManager executeQuery:query withBlock:^(NSDictionary *results) {
        if(!results) {
            *error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersWriteFailed];
            succes = NO;
        }
    }]) {
        *error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersWriteFailed];
        succes = NO;
    }
    
    [dbManager close];

    return succes;
}



- (BOOL)createNewAdminUserAccountWithName:(NSString *)name password:(NSString *)password andWriteWithError:(WPError **)error {
    
    __block BOOL        succes       = YES;
    
    WPDatabaseManager *dbManager;
    NSString *query;
    
    if([self hasUserAccountWithName:name password:NULL
        ]) {
        [self _deleteUserAccountWithName:name error:error];
    }
    
    NSLog(@"createNewAdminUserAccountWithName: %@", password);
    
    query = [NSString stringWithFormat:@"INSERT INTO users ("
    "name, "
    "full_name, "
    "creation_time, "
    "downloads, "
    "download_transferred, "
    "uploads, "
    "upload_transferred, "
    "password, "
    "color, "
    "user_get_info, "
    "user_disconnect_users, "
    "user_ban_users, "
    "user_get_users, "
    "chat_kick_users, "
    "chat_set_topic, "
    "chat_create_chats, "
    "message_send_messages, "
    "message_broadcast, "
    "file_list_files, "
    "file_search_files, "
    "file_get_info, "
    "file_create_links, "
    "file_rename_files, "
    "file_set_type, "
    "file_set_comment, "
    "file_set_permissions, "
    "file_set_executable, "
    "file_set_label, "
    "file_create_directories, "
    "file_move_files, "
    "file_delete_files, "
    "file_access_all_dropboxes, "
    "account_change_password, "
    "account_list_accounts, "
    "account_read_accounts, "
    "account_create_users, "
    "account_edit_users, "
    "account_delete_users, "
    "account_create_groups, "
    "account_edit_groups, "
    "account_delete_groups, "
    "account_raise_account_privileges, "
    "transfer_download_files, "
    "transfer_upload_files, "
    "transfer_upload_anywhere, "
    "transfer_upload_directories, "
    "board_read_boards, "
    "board_add_boards, "
    "board_move_boards, "
    "board_rename_boards, "
    "board_delete_boards, "
    "board_get_board_info, "
    "board_set_board_info, "
    "board_add_threads, "
    "board_move_threads, "
    "board_add_posts, "
    "board_edit_own_threads_and_posts, "
    "board_edit_all_threads_and_posts, "
    "board_delete_own_threads_and_posts, "
    "board_delete_all_threads_and_posts, "
    "log_view_log, "
    "events_view_events, "
    "settings_get_settings, "
    "settings_set_settings, "
    "banlist_get_bans, "
    "banlist_add_bans, "
    "banlist_delete_bans, "
    "tracker_list_servers, "
    "tracker_register_servers) "
    "VALUES ( "
    "'%@', "
    "'Administrator', "
    "DATETIME(), "
    "0, 0, 0, 0, "
    "'%@', "
    "'wired.account.color.red', "
    "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, "
    "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, "
    "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, "
    "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)", name, [password SHA1]];
    
    dbManager = [WPDatabaseManager databaseManagerWithPath:_dbPath];
    
    if(![dbManager open]) {
		*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersReadFailed];
		return NO;
	}
    
    if(![dbManager executeQuery:query withBlock:^(NSDictionary *results) {
        if(!results) {
            *error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersWriteFailed];
            succes = NO;
        }
    }]) {
        *error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersWriteFailed];
        succes = NO;
    }
    
    [dbManager close];

	return succes;
}


- (BOOL)_deleteUserAccountWithName:(NSString *)name error:(NSError **)error {
    
    __block BOOL        succes       = YES;
    
    WPDatabaseManager *dbManager;
    NSString *query;
    
    query = [NSString stringWithFormat:@"DELETE FROM users WHERE name = '%@'", name];
    dbManager = [WPDatabaseManager databaseManagerWithPath:_dbPath];
    
    if(![dbManager open]) {
		*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersReadFailed];
		return NO;
	}
    
    if(![dbManager executeQuery:query withBlock:^(NSDictionary *results) {
        if(!results) {
            *error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersWriteFailed];
            succes = NO;
        }
    }]) {
        *error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUsersWriteFailed];
        succes = NO;
    }
    
    [dbManager close];
    
    return succes;
}



@end
