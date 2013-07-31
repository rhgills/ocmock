//
//  FakeSenTestCase.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "FakeSenTestCase.h"

@implementation FakeSenTestCase

- (void)failWithException:(NSException *)exception;
{
    [self setFailed:YES];
    [self setFailedException:exception];
}

@end
