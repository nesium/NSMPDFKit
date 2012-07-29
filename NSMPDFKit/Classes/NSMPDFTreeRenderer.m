//
//  NSMPDFTreeRenderer.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFTreeRenderer.h"
#import "NSMPDFMutableTreeNode.h"
#import "NSMPDFMutableTaggedContentNode.h"
#import "NSMPDFMutablePathNode.h"

@implementation NSMPDFTreeRenderer
{
	NSMPDFMutableTreeNode *_mutableNode;
    NSMPDFMutableTreeNode *_currentContainerNode;
    NSMPDFMutableTreeNode *_currentNode;
    NSMPDFTreeNode *_rootNode;
}

@synthesize rootNode = _rootNode;

- (void)beginRendering
{
	_mutableNode = [[NSMPDFMutableTreeNode alloc] init];
    _currentContainerNode = _mutableNode;
}

- (void)endRendering
{
	_rootNode = [_mutableNode copy];
    _mutableNode = nil;
}

- (void)beginMarkedContentWithProperties:(NSDictionary *)properties
{
	NSMPDFMutableTaggedContentNode *node = [[NSMPDFMutableTaggedContentNode alloc] init];
    node.properties = properties;
    [_mutableNode addChildNode:node];
    _currentContainerNode = node;
}

- (void)endMarkedContent
{
	_currentContainerNode = _mutableNode;
}

- (void)beginTextObject
{
}

- (void)endTextObject
{
}

- (void)beginCompatibilitySection
{
}

- (void)endCompatibilitySection
{
}

- (void)saveGraphicsState
{
}

- (void)restoreGraphicsState
{
}

- (void)concatCTM:(CGAffineTransform)transform
{
}

- (void)setStrokeColor:(CGColorRef)color
{
}

- (void)setFillColor:(CGColorRef)color
{
}

- (void)setLineWidth:(CGFloat)lineWidth
{
}

- (void)setLineDashWithPhase:(CGFloat)phase lengths:(CGFloat[])lengths count:(size_t)count
{
}

- (void)addPath
{
	NSMPDFMutablePathNode *node = [[NSMPDFMutablePathNode alloc] init];
    node.path = CGPathCreateMutable();
    [_currentContainerNode addChildNode:node];
    _currentNode = node;
}

- (void)closePath
{
	_currentNode = nil;
}

- (void)clip
{
}

- (CGPoint)pathCurrentPoint
{
	CGPathRef path = ((NSMPDFMutablePathNode *)_currentNode).path;
    return CGPathGetCurrentPoint(path);
}

- (CGPoint)textPosition
{
	return CGPointZero;
}

- (void)moveToPoint:(CGPoint)p
{
	CGPathMoveToPoint(((NSMPDFMutablePathNode *)_currentNode).path, NULL, p.x, p.y);
}

- (void)addRectangle:(CGRect)aRect
{
	CGPathAddRect(((NSMPDFMutablePathNode *)_currentNode).path, NULL, aRect);
}

- (void)addCurveToPoint:(CGPoint)p controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2
{
	CGPathAddCurveToPoint(((NSMPDFMutablePathNode *)_currentNode).path, NULL,
    	cp1.x, cp1.y, cp2.x, cp2.y, p.x, p.y);
}

- (void)addLineToPoint:(CGPoint)p
{
	CGPathAddLineToPoint(((NSMPDFMutablePathNode *)_currentNode).path, NULL, p.x, p.y);
}

- (void)strokePath
{
}

- (void)fillPath
{
}

- (void)fillPathEO
{
}

- (void)drawImage:(CGImageRef)image inRect:(CGRect)aRect
{
}

- (void)drawShading:(NSMPDFShading *)shading
{
}

- (void)setFont:(CGFontRef)font
{
}

- (void)setFontSize:(CGFloat)fontSize
{
}

- (void)setTextMatrix:(CGAffineTransform)matrix
{
}

- (void)setTextPosition:(CGPoint)position
{
}

- (void)showGlyphs:(CGGlyph[])glyphs count:(size_t)count
{
}
@end