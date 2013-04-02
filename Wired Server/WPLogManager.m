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

#import "WPLogManager.h"

@implementation WPLogManager

- (id)initWithLogPath:(NSString *)logPath {
	self = [super init];
	
	_logPath	= [logPath retain];
	_logLines	= [[NSMutableArray alloc] initWithCapacity:10000];
	_logTimer	= [[NSTimer scheduledTimerWithTimeInterval:1.0
													target:self
												   selector:@selector(logTimer:)
												   userInfo:NULL
													repeats:YES] retain];
	
	[[NSNotificationCenter defaultCenter]
		addObserver:self
		   selector:@selector(applicationWillTerminate:)
			   name:NSApplicationWillTerminateNotification];

	[[NSNotificationCenter defaultCenter]
		addObserver:self
		   selector:@selector(taskDidTerminate:)
			   name:NSTaskDidTerminateNotification];
	
	return self;
}



- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if(_tailFile)
		fclose(_tailFile);
	
	[_tailTask release];
	
	[_logTimer release];
	[_logLines release];
	[_logPath release];
	
	[super dealloc];
}



#pragma mark -

- (void)applicationWillTerminate:(NSNotification *)notification {
	[_tailTask terminate];
	[_logTimer invalidate];
}



- (void)taskDidTerminate:(NSNotification *)notification {
	if([notification object] == _tailTask)
		[self stopReadingFromLog];
}



#pragma mark -

- (void)logTimer:(NSTimer *)timer {
	NSMutableArray		*lines = NULL;
	NSString			*string;
	char				buffer[1024];
	
	if(_tailFile > 0) {
		while(fgets(buffer, sizeof(buffer), _tailFile) != NULL) {
			string = [[NSString stringWithUTF8String:buffer] stringByTrimmingCharactersInSet:
				[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if([string length] > 0) {
				if(!lines)
					lines = [NSMutableArray array];
				
				[lines addObject:string];
			}
		}
	}

	if(lines)
		[[NSNotificationCenter defaultCenter] postNotificationName:WPLogManagerDidReadLinesNotification object:lines];
}



#pragma mark -

- (void)startReadingFromLog {
	NSFileHandle	*fileHandle;
	int				fd;
	
	if(_tailTask)
		return;
	
	_tailTask = [[NSTask alloc] init];
	[_tailTask setLaunchPath:@"/usr/bin/tail"];
	[_tailTask setArguments:[NSArray arrayWithObjects:@"-100", @"-f", _logPath, NULL]];
	[_tailTask setStandardOutput:[NSPipe pipe]];
	[_tailTask setStandardError:[_tailTask standardOutput]];
	[_tailTask launch];
	
	fileHandle		= [[_tailTask standardOutput] fileHandleForReading];
	fd				= [fileHandle fileDescriptor];
	
	if(fcntl(fd, F_SETFL, O_NONBLOCK) < 0)
		NSLog(@"fnctl: %s", strerror(errno));
	
	_tailFile		= fdopen(fd, "r");
}



- (void)stopReadingFromLog {
	[_tailTask terminate];
	[_tailTask release];
	_tailTask = NULL;
	
	fclose(_tailFile);
	_tailFile = NULL;
}

@end
