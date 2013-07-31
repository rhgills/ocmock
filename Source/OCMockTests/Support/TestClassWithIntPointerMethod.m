//
//  TestClassWithIntPointerMethod.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "TestClassWithIntPointerMethod.h"

@implementation TestClassWithIntPointerMethod

- (void)returnValueInPointer:(int *)ptr
{
    *ptr = 555;
}

@end