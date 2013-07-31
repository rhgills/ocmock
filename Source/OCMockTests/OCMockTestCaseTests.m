//
//  OCMockTestCaseTests.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "OCMockTestCaseTests.h"

@implementation OCMockTestCaseTests

//- (void)testReportsFailure;
//{
//    id mock = [self mockForClass:[NSString class] file:[self file]];
//    [mock lowercaseString];
//}

- (NSString *)file
{
    return [NSString stringWithUTF8String:__FILE__];
}

@end
