//
//  OCMockSenTestCaseFailureReporterTests.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OCMockSenTestCaseFailureReporter.h"
#import "FakeSenTestCase.h"

@interface OCMockSenTestCaseFailureReporterTests : SenTestCase

@end









@implementation OCMockSenTestCaseFailureReporterTests

- (void)testReportsFailureToTestCase;
{
    FakeSenTestCase *testCase = [[FakeSenTestCase alloc] init];
    OCMockSenTestCaseFailureReporter *reporter = [[OCMockSenTestCaseFailureReporter alloc] initWithTestCase:testCase];

    STAssertFalse([testCase failed], @"Should not have been marked as failed.");

    NSException *e = [NSException exceptionWithName:NSInternalInconsistencyException reason:@"" userInfo:nil];
    [reporter failWithException:e];

    STAssertEqualObjects([testCase failedException], e, @"Should have passed the same exception to the sen test case.");
}

@end
