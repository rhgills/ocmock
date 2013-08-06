//
//  OCMockTestCase.h
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

// This little block can probably go away with the next version of developer tools.
// Shamelessly borrowed from Florian Kugler ( https://github.com/dkduck ) as seen in objc.io ( http://objc.io ) issue #1.
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


- (id)mockForClass:(Class)aClass;
- (id)mockForProtocol:(Protocol *)aProtocol;
- (id)niceMockForClass:(Class)aClass;
- (id)niceMockForProtocol:(Protocol *)aProtocol;


- (id)partialMockForObject:(NSObject *)anObject;
- (id)observerMock;

@end
