//
//  OCMockTestCase.h
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

// This little block can probably go away with the next version of developer tools:
#ifndef NS_REQUIRES_SUPER
# if __has_attribute(objc_requires_super)
#  define NS_REQUIRES_SUPER __attribute((objc_requires_super))
# else
#  define NS_REQUIRES_SUPER
# endif
#endif

@interface OCMockTestCase : SenTestCase

- (void)setUp NS_REQUIRES_SUPER;
- (void)tearDown NS_REQUIRES_SUPER;


- (id)mockForClass:(Class)aClass file:(NSString *)aFile;
- (id)mockForProtocol:(Protocol *)aProtocol file:(NSString *)aFile;
- (id)niceMockForClass:(Class)aClass file:(NSString *)aFile;
- (id)niceMockForProtocol:(Protocol *)aProtocol file:(NSString *)aFile;


- (id)partialMockForObject:(NSObject *)anObject;
- (id)observerMock;

@end
