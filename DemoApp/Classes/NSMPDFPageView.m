//
//  NSMPDFPageView.m
//  PDF
//
//  Created by Marc Bauer on 25.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFPageView.h"

@implementation NSMPDFPageView

@synthesize page;

#pragma mark - Public methods

- (void)setPage:(NSMPDFPage *)aPage
{
    page = aPage;
    [self setNeedsDisplay:YES];
}



#pragma mark - UIView methods

- (void)drawRect:(NSRect)aRect
{
	CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
	[page renderWithRenderer:[[NSMPDFCGContextRenderer alloc] initWithContext:ctx]];
}
@end