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
#import "WPSettings.h"
#import "WPWiredManager.h"

#define WPLibraryPath							@"~/Library"
#define WPWiredLaunchAgentPlistPath				@"~/Library/LaunchAgents/fr.read-write.WiredServer.plist"

@interface WPWiredManager(Private)

- (NSString *)_versionForWiredAtPath:(NSString *)path;

- (BOOL)_reloadPidFile;
- (BOOL)_reloadStatusFile;

@end


@implementation WPWiredManager(Private)

- (NSString *)_versionForWiredAtPath:(NSString *)path {
	NSTask			*task;
	NSString		*string;
	NSData			*data;
	
	if(![[NSFileManager defaultManager] isExecutableFileAtPath:path])
		return NULL;
	
	task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:path];
	[task setArguments:[NSArray arrayWithObject:@"-v"]];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[task standardOutput]];
	[task launch];
	[task waitUntilExit];
	
	data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
	
	if(data && [data length] > 0) {
		string = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
		
		if(string && [string length] > 0)
			return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	return NULL;
}



- (BOOL)_reloadPidFile {
	NSString		*string, *command;
	BOOL			running = NO;
	
	string = [NSString stringWithContentsOfFile:[self pathForFile:@"wired.pid"]
									   encoding:NSUTF8StringEncoding
										  error:NULL];
	
	if(string) {
		command = [[NSWorkspace sharedWorkspace] commandForProcessIdentifier:[string unsignedIntValue]];
		
		if([command isEqualToString:@"wired"]) {
			_pid = [string unsignedIntegerValue];
			
			running = YES;
		} else {
            [[NSFileManager defaultManager] removeItemAtPath:[self pathForFile:@"wired.pid"] error:nil];
		}
	}
	
	if(running != _running) {
		_running = running;
		
		return YES;
	}
	
	return NO;
}



- (BOOL)_reloadStatusFile {
	NSString		*string;
	NSArray			*status;
	NSDate			*date;
	
	string = [NSString stringWithContentsOfFile:[self pathForFile:@"wired.status"]
									   encoding:NSUTF8StringEncoding
										  error:NULL];
	
	if(string) {
		status = [string componentsSeparatedByString:@" "];
		date = [NSDate dateWithTimeIntervalSince1970:[[status objectAtIndex:0] intValue]];
		
		if(!_launchDate || ![date isEqualToDate:_launchDate]) {
			[_launchDate release];
			_launchDate = [date retain];
			
			return YES;
		}
	} else {
		if(_launchDate) {
			[_launchDate release];
			_launchDate = NULL;
			
			return YES;
		}
	}
	
	return NO;
}

@end



@implementation WPWiredManager

- (id)init {
	self = [super init];
	
	_rootPath = [[[WPLibraryPath stringByExpandingTildeInPath] stringByAppendingPathComponent:@"Wired"] retain];
	
	_statusTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0
													 target:self
												   selector:@selector(statusTimer:)
												   userInfo:NULL
													repeats:YES] retain];
	
	[_statusTimer fire];
	
	return self;
}



- (void)dealloc {
	[_rootPath release];
	
	[super dealloc];
}



#pragma mark -

- (void)statusTimer:(NSTimer *)timer {
	BOOL		notify = NO;
	
	if([self _reloadPidFile])
		notify = YES;
	
	if([self isRunning]) {
		if([self _reloadStatusFile])
			notify = YES;
	}

	if(notify)
		[[NSNotificationCenter defaultCenter] postNotificationName:WPWiredStatusDidChangeNotification object:self];
}



#pragma mark -

- (NSString *)rootPath {
	return _rootPath;
}



- (NSString *)pathForFile:(NSString *)file {
	return [_rootPath stringByAppendingPathComponent:file];
}



#pragma mark -

- (BOOL)isInstalled {
	return [[NSFileManager defaultManager] isExecutableFileAtPath:[self pathForFile:@"wired"]];
}



- (BOOL)isRunning {
	return _running;
}


- (NSDate *)launchDate {
	return _launchDate;
}



- (NSString *)installedVersion {
	return [self _versionForWiredAtPath:[self pathForFile:@"wired"]];
}



- (NSString *)packagedVersion {
	return [self _versionForWiredAtPath:[[[self bundle] resourcePath] stringByAppendingPathComponent:@"Wired/wired"]];
}



#pragma mark -

- (void)setLaunchesAutomatically:(BOOL)launchesAutomatically {
	NSMutableDictionary		*dictionary;
	
	dictionary = [[[NSDictionary dictionaryWithContentsOfFile:
		[WPWiredLaunchAgentPlistPath stringByExpandingTildeInPath]] mutableCopy] autorelease];
    
	[dictionary setBool:!launchesAutomatically forKey:@"Disabled"];
//    [dictionary setBool:launchesAutomatically forKey:@"KeepAlive"];
//    [dictionary setBool:launchesAutomatically forKey:@"RunAtLoad"];
	[dictionary writeToFile:[WPWiredLaunchAgentPlistPath stringByExpandingTildeInPath] atomically:YES];
    
    //[self restartWithError:nil];
}



- (BOOL)launchesAutomatically {
	NSDictionary *dictionary;
	
	dictionary = [NSDictionary dictionaryWithContentsOfFile:[WPWiredLaunchAgentPlistPath stringByExpandingTildeInPath]];
	return ![dictionary boolForKey:@"Disabled"];
}



#pragma mark -

- (void)makeServerReloadConfig {
	if([self isRunning]) {
        kill((int)_pid, SIGHUP);
    }
}



- (void)makeServerIndexFiles {
	if([self isRunning]) {
        kill((int)_pid, SIGUSR2);
    }
}



#pragma mark -

- (BOOL)installWithError:(WPError **)error {
	NSTask			*task;
	NSString		*string, *reason;
	NSData			*data;
	
	task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:[[self bundle] pathForResource:@"install" ofType:@"sh"]];
	[task setArguments:[NSArray arrayWithObjects:
		[[self bundle] resourcePath],
		[WPLibraryPath stringByExpandingTildeInPath],
		[[WPSettings settings] boolForKey:WPMigratedWired13] ? @"NO" : @"YES",
		NULL]];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[task standardOutput]];
	[task launch];
	[task waitUntilExit];
	
	if([task terminationStatus] == 0) {
		[[WPSettings settings] setBool:YES forKey:WPMigratedWired13];
		
		return YES;
	}
	
	reason = @"";
	data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
	
	if(data && [data length] > 0) {
		string = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
		
		if(string && [string length] > 0)
			reason = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}

    //reason = @"test";
	*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneInstallFailed argument:reason];

	return NO;
}



- (BOOL)uninstallWithError:(WPError **)error {
	NSTask			*task;
	NSString		*string, *reason;
	NSData			*data;
	
	task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:[[self bundle] pathForResource:@"uninstall" ofType:@"sh"]];
	[task setArguments:[NSArray arrayWithObject:[WPLibraryPath stringByExpandingTildeInPath]]];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[task standardOutput]];
	[task launch];
	[task waitUntilExit];
	
	if([task terminationStatus] == 0)
		return YES;
	
	reason = @"";
	data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
	
	if(data && [data length] > 0) {
		string = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
		
		if(string && [string length] > 0)
			reason = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneUninstallFailed argument:reason];
	
	return NO;
}


- (BOOL)updateWithError:(WPError **)error {
    NSTask			*task;
	NSString		*string, *reason;
	NSData			*data;
	
	task = [[[NSTask alloc] init] autorelease];
    
	task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:[[self bundle] pathForResource:@"update" ofType:@"sh"]];
	[task setArguments:[NSArray arrayWithObjects:
                        [[self bundle] resourcePath],
                        [WPLibraryPath stringByExpandingTildeInPath],
                        NULL]];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[task standardOutput]];
	[task launch];
	[task waitUntilExit];
	
	if([task terminationStatus] == 0)
		return YES;
	
	reason = @"";
	data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
	
	if(data && [data length] > 0) {
		string = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
		
		if(string && [string length] > 0)
			reason = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneInstallFailed argument:reason];
	
	return NO;
}


- (BOOL)startWithError:(WPError **)error {
	NSTask			*task;
	NSString		*string, *reason;
	NSData			*data;
    NSArray         *arguments;
	
	task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:@"/bin/launchctl"];
    
    arguments = [NSArray arrayWithObjects:
                 @"load",
                 @"-F",
                 [WPWiredLaunchAgentPlistPath stringByExpandingTildeInPath],
                 NULL];
    
	[task setArguments:arguments];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[task standardOutput]];
	[task launch];
	[task waitUntilExit];
	
	[_statusTimer fire];
	
	if([task terminationStatus] == 0)
		return YES;
	
	reason = @"";
	data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
	
	if(data && [data length] > 0) {
		string = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
		
		if(string && [string length] > 0)
			reason = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneStartFailed argument:reason];
	
	return NO;
}



- (BOOL)restartWithError:(WPError **)error {
	if(![self stopWithError:error])
		return NO;
	
	if(![self startWithError:error])
		return NO;
	
	return YES;
}



- (BOOL)stopWithError:(WPError **)error {
	NSTask			*task;
	NSString		*string, *reason;
	NSData			*data;
	NSArray         *arguments;
    
	task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:@"/bin/launchctl"];
    
    arguments = [NSArray arrayWithObjects:
                 @"unload",
                 [WPWiredLaunchAgentPlistPath stringByExpandingTildeInPath],
                 NULL];
    
	[task setArguments:arguments];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[task standardOutput]];
	[task launch];
	[task waitUntilExit];
	
	[_statusTimer fire];
	
	if([task terminationStatus] == 0)
		return YES;
	
	reason = @"";
	data = [[[task standardOutput] fileHandleForReading] readDataToEndOfFile];
	
	if(data && [data length] > 0) {
		string = [NSString stringWithData:data encoding:NSUTF8StringEncoding];
		
		if(string && [string length] > 0)
			reason = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	*error = [WPError errorWithDomain:WPPreferencePaneErrorDomain code:WPPreferencePaneStopFailed argument:reason];
	
	return NO;
}

@end
