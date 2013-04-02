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

#import "WPSettings.h"

NSString * const WPMigratedWired13		= @"WPMigratedWired13";
NSString * const WPUninstalled			= @"WPUninstalled";
NSString * const WPUpdated              = @"WPUpdated";
NSString * const WPAutoUpdate           = @"WPAutoUpdate";

@implementation WPSettings

+ (id)settings {
	return [self settingsWithIdentifier:[[self bundle] bundleIdentifier]];
}

#pragma mark -

- (NSDictionary *)defaults {
	static NSDictionary *defaults;

	if(!defaults) {		
		defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithBool:NO], 
                    WPUpdated, 
                    [NSNumber numberWithBool:NO], 
                    WPAutoUpdate, 
                    nil]; 
    }
    
    return defaults;
}
                    
@end
