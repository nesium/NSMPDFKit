//
//  NSMDocument.m
//  PDF
//
//  Created by Marc Bauer on 26.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMDocument.h"
#import "NSMPDFPageView.h"

NSString *const NSMDocumentBecameMainNotification = @"NSMDocumentBecameMainNotification";

@interface NSMDocument ()
- (void)applyPage;
@end


@implementation NSMDocument
{
	IBOutlet NSMPDFPageView *_pdfPageView;
    BOOL _clippingEnabled;
}

@synthesize pdfDocument;

#pragma mark - NSDocument methods

- (NSString *)windowNibName
{
	return NSStringFromClass([self class]);
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    _clippingEnabled = YES;
    
	if (pdfDocument.numPages < 1)
    	return;
    
	[self applyPage];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	pdfDocument = [[NSMPDFDocument alloc] initWithData:data];
    return pdfDocument != nil;
}

- (void)saveDocument:(id)sender{}



#pragma mark - NSWindowDelegate methods

- (void)windowDidBecomeMain:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] 
    	postNotificationName:NSMDocumentBecameMainNotification object:self];
}



#pragma mark - Private methods

- (void)applyPage
{
    NSMPDFPage *page = [pdfDocument.pages objectAtIndex:0];
    _pdfPageView.frame = page.mediaBox;
    _pdfPageView.page = page;
}
@end