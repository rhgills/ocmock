//---------------------------------------------------------------------------------------
//  $Id$
//  Copyright (c) 2004-2010 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <OCMock/OCMock.h>
#import "OCMockObjectTests.h"

#import "OCClassMockObject.h"

#import "OCMockFakeFailureReporter.h"
#import "TestClassWithSelectorMethod.h"
#import "TestClassWithTypeQualifierMethod.h"
#import "TestClassWithIntPointerMethod.h"
#import "NotificationRecorderForTesting.h"

// --------------------------------------------------------------------------------------
//  setup
// --------------------------------------------------------------------------------------

@implementation OCMockObjectTests {
    id stringMock;
    id arrayMock;
    id instanceWithSelectorMethodMock;
    id mutableDataMock;
    id mockArg;
    id niceMock;
    id objectMock;
    
    OCMockFakeFailureReporter *fakeFailureReporter;
}

- (void)setUp
{
    stringMock = [[OCClassMockObject alloc] initWithClass:[NSString class]];
    arrayMock = [[OCClassMockObject alloc] initWithClass:[NSArray class]];
    instanceWithSelectorMethodMock = [[OCClassMockObject alloc] initWithClass:[TestClassWithSelectorMethod class]];
    mutableDataMock = [[OCClassMockObject alloc] initWithClass:[NSMutableData class]];;
    mockArg = [[OCClassMockObject alloc] initWithClass:[NSObject class]];
    niceMock = [[OCClassMockObject alloc] initWithClass:[NSString class] isNice:YES];
    objectMock = [[OCClassMockObject alloc] initWithClass:[NSObject class]];
    
    fakeFailureReporter = [[OCMockFakeFailureReporter alloc] init];
    [self useFakeFailureReporter];
}

- (void)useFakeFailureReporter;
{
    // It is safe to set all of the mocks to the same failure reporter, as long as multiple mocks are not used in a single test case.
    [stringMock setFailureReporter:fakeFailureReporter];
    [arrayMock setFailureReporter:fakeFailureReporter];
    [instanceWithSelectorMethodMock setFailureReporter:fakeFailureReporter];
    [mutableDataMock setFailureReporter:fakeFailureReporter];
    // NB: mockArg does not have its failure reporter set because it is only passed around as an argument. mockArg should never have any methods called on it - thus, it will never fail.
    [niceMock setFailureReporter:fakeFailureReporter];
    [objectMock setFailureReporter:fakeFailureReporter];
}


// --------------------------------------------------------------------------------------
//	accepting stubbed methods / rejecting methods not stubbed
// --------------------------------------------------------------------------------------

- (void)testAcceptsStubbedMethod
{
	[[stringMock stub] lowercaseString];
	[stringMock lowercaseString];
    
    [self shouldNotHaveReportedAFailure];
}

- (void)testReportsFailureWhenUnknownMethodIsCalled
{
    [[stringMock stub] lowercaseString];
    [self shouldNotHaveReportedAFailure];
    
    [stringMock uppercaseString];
    [self shouldHaveReportedAFailure];
}

- (void)shouldNotHaveReportedAFailure;
{
    STAssertNotNil([stringMock failureReporter], @"Should have connected the fake failure reporter to the mock object.");
    STAssertFalse(fakeFailureReporter.failedWithException, @"Should not have reported a failure to the failure reporter.");
}

- (void)shouldHaveReportedAFailure;
{
    STAssertNotNil([stringMock failureReporter], @"Should have connected the fake failure reporter to the mock object.");
    STAssertTrue(fakeFailureReporter.failedWithException, @"Should have reported a failure to the failure reporter.");
}

- (void)testAcceptsStubbedMethodWithSpecificArgument
{
	[[stringMock stub] hasSuffix:@"foo"];
	[stringMock hasSuffix:@"foo"];
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testAcceptsStubbedMethodWithConstraint
{
    [[stringMock stub] hasSuffix:[OCMArg any]];
	[stringMock hasSuffix:@"foo"];
	[stringMock hasSuffix:@"bar"];
    
    [self shouldNotHaveReportedAFailure];
}

#if NS_BLOCKS_AVAILABLE

- (void)testAcceptsStubbedMethodWithBlockArgument
{    
	[[arrayMock stub] indexesOfObjectsPassingTest:[OCMArg any]];
	[arrayMock indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) { return YES; }];
    
    [self shouldNotHaveReportedAFailure];
}

- (void)testStubbedMethodWithBlockConstraint
{
	[[stringMock stub] hasSuffix:[OCMArg checkWithBlock:^(id value) { return [value isEqualToString:@"foo"]; }]];

    [stringMock hasSuffix:@"foo"];
    [self shouldNotHaveReportedAFailure];
    
    [stringMock hasSuffix:@"bar"];
    [self shouldHaveReportedAFailure];
}

#endif

- (void)testAcceptsStubbedMethodWithNilArgument
{
	[[stringMock stub] hasSuffix:nil];
	[stringMock hasSuffix:nil];
    
    [self shouldNotHaveReportedAFailure];
}

- (void)testRaisesExceptionWhenMethodWithWrongArgumentIsCalled
{
	[[stringMock stub] hasSuffix:@"foo"];
    
    [stringMock hasSuffix:@"xyz"];
    [self shouldHaveReportedAFailure];
}


- (void)testAcceptsStubbedMethodWithScalarArgument
{
	[[stringMock stub] stringByPaddingToLength:20 withString:@"foo" startingAtIndex:5];
	[stringMock stringByPaddingToLength:20 withString:@"foo" startingAtIndex:5];
    [self shouldNotHaveReportedAFailure];
}

- (void)testRaisesExceptionWhenMethodWithOneWrongScalarArgumentIsCalled
{
	[[stringMock stub] stringByPaddingToLength:20 withString:@"foo" startingAtIndex:5];
    [stringMock stringByPaddingToLength:20 withString:@"foo" startingAtIndex:3];
    [self shouldHaveReportedAFailure];
}


- (void)testAcceptsStubbedMethodWithSelectorArgument
{    
    [[instanceWithSelectorMethodMock stub] doWithSelector:@selector(allKeys)];
    [instanceWithSelectorMethodMock doWithSelector:@selector(allKeys)];
    
    [self shouldNotHaveReportedAFailure];
}

- (void)testRaisesExceptionWhenMethodWithWrongSelectorArgumentIsCalled
{
    [[instanceWithSelectorMethodMock stub] doWithSelector:@selector(allKeys)];
    
    [instanceWithSelectorMethodMock doWithSelector:@selector(allValues)];
    [self shouldHaveReportedAFailure];
}

- (void)testAcceptsStubbedMethodWithAnySelectorArgument
{
    [[instanceWithSelectorMethodMock stub] doWithSelector:[OCMArg anySelector]];
    [instanceWithSelectorMethodMock doWithSelector:@selector(allKeys)];
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testAcceptsStubbedMethodWithPointerArgument
{
	NSError *error;
	[[[stringMock stub] andReturnValue:@YES] writeToFile:[OCMArg any] atomically:YES encoding:NSMacOSRomanStringEncoding error:&error];

	STAssertTrue([stringMock writeToFile:@"foo" atomically:YES encoding:NSMacOSRomanStringEncoding error:&error], nil);
    [self shouldNotHaveReportedAFailure];
}

- (void)testRaisesExceptionWhenMethodWithWrongPointerArgumentIsCalled
{
	NSString *string;
	NSString *anotherString;
	NSArray *array;

	[[stringMock stub] completePathIntoString:&string caseSensitive:YES matchesIntoArray:&array filterTypes:[OCMArg any]];

	[stringMock completePathIntoString:&anotherString caseSensitive:YES matchesIntoArray:&array filterTypes:[OCMArg any]];
    
    [self shouldHaveReportedAFailure];
}

- (void)testAcceptsStubbedMethodWithAnyPointerArgument
{
    NSError *error;
    [[[stringMock stub] andReturnValue:@YES] writeToFile:[OCMArg any] atomically:YES encoding:NSMacOSRomanStringEncoding error:[OCMArg anyPointer]];

    STAssertTrue([stringMock writeToFile:@"foo" atomically:YES encoding:NSMacOSRomanStringEncoding error:&error], nil);
    [self shouldNotHaveReportedAFailure];
}

- (void)testAcceptsStubbedMethodWithVoidPointerArgument
{
	[[mutableDataMock stub] appendBytes:NULL length:0];
	[mutableDataMock appendBytes:NULL length:0];
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testRaisesExceptionWhenMethodWithWrongVoidPointerArgumentIsCalled
{
	[[mutableDataMock stub] appendBytes:"foo" length:3];
	[mutableDataMock appendBytes:"bar" length:3];
    [self shouldHaveReportedAFailure];
}


- (void)testAcceptsStubbedMethodWithPointerPointerArgument
{
	NSError *error = nil;
	[[stringMock stub] initWithContentsOfFile:@"foo.txt" encoding:NSASCIIStringEncoding error:&error];
	[stringMock initWithContentsOfFile:@"foo.txt" encoding:NSASCIIStringEncoding error:&error];
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testRaisesExceptionWhenMethodWithWrongPointerPointerArgumentIsCalled
{
	NSError *error = nil, *error2;
	[[stringMock stub] initWithContentsOfFile:@"foo.txt" encoding:NSASCIIStringEncoding error:&error];
	[stringMock initWithContentsOfFile:@"foo.txt" encoding:NSASCIIStringEncoding error:&error2];
    [self shouldHaveReportedAFailure];
}


- (void)testAcceptsStubbedMethodWithStructArgument
{
    NSRange range = NSMakeRange(0,20);
	[[stringMock stub] substringWithRange:range];
	[stringMock substringWithRange:range];
     [self shouldNotHaveReportedAFailure];
}


- (void)testRaisesExceptionWhenMethodWithWrongStructArgumentIsCalled
{
    NSRange range = NSMakeRange(0,20);
    NSRange otherRange = NSMakeRange(0,10);
	[[stringMock stub] substringWithRange:range];
	[stringMock substringWithRange:otherRange];
    
    [self shouldHaveReportedAFailure];
}


- (void)testCanPassMocksAsArguments
{
	[[stringMock stub] stringByAppendingString:[OCMArg any]];
	[stringMock stringByAppendingString:mockArg];
    
    [self shouldNotHaveReportedAFailure];
}

- (void)testCanStubWithMockArguments
{
	[[stringMock stub] stringByAppendingString:mockArg];
	[stringMock stringByAppendingString:mockArg];
    
     [self shouldNotHaveReportedAFailure];
}

- (void)testRaisesExceptionWhenStubbedMockArgIsNotUsed
{
	[[stringMock stub] stringByAppendingString:mockArg];
    [stringMock stringByAppendingString:@"foo"];
    
    [self shouldHaveReportedAFailure];
}

- (void)testRaisesExceptionWhenDifferentMockArgumentIsPassed
{
	id expectedArg = [OCMockObject mockForClass:[NSString class]];
	id otherArg = [OCMockObject mockForClass:[NSString class]];
	[[stringMock stub] stringByAppendingString:otherArg];
	[stringMock stringByAppendingString:expectedArg];
    
    [self shouldHaveReportedAFailure];
}


- (void)testAcceptsStubbedMethodWithAnyNonObjectArgument
{
    [[[stringMock stub] ignoringNonObjectArgs] rangeOfString:@"foo" options:0];
    [stringMock rangeOfString:@"foo" options:NSRegularExpressionSearch];
}

- (void)testRaisesExceptionWhenMethodWithMixedArgumentsIsCalledWithWrongObjectArgument
{
    [[[stringMock stub] ignoringNonObjectArgs] rangeOfString:@"foo" options:0];
    [stringMock rangeOfString:@"bar" options:NSRegularExpressionSearch];
    [self shouldHaveReportedAFailure];
}


// --------------------------------------------------------------------------------------
//	returning values from stubbed methods
// --------------------------------------------------------------------------------------

- (void)testReturnsStubbedReturnValue
{
	[[[stringMock stub] andReturn:@"megamock"] lowercaseString];
	id returnValue = [stringMock lowercaseString];

	STAssertEqualObjects(@"megamock", returnValue, @"Should have returned stubbed value.");
}

- (void)testReturnsStubbedIntReturnValue
{
	[[[stringMock stub] andReturnValue:@42] intValue];
	int returnValue = [stringMock intValue];

	STAssertEquals(42, returnValue, @"Should have returned stubbed value.");
}

- (void)testRaisesWhenBoxedValueTypesDoNotMatch
{
	[[[stringMock stub] andReturnValue:@42.0] intValue];

	STAssertThrows([stringMock intValue], @"Should have raised an exception.");
}

- (void)testReturnsStubbedNilReturnValue
{
	[[[stringMock stub] andReturn:nil] uppercaseString];

	id returnValue = [stringMock uppercaseString];

	STAssertNil(returnValue, @"Should have returned stubbed value, which is nil.");
}


// --------------------------------------------------------------------------------------
//	beyond stubbing: raising exceptions, posting notifications, etc.
// --------------------------------------------------------------------------------------

- (void)testRaisesExceptionWhenAskedTo
{
	NSException *exception = [NSException exceptionWithName:@"TestException" reason:@"test" userInfo:nil];
	[[[stringMock expect] andThrow:exception] lowercaseString];

	STAssertThrows([stringMock lowercaseString], @"Should have raised an exception.");
}

static NSString *TestNotification = @"TestNotification";
- (void)testPostsNotificationWhenAskedTo
{
	NotificationRecorderForTesting *observer = [[[NotificationRecorderForTesting alloc] init] autorelease];
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(receiveNotification:) name:TestNotification object:nil];

	NSNotification *notification = [NSNotification notificationWithName:TestNotification object:self];
	[[[stringMock stub] andPost:notification] lowercaseString];

	[stringMock lowercaseString];

	STAssertNotNil(observer->notification, @"Should have sent a notification.");
	STAssertEqualObjects(TestNotification, [observer->notification name], @"Name should match posted one.");
	STAssertEqualObjects(self, [observer->notification object], @"Object should match posted one.");
}

- (void)testPostsNotificationInAdditionToReturningValue
{
	NotificationRecorderForTesting *observer = [[[NotificationRecorderForTesting alloc] init] autorelease];
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(receiveNotification:) name:TestNotification object:nil];

	NSNotification *notification = [NSNotification notificationWithName:TestNotification object:self];
	[[[[stringMock stub] andReturn:@"foo"] andPost:notification] lowercaseString];

	STAssertEqualObjects(@"foo", [stringMock lowercaseString], @"Should have returned stubbed value.");
	STAssertNotNil(observer->notification, @"Should have sent a notification.");
}


- (NSString *)valueForString:(NSString *)aString andMask:(NSStringCompareOptions)mask
{
	return [NSString stringWithFormat:@"[%@, %ld]", aString, mask];
}

- (void)testCallsAlternativeMethodAndPassesOriginalArgumentsAndReturnsValue
{
	[[[stringMock stub] andCall:@selector(valueForString:andMask:) onObject:self] commonPrefixWithString:@"FOO" options:NSCaseInsensitiveSearch];

	NSString *returnValue = [stringMock commonPrefixWithString:@"FOO" options:NSCaseInsensitiveSearch];

	STAssertEqualObjects(@"[FOO, 1]", returnValue, @"Should have passed and returned invocation.");
}

#if NS_BLOCKS_AVAILABLE

- (void)testCallsBlockWhichCanSetUpReturnValue
{
	void (^theBlock)(NSInvocation *) = ^(NSInvocation *invocation)
		{
			NSString *value;
			[invocation getArgument:&value atIndex:2];
			value = [NSString stringWithFormat:@"MOCK %@", value];
			[invocation setReturnValue:&value];
		};

	[[[stringMock stub] andDo:theBlock] stringByAppendingString:[OCMArg any]];

	STAssertEqualObjects(@"MOCK foo", [stringMock stringByAppendingString:@"foo"], @"Should have called block.");
	STAssertEqualObjects(@"MOCK bar", [stringMock stringByAppendingString:@"bar"], @"Should have called block.");
}

#endif

- (void)testThrowsWhenTryingToUseForwardToRealObjectOnNonPartialMock
{
	STAssertThrows([[[stringMock expect] andForwardToRealObject] name], @"Should have raised and exception.");
}


// --------------------------------------------------------------------------------------
//	returning values in pass-by-reference arguments
// --------------------------------------------------------------------------------------

- (void)testReturnsValuesInPassByReferenceArguments
{
	NSString *expectedName = @"Test";
	NSArray *expectedArray = [NSArray array];

	[[stringMock expect] completePathIntoString:[OCMArg setTo:expectedName] caseSensitive:YES
						 matchesIntoArray:[OCMArg setTo:expectedArray] filterTypes:[OCMArg any]];

	NSString *actualName = nil;
	NSArray *actualArray = nil;
	[stringMock completePathIntoString:&actualName caseSensitive:YES matchesIntoArray:&actualArray filterTypes:nil];

    [stringMock verify];
    [self shouldNotHaveReportedAFailure];
	STAssertEqualObjects(expectedName, actualName, @"The two string objects should be equal");
	STAssertEqualObjects(expectedArray, actualArray, @"The two array objects should be equal");
}


- (void)testReturnsValuesInNonObjectPassByReferenceArguments
{
    stringMock = [OCMockObject mockForClass:[TestClassWithIntPointerMethod class]];
    [self useFakeFailureReporter];
    [[stringMock stub] returnValueInPointer:[OCMArg setToValue:@1234]];

    int actualValue = 0;
    [stringMock returnValueInPointer:&actualValue];

    STAssertEquals(1234, actualValue, @"Should have returned value via pass by ref argument.");

}


// --------------------------------------------------------------------------------------
//	accepting expected methods
// --------------------------------------------------------------------------------------

- (void)testAcceptsExpectedMethod
{
    
	[[stringMock expect] lowercaseString];
	[stringMock lowercaseString];
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testAcceptsExpectedMethodAndReturnsValue
{
	[[[stringMock expect] andReturn:@"Objective-C"] lowercaseString];
	id returnValue = [stringMock lowercaseString];

	STAssertEqualObjects(@"Objective-C", returnValue, @"Should have returned stubbed value.");
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testAcceptsExpectedMethodsInRecordedSequence
{
	[[stringMock expect] lowercaseString];
	[[stringMock expect] uppercaseString];

	[stringMock lowercaseString];
	[stringMock uppercaseString];
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testAcceptsExpectedMethodsInDifferentSequence
{
	[[stringMock expect] lowercaseString];
	[[stringMock expect] uppercaseString];

	[stringMock uppercaseString];
	[stringMock lowercaseString];
    
    [self shouldNotHaveReportedAFailure];
}


// --------------------------------------------------------------------------------------
//	verifying expected methods
// --------------------------------------------------------------------------------------

- (void)testAcceptsAndVerifiesExpectedMethods
{
	[[stringMock expect] lowercaseString];
	[[stringMock expect] uppercaseString];

	[stringMock lowercaseString];
	[stringMock uppercaseString];

	[stringMock verify];
    
    [self shouldNotHaveReportedAFailure];
}


- (void)testRaisesExceptionOnVerifyWhenNotAllExpectedMethodsWereCalled
{
	[[stringMock expect] lowercaseString];
	[[stringMock expect] uppercaseString];

	[stringMock lowercaseString];

	[stringMock verify];
    [self shouldHaveReportedAFailure];
}

- (void)testAcceptsAndVerifiesTwoExpectedInvocationsOfSameMethod
{
	[[stringMock expect] lowercaseString];
	[[stringMock expect] lowercaseString];

	[stringMock lowercaseString];
	[stringMock lowercaseString];

	[stringMock verify];
    [self shouldNotHaveReportedAFailure];
}


- (void)testAcceptsAndVerifiesTwoExpectedInvocationsOfSameMethodAndReturnsCorrespondingValues
{
	[[[stringMock expect] andReturn:@"foo"] lowercaseString];
	[[[stringMock expect] andReturn:@"bar"] lowercaseString];

	STAssertEqualObjects(@"foo", [stringMock lowercaseString], @"Should have returned first stubbed value");
	STAssertEqualObjects(@"bar", [stringMock lowercaseString], @"Should have returned seconds stubbed value");

	[stringMock verify];
    [self shouldNotHaveReportedAFailure];
}

- (void)testReturnsStubbedValuesIndependentOfExpectations
{
	[[stringMock stub] hasSuffix:@"foo"];
	[[stringMock expect] hasSuffix:@"bar"];

	[stringMock hasSuffix:@"foo"];
	[stringMock hasSuffix:@"bar"];
	[stringMock hasSuffix:@"foo"]; // Since it's a stub, shouldn't matter how many times we call this

	[stringMock verify];
    [self shouldNotHaveReportedAFailure];
}

-(void)testAcceptsAndVerifiesMethodsWithSelectorArgument
{
	[[stringMock expect] performSelector:@selector(lowercaseString)];
	[stringMock performSelector:@selector(lowercaseString)];
	[stringMock verify];
    [self shouldNotHaveReportedAFailure];
}


// --------------------------------------------------------------------------------------
//	ordered expectations
// --------------------------------------------------------------------------------------

- (void)testAcceptsExpectedMethodsInRecordedSequenceWhenOrderMatters
{
	[stringMock setExpectationOrderMatters:YES];

	[[stringMock expect] lowercaseString];
	[[stringMock expect] uppercaseString];

	[stringMock lowercaseString];
	[stringMock uppercaseString];
    [self shouldNotHaveReportedAFailure];
}

- (void)testRaisesExceptionWhenSequenceIsWrongAndOrderMatters
{
	[stringMock setExpectationOrderMatters:YES];

	[[stringMock expect] lowercaseString];
	[[stringMock expect] uppercaseString];

	[stringMock uppercaseString];
    [self shouldHaveReportedAFailure];
}


// --------------------------------------------------------------------------------------
//	nice mocks don't complain about unknown methods, unless told to
// --------------------------------------------------------------------------------------

- (void)testReturnsDefaultValueWhenUnknownMethodIsCalledOnNiceClassMock
{
	STAssertNil([niceMock lowercaseString], @"Should return nil on unexpected method call (for nice mock).");
	[niceMock verify];
    [self shouldNotHaveReportedAFailure];
}

- (void)testRaisesAnExceptionWhenAnExpectedMethodIsNotCalledOnNiceClassMock
{
	[[[niceMock expect] andReturn:@"HELLO!"] uppercaseString];
	[niceMock verify];
    [self shouldHaveReportedAFailure];
}

- (void)testThrowsWhenRejectedMethodIsCalledOnNiceMock
{
    [[niceMock reject] uppercaseString];
    [niceMock uppercaseString];
    [self shouldHaveReportedAFailure];
}


// --------------------------------------------------------------------------------------
//	mocks should honour the NSObject contract, etc.
// --------------------------------------------------------------------------------------

- (void)testRespondsToValidSelector
{
	STAssertTrue([stringMock respondsToSelector:@selector(lowercaseString)], nil);
}

- (void)testDoesNotRespondToInvalidSelector
{
	STAssertFalse([stringMock respondsToSelector:@selector(fooBar)], nil);
}

- (void)testCanStubValueForKeyMethod
{
	id returnValue;
	[[[objectMock stub] andReturn:@"SomeValue"] valueForKey:@"SomeKey"];

	returnValue = [objectMock valueForKey:@"SomeKey"];

	STAssertEqualObjects(@"SomeValue", returnValue, @"Should have returned value that was set up.");
}

- (void)testForwardsIsKindOfClass
{
    STAssertTrue([stringMock isKindOfClass:[NSString class]], @"Should have pretended to be the mocked class.");
}

- (void)testWorksWithTypeQualifiers
{
    id myMock = [OCMockObject mockForClass:[TestClassWithTypeQualifierMethod class]];

    STAssertNoThrow([[myMock expect] aSpecialMethod:"foo"], @"Should not complain about method with type qualifiers.");
    STAssertNoThrow([myMock aSpecialMethod:"foo"], @"Should not complain about method with type qualifiers.");
}

- (void)testAdjustsRetainCountWhenStubbingMethodsThatCreateObjects
{
    NSString *objectToReturn = [NSString stringWithFormat:@"This is not a %@.", @"string constant"];
    [[[stringMock stub] andReturn:objectToReturn] mutableCopy];

    NSUInteger retainCountBefore = [objectToReturn retainCount];
    id returnedObject = [stringMock mutableCopy];
    [returnedObject release]; // the expectation is that we have to call release after a copy
    NSUInteger retainCountAfter = [objectToReturn retainCount];

    STAssertEqualObjects(objectToReturn, returnedObject, @"Should not stubbed copy method");
    STAssertEquals(retainCountBefore, retainCountAfter, @"Should have incremented retain count in copy stub.");
}


// --------------------------------------------------------------------------------------
//  some internal tests
// --------------------------------------------------------------------------------------

- (void)testReRaisesFailFastExceptionsOnVerify
{
    [stringMock lowercaseString];
    [fakeFailureReporter clearReportedFailures];

	[stringMock verify];
    [self shouldHaveReportedAFailure];
}

- (void)testReRaisesRejectExceptionsOnVerify
{
	[[niceMock reject] uppercaseString];

    [niceMock uppercaseString];
    [fakeFailureReporter clearReportedFailures];

    [niceMock verify];
    [self shouldHaveReportedAFailure];
}


- (void)testCanCreateExpectationsAfterInvocations
{
	[[stringMock expect] lowercaseString];
	[stringMock lowercaseString];
	[stringMock expect];
}

@end
