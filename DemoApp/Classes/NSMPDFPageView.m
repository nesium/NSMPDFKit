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

- (BOOL)isFlipped
{
	return YES;
}

- (void)drawRect:(NSRect)aRect
{
	CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    transform = CGAffineTransformTranslate(transform, 0.0f, -NSHeight(self.frame));
    CGContextConcatCTM(ctx, transform);
	[page renderWithRenderer:[[NSMPDFCGContextRenderer alloc] initWithContext:ctx]];
}
@end