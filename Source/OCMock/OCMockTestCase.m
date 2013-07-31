//
//  OCMockTestCase.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "OCMockTestCase.h"
#import "OCMockObject.h"


@interface OCMockTestCase ()

@property (nonatomic, strong) NSMutableArray *mocksToVerify;

@end



@implementation OCMockTestCase

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [self verify];
    
    [super tearDown];
}

- (void)verify
{
    for (id mock in self.mocksToVerify) {
        [mock verify];
    }
    self.mocksToVerify = nil;
}

- (id)mockForClass:(Class)aClass file:(NSString *)aFile
{
    return [self autoVerifyMock:[OCMockObject mockForClass:aClass testCase:self file:aFile]];
}

- (id)partialMockForObject:(id)object
{
    return [self autoVerifyMock:[OCMockObject partialMockForObject:object]];
}

- (id)mockForProtocol:(Protocol *)protocol file:(NSString *)aFile
{
    return [self autoVerifyMock:[OCMockObject mockForProtocol:protocol testCase:self file:aFile]];
}

- (id)niceMockForClass:(Class)aClass file:(NSString *)aFile
{
    return [self autoVerifyMock:[OCMockObject niceMockForClass:aClass testCase:self file:aFile]];
}

- (id)niceMockForProtocol:(Protocol *)protocol file:(NSString *)aFile
{
    return [self autoVerifyMock:[OCMockObject niceMockForProtocol:protocol testCase:self file:aFile]];
}

- (id)observerMock
{
    return [self autoVerifyMock:[OCMockObject observerMock]];
}

- (id)autoVerifyMock:(OCMockObject *)mock
{
    [self verifyDuringTearDown:mock];
    return mock;
}

- (void)verifyDuringTearDown:(id)mock
{
    if (self.mocksToVerify == nil) {
        self.mocksToVerify = [NSMutableArray array];
    }
    [self.mocksToVerify addObject:mock];
}

@end
