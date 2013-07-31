//
//  OCMockFakeFailureReporter.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "OCMockFakeFailureReporter.h"



@implementation OCMockFakeFailureReporter

- (void)failWithException:(NSException *)exception
{
    _failedWithException = YES;
}

- (void)clearReportedFailures
{
    _failedWithException = NO;
}

@end
