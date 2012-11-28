//
//  NSMPDFPageView.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 28.11.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFPageView.h"
#import "NSMPDFPage.h"
#import "NSMPDFCGContextRenderer.h"

@implementation NSMPDFPageView
{
	UIImageView *_imageView;
}

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
    	self.backgroundColor = [UIColor yellowColor];
    	_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        	UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
	}
	return self;
}



#pragma mark - Public methods

- (void)setPage:(NSMPDFPage *)page
{
	_page = page;
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0f);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform,
    	CGRectGetWidth(self.bounds) / CGRectGetWidth(_page.mediaBox),
        -(CGRectGetHeight(self.bounds) / CGRectGetHeight(_page.mediaBox)));
    transform = CGAffineTransformTranslate(transform, 0.0f, -CGRectGetHeight(_page.mediaBox));
    CGContextConcatCTM(ctx, transform);
    
	[_page renderWithRenderer:[[NSMPDFCGContextRenderer alloc] initWithContext:ctx]];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _imageView.image = image;
}
@end