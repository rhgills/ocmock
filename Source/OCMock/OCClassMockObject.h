//---------------------------------------------------------------------------------------
//  $Id$
//  Copyright (c) 2005-2013 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <OCMock/OCMockObject.h>

@interface OCClassMockObject : OCMockObject 
{
	Class               mockedClass;
	NSMutableDictionary *replacedClassMethods;
}

- (id)initWithClass:(Class)aClass;
- (id)initWithClass:(Class)aClass isNice:(BOOL)isNice;
- (id)initWithClass:(Class)aClass isNice:(BOOL)isNice testCase:(id)aTestCase;

- (Class)mockedClass;

- (void)setupClassForClassMethodMocking;
- (void)setupForwarderForClassMethodSelector:(SEL)selector;

@end
