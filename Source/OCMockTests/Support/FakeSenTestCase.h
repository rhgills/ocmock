//
//  FakeSenTestCase.h
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

@interface FakeSenTestCase : SenTestCase

- (void)failWithException:(NSException *)exception;

@property (assign) BOOL failed;
@property (retain) NSException *failedException;

@end
