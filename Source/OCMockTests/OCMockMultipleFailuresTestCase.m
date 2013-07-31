//
//  RHGTestsTestCase.m
//  OCMock
//
//  Created by Robert Gilliam on 7/30/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OCMock.h"

@interface OCMockMultipleFailuresTestCase : SenTestCase

@end

@implementation OCMockMultipleFailuresTestCase {
    id mock;
    id anotherMock;
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    STAssertTrue(NO, nil); // this will report a filure
    [mock verify]; // this will report that we failed to call `uppercaseString`, and re-report that we unexpectedly invoked: `lowercaseString` and `stringByAppendingString:`
    [anotherMock verify]; // one failure here
    
    [super tearDown];
}

//- (void)testAllFailuresReported
//{
//    mock = [OCMockObject mockForClass:[NSString class] testCase:self file:[NSString stringWithUTF8String:__FILE__]];
//    [[mock expect] uppercaseString];
//  
//    [mock lowercaseString]; // this should be reported as a failure
//    [mock stringByAppendingString:@""]; // this should too
//    
//    anotherMock = [OCMockObject mockForClass:[NSObject class] testCase:self file:[NSString stringWithUTF8String:__FILE__]];
//    [anotherMock valueForKey:@"a key"];
//}

@end
