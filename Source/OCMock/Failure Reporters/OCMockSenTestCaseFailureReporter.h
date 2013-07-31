//
//  OCMockSenTestCaseFailer.h
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCMockFailureReporter.h"

@interface OCMockSenTestCaseFailureReporter : NSObject <OCMockFailureReporter>

- (id)initWithTestCase:(id)testCase;

@end
