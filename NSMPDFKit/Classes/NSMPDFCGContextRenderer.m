//
//  NSMCGContextRenderer.m
//  NSMPDF
//
//  Created by Marc Bauer on 15.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFCGContextRenderer.h"
#import "NSMPDFShading.h"

@implementation NSMPDFCGContextRenderer
{
	CGContextRef _ctx;
}

#pragma mark - Initialization & Deallocation

- (id)initWithContext:(CGContextRef)ctx
{
	if ((self = [super init])) {
    	_ctx = CGContextRetain(ctx);
	}
	return self;
}

- (void)dealloc
{
	CGContextRelease(_ctx);
}



#pragma mark - NSMPDFRenderer methods

- (void)beginRendering{}
- (void)endRendering{}
- (void)beginMarkedContentWithProperties:(NSDictionary *)properties{}
- (void)endMarkedContent{}
- (void)beginTextObject{}
- (void)endTextObject{}
- (void)beginCompatibilitySection{}
- (void)endCompatibilitySection{}

- (void)saveGraphicsState
{
	CGContextSaveGState(_ctx);
}

- (void)restoreGraphicsState
{
	CGContextRestoreGState(_ctx);
}

- (void)concatCTM:(CGAffineTransform)transform
{
	CGContextConcatCTM(_ctx, transform);
}

- (void)addRectangle:(CGRect)aRect
{
	CGContextAddRect(_ctx, aRect);
}

- (void)addCurveToPoint:(CGPoint)p controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2
{
	CGContextAddCurveToPoint(_ctx, cp1.x, cp1.y, cp2.x, cp2.y, p.x, p.y);
}

- (void)addLineToPoint:(CGPoint)p
{
    CGContextAddLineToPoint(_ctx, p.x, p.y);
}

- (void)setStrokeColor:(CGColorRef)color
{
	CGContextSetStrokeColorWithColor(_ctx, color);
}

- (void)setFillColor:(CGColorRef)color
{
	CGContextSetFillColorWithColor(_ctx, color);
}

- (void)setLineWidth:(CGFloat)lineWidth
{
	CGContextSetLineWidth(_ctx, lineWidth);
}

- (void)setLineDashWithPhase:(CGFloat)phase lengths:(CGFloat[])lengths count:(size_t)count
{
	CGContextSetLineDash(_ctx, phase, lengths, count);
}

- (void)addPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextAddPath(_ctx, path);
    CGPathRelease(path);
}

- (void)closePath
{
    if (!CGContextIsPathEmpty(_ctx)) // omit CG warning
		CGContextClosePath(_ctx);
}

- (void)clip
{
	CGContextClip(_ctx);
}

- (CGPoint)pathCurrentPoint
{
	return CGContextGetPathCurrentPoint(_ctx);
}

- (CGPoint)textPosition
{
	return CGContextGetTextPosition(_ctx);
}

- (void)moveToPoint:(CGPoint)p
{
    CGContextMoveToPoint(_ctx, p.x, p.y);
}

- (void)strokePath
{
	CGContextStrokePath(_ctx);
}

- (void)fillPath
{
	CGContextFillPath(_ctx);
}

- (void)fillPathEO
{
	CGContextEOFillPath(_ctx);
}

- (void)drawImage:(CGImageRef)image inRect:(CGRect)aRect
{
	CGContextDrawImage(_ctx, aRect, image);
}

- (void)drawShading:(NSMPDFShading *)shading
{
	[shading drawInContext:_ctx];
}

- (void)setFont:(CGFontRef)font
{
	CGContextSetFont(_ctx, font);
}

- (void)setFontSize:(CGFloat)fontSize
{
	CGContextSetFontSize(_ctx, fontSize);
}

- (void)setTextMatrix:(CGAffineTransform)matrix
{
	CGContextSetTextMatrix(_ctx, matrix);
}

- (void)setTextPosition:(CGPoint)position
{
	CGContextSetTextPosition(_ctx, position.x, position.y);
}

- (void)showGlyphs:(CGGlyph[])glyphs count:(size_t)count
{
	CGContextShowGlyphs(_ctx, glyphs, count);
}
@end