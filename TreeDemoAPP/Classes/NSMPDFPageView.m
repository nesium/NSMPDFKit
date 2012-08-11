//
//  NSMPDFPageView.m
//  PDF
//
//  Created by Marc Bauer on 25.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFPageView.h"

@interface NSMPDFTreeNodeLayer : CALayer
+ (id)layerWithNode:(NSMPDFTreeNode *)node;
@property (nonatomic, readonly) NSMPDFTreeNode *node;
@end


@implementation NSMPDFPageView
{
	NSMPDFTreeNodeLayer *_rootLayer;
    NSArray *_highlightedLayers;
}

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect])) {
    	self.layer = [CALayer layer];
        self.wantsLayer = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
    	self.layer = [CALayer layer];
        self.wantsLayer = YES;
	}
	return self;
}



#pragma mark - Public methods

- (void)setRootNode:(NSMPDFTreeNode *)rootNode
{
	_rootNode = rootNode;
    [_rootLayer removeFromSuperlayer];
    _rootLayer = [NSMPDFTreeNodeLayer layerWithNode:_rootNode];
    [self.layer addSublayer:_rootLayer];
}

- (void)highlightNodes:(NSSet *)nodes
{
	for (CALayer *layer in _highlightedLayers) {
    	layer.borderWidth = 0.0f;
        layer.borderColor = nil;
    }
    _highlightedLayers = nil;
    
	NSArray *(^__block layersForNodes)(NSMPDFTreeNodeLayer *) = ^NSArray *(NSMPDFTreeNodeLayer *layer) {
    	NSMutableArray *result = [NSMutableArray array];
        if ([nodes containsObject:layer.node])
        	[result addObject:layer];
        for (CALayer *sublayer in layer.sublayers) {
        	if ([sublayer isKindOfClass:[NSMPDFTreeNodeLayer class]])
            	[result addObjectsFromArray:layersForNodes((NSMPDFTreeNodeLayer *)sublayer)];
        }
        return result;
    };
    
	_highlightedLayers = layersForNodes(_rootLayer);
    for (CALayer *layer in _highlightedLayers) {
    	layer.borderWidth = 2.0f;
		layer.borderColor = [NSColor redColor].CGColor;
    }
}
@end




@implementation NSMPDFTreeNodeLayer
{
	NSMPDFTreeNode *_node;
}

#pragma mark - Initialization & Deallocation

+ (id)layerWithNode:(NSMPDFTreeNode *)node
{
	return [[NSMPDFTreeNodeLayer alloc] initWithNode:node];
}

- (id)initWithNode:(NSMPDFTreeNode *)node
{
	if ((self = [super init])) {
    	_node = node;
        self.frame = node.frame;
        [self createSublayers];
        [self setNeedsDisplay];
    }
    return self;
}



#pragma mark - CALayer methods

- (void)drawInContext:(CGContextRef)ctx
{
	if ([_node isKindOfClass:[NSMPDFPathNode class]]) {
    	NSMPDFPathNode *pathNode = (NSMPDFPathNode *)_node;
		CGContextSetFillColorWithColor(ctx, [NSColor blackColor].CGColor);
        CGContextAddPath(ctx, pathNode.path);
        CGContextFillPath(ctx);
    }
}



#pragma mark - Private methods

- (void)createSublayers
{
	for (NSMPDFTreeNode *node in _node.childNodes) {
    	[self addSublayer:[NSMPDFTreeNodeLayer layerWithNode:node]];
    }
}
@end