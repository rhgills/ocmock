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

- (id)mockForClass:(Class)aClass
{
    return [self autoVerifyMock:[OCMockObject mockForClass:aClass testCase:self file:[self file]]];
}

- (id)partialMockForObject:(id)object
{
    return [self autoVerifyMock:[OCMockObject partialMockForObject:object]];
}

- (id)mockForProtocol:(Protocol *)protocol
{
    return [self autoVerifyMock:[OCMockObject mockForProtocol:protocol testCase:self file:[self file]]];
}

- (id)niceMockForClass:(Class)aClass
{
    return [self autoVerifyMock:[OCMockObject niceMockForClass:aClass testCase:self file:[self file]]];
}

- (id)niceMockForProtocol:(Protocol *)protocol
{
    return [self autoVerifyMock:[OCMockObject niceMockForProtocol:protocol testCase:self file:[self file]]];
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

- (NSString *)file
{
    // abstract. implement in a concrete test subclass.
    return [self defaultFileName];
}

- (NSString *)defaultFileName;
{
    // Grouping by the test case name, even if it doesn't link to the correct file, is better than nothing.
    return [NSString stringWithFormat:@"%@", [self class]];
}

@end
