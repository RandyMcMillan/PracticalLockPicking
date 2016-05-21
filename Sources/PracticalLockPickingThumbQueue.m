//
//	PracticalLockPickingThumbQueue.m
//	PracticalLockPicking v2.8.6
//
//	Created by Julius Oklamcak on 2011-09-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "PracticalLockPickingThumbQueue.h"

@implementation PracticalLockPickingThumbQueue
{
	NSOperationQueue *loadQueue;

	NSOperationQueue *workQueue;
}

#pragma mark - PracticalLockPickingThumbQueue class methods

+ (PracticalLockPickingThumbQueue *)sharedInstance
{
	static dispatch_once_t predicate = 0;

	static PracticalLockPickingThumbQueue *object = nil; // Object

	dispatch_once(&predicate, ^{ object = [self new]; });

	return object; // PracticalLockPickingThumbQueue singleton
}

#pragma mark - PracticalLockPickingThumbQueue instance methods

- (instancetype)init
{
	if ((self = [super init])) // Initialize
	{
		loadQueue = [NSOperationQueue new];

		[loadQueue setName:@"PracticalLockPickingThumbLoadQueue"];

		[loadQueue setMaxConcurrentOperationCount:1];

		workQueue = [NSOperationQueue new];

		[workQueue setName:@"PracticalLockPickingThumbWorkQueue"];

		[workQueue setMaxConcurrentOperationCount:1];
	}

	return self;
}

- (void)addLoadOperation:(NSOperation *)operation
{
	if ([operation isKindOfClass:[PracticalLockPickingThumbOperation class]])
	{
		[loadQueue addOperation:operation]; // Add to load queue
	}
}

- (void)addWorkOperation:(NSOperation *)operation
{
	if ([operation isKindOfClass:[PracticalLockPickingThumbOperation class]])
	{
		[workQueue addOperation:operation]; // Add to work queue
	}
}

- (void)cancelOperationsWithGUID:(NSString *)guid
{
	[loadQueue setSuspended:YES]; [workQueue setSuspended:YES];

	for (PracticalLockPickingThumbOperation *operation in loadQueue.operations)
	{
		if ([operation isKindOfClass:[PracticalLockPickingThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	for (PracticalLockPickingThumbOperation *operation in workQueue.operations)
	{
		if ([operation isKindOfClass:[PracticalLockPickingThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	[workQueue setSuspended:NO]; [loadQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
	[loadQueue cancelAllOperations]; [workQueue cancelAllOperations];
}

@end

#pragma mark -

//
//	PracticalLockPickingThumbOperation class implementation
//

@implementation PracticalLockPickingThumbOperation
{
	NSString *_guid;
}

@synthesize guid = _guid;

#pragma mark - PracticalLockPickingThumbOperation instance methods

- (instancetype)initWithGUID:(NSString *)guid
{
	if ((self = [super init]))
	{
		_guid = guid;
	}

	return self;
}

@end
