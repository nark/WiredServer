/* $Id$ */

/*
 *  Copyright (c) 2009 Axel Andersson
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

#import "WPError.h"

@implementation WPError

- (NSString *)localizedDescription {
	if([[self domain] isEqualToString:WPPreferencePaneErrorDomain]) {
		switch([self code]) {
			case WPPreferencePaneInstallFailed:
				return WPLS(@"Install Failed", @"WPPreferencePaneInstallFailed title");
				break;
				
			case WPPreferencePaneUninstallFailed:
				return WPLS(@"Uninstall Failed", @"WPPreferencePaneUninstallFailed title");
				break;
				
			case WPPreferencePaneStartFailed:
				return WPLS(@"Start Failed", @"WPPreferencePaneStartFailed title");
				break;
				
			case WPPreferencePaneStopFailed:
				return WPLS(@"Stop Failed", @"WPPreferencePaneStopFailed title");
				break;
				
			case WPPreferencePaneExportFailed:
				return WPLS(@"Export Failed", @"WPPreferencePaneExportFailed title");
				break;
				
			case WPPreferencePaneImportFailed:
				return WPLS(@"Import Failed", @"WPPreferencePaneImportFailed title");
				break;
				
			case WPPreferencePaneUsersReadFailed:
				return WPLS(@"Read Accounts Failed", @"WPPreferencePaneUsersReadFailed title");
				break;
				
			case WPPreferencePaneUsersWriteFailed:
				return WPLS(@"Write Accounts Failed", @"WPPreferencePaneUsersWriteFailed title");
				break;
				
			default:
				break;
		}
	}
	
	return [super localizedDescription];
}



- (NSString *)localizedFailureReason {
	id		argument;
	
	argument = [[self userInfo] objectForKey:WIArgumentErrorKey];

	if([[self domain] isEqualToString:WPPreferencePaneErrorDomain]) {
		switch([self code]) {
			case WPPreferencePaneInstallFailed:
				return [NSSWF:WPLS(@"Wired Server could not be installed:\n\n%@.", @"WPPreferencePaneInstallFailed description (output)"),
					argument];
				break;
				
			case WPPreferencePaneUninstallFailed:
				return [NSSWF:WPLS(@"Wired Server could not be uninstalled:\n\n%@.", @"WPPreferencePaneUninstallFailed description (output)"),
					argument];
				break;
				
			case WPPreferencePaneStartFailed:
				return [NSSWF:WPLS(@"Wired Server could not be started:\n\n%@.", @"WPPreferencePaneStartFailed description (output)"),
					argument];
				break;
				
			case WPPreferencePaneStopFailed:
				return [NSSWF:WPLS(@"Wired Server could not be stopped:\n\n%@.", @"WPPreferencePaneStopFailed description (output)"),
					argument];
				break;
				
			case WPPreferencePaneExportFailed:
				return WPLS(@"Could not write settings data to file.", @"WPPreferencePaneExportFailed description");
				break;
				
			case WPPreferencePaneImportFailed:
				return WPLS(@"Could not read settings data from file.", @"WPPreferencePaneExportFailed description");
				break;
				
			case WPPreferencePaneUsersReadFailed:
				return WPLS(@"Could not read user accounts from file.", @"WPPreferencePaneUsersReadFailed description");
				break;
				
			case WPPreferencePaneUsersWriteFailed:
				return WPLS(@"Could not write user accounts from file.", @"WPPreferencePaneUsersWriteFailed description");
				break;
				
			default:
				break;
		}
	}
	
	return [super localizedFailureReason];
}

@end
