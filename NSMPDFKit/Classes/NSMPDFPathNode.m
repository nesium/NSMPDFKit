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

- (id)initWithCGPath:(CGPathRef)path
{
	if ((self = [super init])) {
    	_path = CGPathCreateCopy(path);
	}
	return self;
}

- (void)dealloc
{
	CGPathRelease(_path);
}
@end