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
	((NSMPDFMutableTreeNode *)node).parentNode = self;
	[_childNodes addObject:node];
}

- (void)removeChildNode:(id)node
{
	((NSMPDFMutableTreeNode *)node).parentNode = nil;
	[_childNodes removeObject:node];
}

- (void)removeFromParentNode
{
	[_parentNode removeChildNode:self];
}

- (void)removeAllChildNodes
{
	[_childNodes removeAllObjects];
}

- (void)finalize
{
    CGRect frame = CGRectNull;
    NSArray *childNodes = [self.childNodes copy];
    for (NSMPDFMutableTreeNode *node in childNodes) {
    	[node finalize];
        
        if (CGRectIsEmpty(node.bounds)) {
        	[self removeChildNode:node];
        	continue;
        }
        
        if (CGRectIsNull(frame)) {
        	frame = node.frame;
            continue;
        }
        
    	frame.origin.x = MIN(CGRectGetMinX(frame), CGRectGetMinX(node.frame));
    	frame.origin.y = MIN(CGRectGetMinY(frame), CGRectGetMinY(node.frame));
        frame.size.width = MAX(CGRectGetWidth(frame), CGRectGetMaxX(node.frame));
        frame.size.height = MAX(CGRectGetHeight(frame), CGRectGetMaxY(node.frame));
    }
    
//    NDCLog(@"1 %@", NSStringFromCGRect(frame));
//    frame.size.width -= CGRectGetMinX(frame);
//    frame.size.height -= CGRectGetMinY(frame);
//    NDCLog(@"2 %@", NSStringFromCGRect(frame));
    
    for (NSMPDFMutableTreeNode *node in self.childNodes) {
		node.frame = (CGRect){CGRectGetMinX(node.frame) - CGRectGetMinX(frame),
        	CGRectGetMinY(node.frame) - CGRectGetMinY(frame),
            node.frame.size};
    }
    
    self.frame = frame;
    self.bounds = (CGRect){0.0f, 0.0f, frame.size};
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