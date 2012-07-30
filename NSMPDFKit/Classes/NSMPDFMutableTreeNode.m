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
    CGRect _frame;
    CGRect _bounds;
}

@synthesize childNodes = _childNodes, frame = _frame, bounds = _bounds;

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

- (void)finalize
{
	CGRect frame = self.frame;
    CGRect bounds = CGRectZero;
    for (NSMPDFMutableTreeNode *node in self.childNodes) {
    	[node finalize];
    	bounds.origin.x = MIN(CGRectGetMinX(bounds), CGRectGetMinX(node.bounds));
    	bounds.origin.y = MIN(CGRectGetMinY(bounds), CGRectGetMinY(node.bounds));
        bounds.size.width = MAX(CGRectGetWidth(bounds), CGRectGetWidth(node.bounds));
        bounds.size.height = MAX(CGRectGetHeight(bounds), CGRectGetHeight(node.bounds));
    }
    frame.size = bounds.size;
    self.frame = frame;
}



#pragma mark - NSCopying Protocol methods

- (id)copyWithZone:(NSZone *)zone
{
	NSMutableArray *copies = [[NSMutableArray alloc] initWithCapacity:_childNodes.count];
    for (NSMPDFMutableTreeNode *node in _childNodes) {
    	[copies addObject:[node copy]];
    }
	return [[NSMPDFTreeNode alloc] initWithFrame:self.frame bounds:self.bounds childNodes:copies];
}
@end