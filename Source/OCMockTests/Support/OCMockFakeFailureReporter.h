//
//  OCMockFakeFailureReporter.h
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMockFailureReporter.h"



@interface OCMockFakeFailureReporter : NSObject <OCMockFailureReporter>

- (void)clearReportedFailures;

@property (readonly) BOOL failedWithException;


@end
