//
//  NSMPDFTreeNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFTreeNode.h"
#if !(TARGET_OS_IPHONE)
#import <NSMPDFKit/NSMUIGeometry.h>
#endif

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

- (void)drawInContext:(CGContextRef)ctx
{
	for (NSMPDFTreeNode *node in self.childNodes) {
    	[node drawInContext:ctx];
    }
}



#pragma mark - NSObject methods

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08lx> frame: %@, bounds: %@",
    	NSStringFromClass([self class]), (long)self, NSStringFromCGRect(self.frame),
        NSStringFromCGRect(self.bounds)];
}
@end