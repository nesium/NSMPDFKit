//
//  NSMPDFClippingGroupNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 11.08.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFClippingGroupNode.h"

@implementation NSMPDFClippingGroupNode

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(CGRect)frame bounds:(CGRect)bounds path:(CGPathRef)aPath
	childNodes:(NSArray *)childNodes
{
	if ((self = [super initWithFrame:frame bounds:bounds childNodes:childNodes])) {
    	_clippingPath = CGPathCreateCopy(aPath);
	}
	return self;
}

- (void)dealloc
{
	CGPathRelease(_clippingPath);
}
@end