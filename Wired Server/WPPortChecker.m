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

#import "WPPortChecker.h"

@implementation WPPortChecker

- (id)init {
	self = [super init];
	
	_data = [[NSMutableData alloc] init];
	
	return self;
}



- (void)dealloc {
	[_data release];
	
	[super dealloc];
}



#pragma mark -

- (void)setDelegate:(id)newDelegate {
	delegate = newDelegate;
}



- (id)delegate {
	return delegate;
}



#pragma mark -

- (void)checkStatusForPort:(NSUInteger)port {
	NSURLRequest		*request;
	NSURLConnection		*connection;
	
	_HTTPStatusCode		= 0;
	_port				= port;
	
	[_data setLength:0];
	
	request		= [NSURLRequest requestWithURL:[NSURL URLWithString:[NSSWF:@"http://wired.read-write.fr/scripts/port.php?port=%u", port]]];
	connection	= [NSURLConnection connectionWithRequest:request delegate:self];
}



#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if([response isKindOfClass:[NSHTTPURLResponse class]])
		_HTTPStatusCode = [(NSHTTPURLResponse *) response statusCode];
	else
		_HTTPStatusCode = 200;
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_data appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString				*string;
	NSUInteger				index;
	WPPortCheckerStatus		status = WPPortCheckerFailed;
	
	if([[self delegate] respondsToSelector:@selector(portChecker:didReceiveStatus:forPort:)]) {
		
		if(_HTTPStatusCode >= 400) {			
			NSLog(@"*** [%@ %@]: HTTP status code %lu", [self class], NSStringFromSelector(_cmd), _HTTPStatusCode);
		
		} else {			
			
			string = [[NSString stringWithData:_data encoding:NSUTF8StringEncoding]
				stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if([string length] > 0) {
				index = [string rangeOfString:@" = "].location;
				
				if(index != NSNotFound) {
					string = [string substringFromIndex:index + 3];
					
					if([string isEqualToString:@"open"])
						status = WPPortCheckerOpen;
					else if([string isEqualToString:@"closed"])
						status = WPPortCheckerClosed;
					else if([string isEqualToString:@"filtered"])
						status = WPPortCheckerFiltered;
				}
			}
		}
		
		[[self delegate] portChecker:self didReceiveStatus:status forPort:_port];
	}
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"*** [%@ %@]: %@", [self class], NSStringFromSelector(_cmd), [error localizedFailureReason]);
		
	if([[self delegate] respondsToSelector:@selector(portChecker:didReceiveStatus:forPort:)])
		[[self delegate] portChecker:self didReceiveStatus:WPPortCheckerFailed forPort:_port];
}

@end
