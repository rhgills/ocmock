//
//  OCMockExceptionFailureReporterTests.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OCMockExceptionFailureReporter.h"
#import "OCMockObject.h"

@interface OCMockExceptionFailureReporterTests : SenTestCase

@end



@implementation OCMockExceptionFailureReporterTests

- (void)testRaisesException;
{
    OCMockExceptionFailureReporter *reporter = [[OCMockExceptionFailureReporter alloc] init];
    
    NSException *e = [NSException exceptionWithName:NSInternalInconsistencyException reason:@"" userInfo:nil];
    STAssertThrows([reporter failWithException:e], @"Should have raised exception.");
}

@end
