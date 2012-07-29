//
//  NSMPDFTreeNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFTreeNode.h"

@implementation NSMPDFTreeNode
{
	NSArray *_childNodes;
}

@synthesize childNodes = _childNodes;

#pragma mark - Initialization & Deallocation

- (id)initWithChildNodes:(NSArray *)childNodes
{
	if ((self = [super init])) {
    	_childNodes = [childNodes copy];
	}
	return self;
}



#pragma mark - Public methods

- (NSString *)name
{
	return NSStringFromClass([self class]);
}

- (NSInteger)numberOfChildNodes
{
	return _childNodes.count;
}

- (BOOL)isLeaf
{
	return _childNodes.count == 0;
}
@end