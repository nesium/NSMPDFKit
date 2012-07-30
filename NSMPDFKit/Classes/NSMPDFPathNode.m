//
//  NSMPDFPathNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFPathNode.h"

@implementation NSMPDFPathNode
{
	CGPathRef _path;
}

@synthesize path = _path;

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(CGRect)frame bounds:(CGRect)bounds path:(CGPathRef)path
{
	if ((self = [super initWithFrame:frame bounds:bounds childNodes:nil])) {
    	_path = CGPathCreateCopy(path);
	}
	return self;
}

- (void)dealloc
{
	CGPathRelease(_path);
}
@end