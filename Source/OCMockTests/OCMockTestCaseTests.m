//
//  OCMockTestCaseTests.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "OCMockTestCase.h"

@interface OCMockTestCaseTests : OCMockTestCase

@end



@implementation OCMockTestCaseTests

// should fail with: 'unexpected method invoked: lowercaseString'
- (void)testReportsFailure;
{
    id mock = [self mockForClass:[NSString class]];
    [mock lowercaseString];
}

- (NSString *)file
{
    return [NSString stringWithUTF8String:__FILE__];
}

@end
