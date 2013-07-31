//---------------------------------------------------------------------------------------
//  $Id$
//  Copyright (c) 2004-2008 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "OCMockFailureReporter.h"

@interface OCMockObject : NSProxy
{
	BOOL			isNice;
	BOOL			expectationOrderMatters;
	NSMutableArray	*recorders;
	NSMutableArray	*expectations;
	NSMutableArray	*rejections;
	NSMutableArray	*failFastExceptions;
    id testCase;
}

// factory
+ (id)mockForClass:(Class)aClass;
+ (id)mockForProtocol:(Protocol *)aProtocol;
+ (id)partialMockForObject:(NSObject *)anObject;

+ (id)niceMockForClass:(Class)aClass;
+ (id)niceMockForProtocol:(Protocol *)aProtocol;

+ (id)observerMock;


+ (id)mockForClass:(Class)aClass testCase:(id)testCase file:(NSString *)aFile;
+ (id)mockForProtocol:(Protocol *)aProtocol testCase:(id)testCase file:(NSString *)aFile;
+ (id)niceMockForClass:(Class)aClass testCase:(id)testCase file:(NSString *)aFile;
+ (id)niceMockForProtocol:(Protocol *)aProtocol testCase:(id)testCase file:(NSString *)aFile;

// instance
- (id)init;
- (id)initWithTestCase:(id)testCase;

- (void)setExpectationOrderMatters:(BOOL)flag;

- (id)stub;
- (id)expect;
- (id)reject;

- (void)verify;

- (void)stopMocking;

@property (retain) id <OCMockFailureReporter> failureReporter; // readwrite only for tests.

// internal use only
@property (retain) NSString *file;
- (id)getNewRecorder;
- (BOOL)handleInvocation:(NSInvocation *)anInvocation;
- (void)handleUnRecordedInvocation:(NSInvocation *)anInvocation;
- (BOOL)handleSelector:(SEL)sel;

@end
