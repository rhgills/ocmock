//---------------------------------------------------------------------------------------
//  $Id$
//  Copyright (c) 2005-2008 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <OCMock/OCMockObject.h>

@interface OCProtocolMockObject : OCMockObject 
{
	Protocol	*mockedProtocol;
}

- (id)initWithProtocol:(Protocol *)aProtocol;
- (id)initWithProtocol:(Protocol *)aProtocol isNice:(BOOL)shouldBeNice;
- (id)initWithProtocol:(Protocol *)aProtocol isNice:(BOOL)shouldBeNice testCase:(id)aTestCase;

@end

