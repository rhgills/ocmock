//
//  OCMockObjectIntegrationTests.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "OCMockObjectIntegrationTests.h"
#import "FakeSenTestCase.h"
#import "OCMockObject.h"

@implementation OCMockObjectIntegrationTests

- (void)testReportsFailureToSenTestCase;
{
    FakeSenTestCase *testCase = [[FakeSenTestCase alloc] init];
    id mock = [OCMockObject mockForClass:[NSString class] testCase:testCase file:[NSString stringWithUTF8String:__FILE__]];
    STAssertFalse([testCase failed], @"Should not have been marked as failed.");
    
    [mock uppercaseString];
    
    STAssertTrue([testCase failed], @"Should have been marked as failed.");
}

- (void)testReportsFailureByRaisingException;
{
    id mock = [OCMockObject mockForClass:[NSString class]];
    STAssertThrows([mock uppercaseString], @"Should have thrown on unexpected method invocation.");
}

@end
