//
//  NSMAppDelegate.m
//  DemoApp
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMAppDelegate.h"
#import "NSMInfoPanelController.h"
#import "NSMOutlinePanelController.h"
#import "NSMDocument.h"

@implementation NSMAppDelegate
{
	NSMInfoPanelController *_infoPanelCtrl;
    NSMOutlinePanelController *_outlinePanelCtrl;
    NSMDocument *_selectedDocument;
}

#pragma mark - NSApplicationDelegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	_infoPanelCtrl = [[NSMInfoPanelController alloc] init];
    [_infoPanelCtrl showWindow:self];
    
    _outlinePanelCtrl = [[NSMOutlinePanelController alloc] init];
    [_outlinePanelCtrl showWindow:self];
	
	[[NSNotificationCenter defaultCenter] 
    	addObserver:self 
    	selector:@selector(documentSelectionDidChange:) 
        name:NSMDocumentBecameMainNotification 
        object:nil];
    
    [[NSNotificationCenter defaultCenter]
    	addObserver:self
        selector:@selector(outlineSelectionDidChange:)
        name:NSMOutlineSelectionDidChangeNotification
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
	_selectedDocument = (NSMDocument *)note.object;
    _infoPanelCtrl.pdfDocument = _selectedDocument.pdfDocument;
    _outlinePanelCtrl.rootNode = _selectedDocument.rootNode;
}

- (void)outlineSelectionDidChange:(NSNotification *)note
{
	NSArray *objects = note.userInfo[NSMOutlineSelectedObjectsKey];
	[_selectedDocument highlightNodes:objects];
}
@end