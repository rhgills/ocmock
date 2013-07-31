//
//  OCMockFakeFailureReporter.h
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMockTestCaseFailer.h"



@interface OCMockFakeFailureReporter : NSObject <OCMockTestCaseFailer>

- (void)clearReportedFailures;

@property (readonly) BOOL failedWithException;


@end
