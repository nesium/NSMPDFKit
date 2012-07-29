//
//  NSMAppDelegate.m
//  DemoApp
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMAppDelegate.h"
#import "NSMInfoPanelController.h"
#import "NSMDocument.h"

@implementation NSMAppDelegate
{
	NSMInfoPanelController *_infoPanelCtrl;
}

#pragma mark - NSApplicationDelegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	_infoPanelCtrl = [[NSMInfoPanelController alloc] init];
    [_infoPanelCtrl showWindow:self];
	
	[[NSNotificationCenter defaultCenter] 
    	addObserver:self 
    	selector:@selector(documentSelectionDidChange:) 
        name:NSMDocumentBecameMainNotification 
        object:nil];
}



#pragma mark - IBActions

- (IBAction)showInfo:(id)sender
{
	if (_infoPanelCtrl.window.isVisible)
    	[_infoPanelCtrl close];
    else
		[_infoPanelCtrl showWindow:self];
}



#pragma mark - Notifications

- (void)documentSelectionDidChange:(NSNotification *)note
{
	NSMDocument *doc = (NSMDocument *)note.object;
    _infoPanelCtrl.pdfDocument = doc.pdfDocument;
}
@end