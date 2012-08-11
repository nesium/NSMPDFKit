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
    CGRect _frame;
    CGRect _bounds;
}

@synthesize childNodes = _childNodes, frame = _frame, bounds = _bounds;

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(CGRect)frame bounds:(CGRect)bounds childNodes:(NSArray *)childNodes
{
	if ((self = [super init])) {
    	_frame = frame;
        _bounds = bounds;
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



#pragma mark - NSObject methods

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08lx> frame: %@, bounds: %@",
    	NSStringFromClass([self class]), (long)self, NSStringFromRect(self.frame),
        NSStringFromRect(self.bounds)];
}
@end