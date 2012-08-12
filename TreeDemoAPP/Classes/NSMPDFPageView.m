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
    CAShapeLayer *_highlightLayer;
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
	if (nodes.count < 1) {
    	_highlightLayer.hidden = YES;
    }
    
    if (!_highlightLayer) {
    	_highlightLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_highlightLayer];
    }
    
	NSArray *(^__block layersForNodes)(NSMPDFTreeNodeLayer *) =
    	^NSArray *(NSMPDFTreeNodeLayer *layer) {
            NSMutableArray *result = [NSMutableArray array];
            if ([nodes containsObject:layer.node])
                [result addObject:layer];
            for (CALayer *sublayer in layer.sublayers) {
                if ([sublayer isKindOfClass:[NSMPDFTreeNodeLayer class]])
                    [result addObjectsFromArray:layersForNodes((NSMPDFTreeNodeLayer *)sublayer)];
            }
            return result;
	    };
    
	NSArray *highlightedLayers = layersForNodes(_rootLayer);
    CGRect frame = CGRectNull;
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (NSMPDFTreeNodeLayer *layer in highlightedLayers) {
    	if ([layer.node isKindOfClass:[NSMPDFPathNode class]]) {
        	CGPathAddPath(path, NULL, ((NSMPDFPathNode *)layer.node).path);
        } else if ([layer.node isKindOfClass:[NSMPDFClippingGroupNode class]]) {
        	CGPathAddPath(path, NULL, ((NSMPDFClippingGroupNode *)layer.node).clippingPath);
        } else {
        	CGPathAddRect(path, NULL, layer.bounds);
        }
        
    	CGRect layerFrame = [self.layer convertRect:layer.frame fromLayer:layer.superlayer];
		if (CGRectIsNull(frame)) {
        	frame = layerFrame;
            continue;
        }
        frame.origin.x = MIN(CGRectGetMinX(frame), CGRectGetMinX(layerFrame));
        frame.origin.y = MIN(CGRectGetMinY(frame), CGRectGetMinY(layerFrame));
    	frame.size.width = MAX(CGRectGetWidth(frame), CGRectGetMaxX(layerFrame));
    	frame.size.height = MAX(CGRectGetHeight(frame), CGRectGetMaxY(layerFrame));
    }
    
    _highlightLayer.hidden = NO;
    _highlightLayer.frame = frame;
    _highlightLayer.path = path;
    _highlightLayer.fillColor = nil;
    _highlightLayer.strokeColor = [NSColor redColor].CGColor;
    _highlightLayer.lineWidth = 1.0f;
    
    CGPathRelease(path);
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
    	CGContextSetFillColorWithColor(ctx, [NSColor blueColor].CGColor);
		[_node drawInContext:ctx];
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