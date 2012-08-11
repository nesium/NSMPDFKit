//
//  NSMOutlinePanelController.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMOutlinePanelController.h"

NSString *const NSMOutlineSelectionDidChangeNotification =
	@"NSMOutlineSelectionDidChangeNotification";
NSString *const NSMOutlineSelectedObjectsKey = @"NSMOutlineSelectedObjectsKey";

@implementation NSMOutlinePanelController
{
	IBOutlet NSTreeController *_treeController;
}

#pragma mark - Initialization & Deallocation

- (id)init
{
	if ((self = [super initWithWindowNibName:@"OutlinePanel"])) {
	}
	return self;
}



#pragma mark - NSWindowController methods

- (void)windowDidLoad
{
	[_treeController addObserver:self forKeyPath:@"selectedObjects" options:0 context:NULL];
}



#pragma mark - KVO Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change 
	context:(void *)context
{
	[[NSNotificationCenter defaultCenter]
    	postNotificationName:NSMOutlineSelectionDidChangeNotification
        object:self
        userInfo:@{NSMOutlineSelectedObjectsKey : _treeController.selectedObjects}];
}
@end