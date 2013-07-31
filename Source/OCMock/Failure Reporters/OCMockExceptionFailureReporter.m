//
//  OCMockRaiseExceptionFailer.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "OCMockExceptionFailureReporter.h"

@implementation OCMockExceptionFailureReporter {

}


- (void)failWithException:(NSException *)exception
{
    [exception raise];
}

@end
