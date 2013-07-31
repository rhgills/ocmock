//
//  OCMockSenTestCaseFailer.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "OCMockSenTestCaseFailureReporter.h"

@implementation OCMockSenTestCaseFailureReporter {
    id testCase;
}

- (id)initWithTestCase:(id)aTestCase
{
    self = [super init];
    if (!self) return nil;

    testCase = [aTestCase retain];

    return self;
}

- (void)dealloc
{
    [testCase release];

    [super dealloc];
}

- (void)failWithException:(NSException *)exception
{
    [testCase failWithException:exception];
}

@end
