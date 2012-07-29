//
//  NSMPDFMutableTreeNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFMutableTreeNode.h"

@implementation NSMPDFMutableTreeNode
{
	NSMutableArray *_childNodes;
}

@synthesize childNodes = _childNodes;

#pragma mark - Initialization & Deallocation

- (id)init
{
	if ((self = [super init])) {
    	_childNodes = [NSMutableArray new];
	}
	return self;
}

- (id)initWithChildNodes:(NSArray *)childNodes
{
	if ((self = [super init])) {
    	_childNodes = [childNodes mutableCopy];
    }
    return self;
}



#pragma mark - Public methods

- (NSInteger)numberOfChildNodes
{
	return _childNodes.count;
}

- (BOOL)isLeaf
{
	return _childNodes.count == 0;
}

- (void)addChildNode:(id)node
{
	[_childNodes addObject:node];
}



#pragma mark - NSCopying Protocol methods

- (id)copyWithZone:(NSZone *)zone
{
	NSMutableArray *copies = [[NSMutableArray alloc] initWithCapacity:_childNodes.count];
    for (NSMPDFMutableTreeNode *node in _childNodes) {
    	[copies addObject:[node copy]];
    }
	return [[NSMPDFTreeNode alloc] initWithChildNodes:copies];
}
@end