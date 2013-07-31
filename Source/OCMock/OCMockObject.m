//---------------------------------------------------------------------------------------
//  $Id$
//  Copyright (c) 2004-2009 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <OCMock/OCMockObject.h>
#import "OCClassMockObject.h"
#import "OCProtocolMockObject.h"
#import "OCPartialMockObject.h"
#import "OCObserverMockObject.h"
#import <OCMock/OCMockRecorder.h>
#import "NSInvocation+OCMAdditions.h"
#import "OCMockSenTestCaseFailureReporter.h"
#import "OCMockExceptionFailureReporter.h"

@interface OCMockObject(Private)
- (NSString *)_recorderDescriptions:(BOOL)onlyExpectations;
- (void)failWithException:(NSException *)exception;
- (void)failFastWithException:(NSException *)exception;
@end

#pragma mark  -
@interface NSException(Private)

+ (NSException *)failureInFile:(NSString *)fileName
                         atLine:(int)line 
                    withDescription:(NSString *)description, ... NS_FORMAT_FUNCTION(3, 4);

@end

#define failFastWithFormat(format, args...) \
{ \
[self failFastWithDescription:[NSString stringWithFormat:format, ##args]]; \
}

#define failWithFormat(format, args...) \
{ \
[self failWithDescription:[NSString stringWithFormat:format, ##args]]; \
}


@implementation OCMockObject

#pragma mark  Class initialisation

+ (void)initialize
{
	if([[NSInvocation class] instanceMethodSignatureForSelector:@selector(getArgumentAtIndexAsObject:)] == NULL)
		[NSException raise:NSInternalInconsistencyException format:@"** Expected method not present; the method getArgumentAtIndexAsObject: is not implemented by NSInvocation. If you see this exception it is likely that you are using the static library version of OCMock and your project is not configured correctly to load categories from static libraries. Did you forget to add the -force_load linker flag?"];
}


#pragma mark  Factory methods

+ (id)mockForClass:(Class)aClass
{
	return [self mockForClass:aClass testCase:nil file:nil];
}

+ (id)mockForClass:(Class)aClass testCase:(id)testCase file:(NSString *)aFile;
{
    OCClassMockObject *m = [[[OCClassMockObject alloc] initWithClass:aClass isNice:NO testCase:testCase] autorelease];
    [m setFile:aFile];
    return m;
}

+ (id)mockForProtocol:(Protocol *)aProtocol
{
	return [self mockForProtocol:aProtocol testCase:nil file:nil];
}

+ (id)mockForProtocol:(Protocol *)aProtocol testCase:(id)testCase file:(NSString *)aFile;
{
    OCProtocolMockObject *m = [[[OCProtocolMockObject alloc] initWithProtocol:aProtocol isNice:NO testCase:testCase] autorelease];
    [m setFile:aFile];
    return m;
}

+ (id)partialMockForObject:(NSObject *)anObject
{
	return [[[OCPartialMockObject alloc] initWithObject:anObject] autorelease];
}

//+ (id)partialMockForObject:(NSObject *)anObject testCase:(id)testCase;
//{
//    return [[[OCPartialMockObject alloc] initWithObject:anObject testCase:testCase] autorelease]; // NYI constructor
//}

+ (id)niceMockForClass:(Class)aClass
{
	return [self niceMockForClass:aClass testCase:nil file:nil];
}

+ (id)niceMockForClass:(Class)aClass testCase:(id)testCase file:(NSString *)aFile;
{
    OCMockObject *m = [[[OCClassMockObject alloc] initWithClass:aClass isNice:YES testCase:testCase] autorelease];
    [m setFile:aFile];
    return m;
}

+ (id)niceMockForProtocol:(Protocol *)aProtocol
{
    return [self niceMockForProtocol:aProtocol testCase:nil file:nil];
}

+ (id)niceMockForProtocol:(Protocol *)aProtocol testCase:(id)testCase file:(NSString *)aFile;
{
	OCMockObject *m = [[[OCProtocolMockObject alloc] initWithProtocol:aProtocol isNice:YES testCase:testCase] autorelease];
    [m setFile:aFile];
    return m;
}

+ (id)observerMock
{
	return [[[OCObserverMockObject alloc] init] autorelease];
}



#pragma mark  Initialisers, description, accessors, etc.

- (id)init
{
    return [self initWithTestCase:nil];
}

- (id)initWithTestCase:(id)aTestCase;
{
    // no [super init], we're inheriting from NSProxy
	expectationOrderMatters = NO;
	recorders = [[NSMutableArray alloc] init];
	expectations = [[NSMutableArray alloc] init];
	rejections = [[NSMutableArray alloc] init];
	failFastExceptions = [[NSMutableArray alloc] init];
    testCase = [aTestCase retain];
    if (testCase) {
        [self setFailureReporter:[[OCMockSenTestCaseFailureReporter alloc] initWithTestCase:testCase]];
    }else{
        [self setFailureReporter:[[OCMockExceptionFailureReporter alloc] init]];
    }
	return self;
}

- (void)dealloc
{
	[recorders release];
	[expectations release];
	[rejections	release];
	[failFastExceptions release];
    [testCase release];
    [self setFailureReporter:nil];
	[super dealloc];
}

- (NSString *)description
{
	return @"OCMockObject";
}


- (void)setExpectationOrderMatters:(BOOL)flag
{
    expectationOrderMatters = flag;
}


#pragma mark  Public API

- (id)stub
{
	OCMockRecorder *recorder = [self getNewRecorder];
	[recorders addObject:recorder];
	return recorder;
}


- (id)expect
{
	OCMockRecorder *recorder = [self stub];
	[expectations addObject:recorder];
	return recorder;
}


- (id)reject
{
	OCMockRecorder *recorder = [self stub];
	[rejections addObject:recorder];
	return recorder;
}


- (void)verify
{
    if([expectations count] == 1)
	{
        failFastWithFormat(@"%@: expected method was not invoked: %@",
                           [self description], [[expectations objectAtIndex:0] description]);
	}else if([expectations count] > 0)
	{
        failFastWithFormat(@"%@ : %@ expected methods were not invoked: %@",
                           [self description], @([expectations count]), [self _recorderDescriptions:YES]);
	}else{
        [self rethrowFailFastExceptions];
    }
}

- (void)failFastWithDescription:(NSString *)description;
{    
    [self failFastWithException:[self exceptionWithDescription:description]];
}

- (void)failWithDescription:(NSString *)description;
{
    [self failWithException:[self exceptionWithDescription:description]];
}

- (NSException *)exceptionWithDescription:(NSString *)description;
{
    return [NSException failureInFile:[self file] atLine:0 withDescription:@"%@", description];
}

- (void)rethrowFailFastExceptions;
{
    if([failFastExceptions count] > 0)
	{
		[self failWithException:failFastExceptions[0]];
	}
}

- (void)stopMocking
{
    // no-op for mock objects that are not class object or partial mocks
}

#pragma mark  Handling invocations

- (BOOL)handleSelector:(SEL)sel
{
    for (OCMockRecorder *recorder in recorders)
        if ([recorder matchesSelector:sel])
            return YES;

    return NO;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	if([self handleInvocation:anInvocation] == NO)
		[self handleUnRecordedInvocation:anInvocation];
}

- (BOOL)handleInvocation:(NSInvocation *)anInvocation
{
	OCMockRecorder *recorder = nil;
	unsigned int			   i;
	
	for(i = 0; i < [recorders count]; i++)
	{
		recorder = [recorders objectAtIndex:i];
		if([recorder matchesInvocation:anInvocation])
			break;
	}
	
	if(i == [recorders count])
		return NO;
	
	if([rejections containsObject:recorder]) 
	{
        failFastWithFormat(@"%@: explicitly disallowed method invoked: %@", [self description],
                           [anInvocation invocationDescription]);
	}

	if([expectations containsObject:recorder])
	{
		if(expectationOrderMatters && ([expectations objectAtIndex:0] != recorder))
		{
            failFastWithFormat(@"%@: unexpected method invoked: %@\n\texpected:\t%@",
                               [self description], [recorder description], [[expectations objectAtIndex:0] description]);
		}
		[[recorder retain] autorelease];
		[expectations removeObject:recorder];
		[recorders removeObjectAtIndex:i];
	}
	[[recorder invocationHandlers] makeObjectsPerformSelector:@selector(handleInvocation:) withObject:anInvocation];
	
	return YES;
}

- (void)handleUnRecordedInvocation:(NSInvocation *)anInvocation
{
	if(isNice == NO)
	{
        failFastWithFormat(@"%@: unexpected method invoked: %@ %@",  [self description],
                           [anInvocation invocationDescription], [self _recorderDescriptions:NO]);
	}
}

- (void)failWithException:(NSException *)exception;
{
    [[self failureReporter] failWithException:exception];
}

- (void)failFastWithException:(NSException *)exception;
{
    [failFastExceptions addObject:exception];
    [self failWithException:exception];
}

#pragma mark  Helper methods
- (id)getNewRecorder
{
	return [[[OCMockRecorder alloc] initWithSignatureResolver:self] autorelease];
}


- (NSString *)_recorderDescriptions:(BOOL)onlyExpectations
{
	NSMutableString *outputString = [NSMutableString string];
	
	OCMockRecorder *currentObject;
	NSEnumerator *recorderEnumerator = [recorders objectEnumerator];
	while((currentObject = [recorderEnumerator nextObject]) != nil)
	{
		NSString *prefix;
		
		if(onlyExpectations)
		{
			if(![expectations containsObject:currentObject])
				continue;
			prefix = @" ";
		}
		else
		{
			if ([expectations containsObject:currentObject])
				prefix = @"expected: ";
			else
				prefix = @"stubbed: ";
		}
		[outputString appendFormat:@"\n\t%@\t%@", prefix, [currentObject description]];
	}
	
	return outputString;
}


@end
