//
//  NotificationRecorderForTesting.m
//  OCMock
//
//  Created by Robert Gilliam on 7/31/13.
//  Copyright (c) 2013 Mulle Kybernetik. All rights reserved.
//

#import "NotificationRecorderForTesting.h"

@implementation NotificationRecorderForTesting

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[notification release];
	[super dealloc];
}

- (void)receiveNotification:(NSNotification *)aNotification
{
	notification = [aNotification retain];
}

@end
