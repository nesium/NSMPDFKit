//
//  NSMPDFRenderer.h
//  NSMPDF
//
//  Created by Marc Bauer on 15.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class NSMPDFShading;

@protocol NSMPDFRenderer <NSObject>

- (void)beginRendering;
- (void)endRendering;

- (void)beginMarkedContentWithProperties:(NSDictionary *)properties;
- (void)endMarkedContent;
- (void)beginTextObject;
- (void)endTextObject;
- (void)beginCompatibilitySection;
- (void)endCompatibilitySection;

- (void)saveGraphicsState;
- (void)restoreGraphicsState;
- (void)concatCTM:(CGAffineTransform)transform;

- (void)setStrokeColor:(CGColorRef)color;
- (void)setFillColor:(CGColorRef)color;
- (void)setLineWidth:(CGFloat)lineWidth;
- (void)setLineDashWithPhase:(CGFloat)phase lengths:(CGFloat[])lengths count:(size_t)count;

- (void)addPath;
- (void)closePath;
- (void)clip;

- (CGPoint)pathCurrentPoint;
- (CGPoint)textPosition;

- (void)moveToPoint:(CGPoint)p;
- (void)addRectangle:(CGRect)aRect;
- (void)addCurveToPoint:(CGPoint)p controlPoint1:(CGPoint)cp1 controlPoint2:(CGPoint)cp2;
- (void)addLineToPoint:(CGPoint)p;

- (void)strokePath;
- (void)fillPath;
- (void)fillPathEO;

- (void)drawImage:(CGImageRef)image inRect:(CGRect)aRect;
- (void)drawShading:(NSMPDFShading *)shading;

- (void)setFont:(CGFontRef)font;
- (void)setFontSize:(CGFloat)fontSize;
- (void)setTextMatrix:(CGAffineTransform)matrix;
- (void)setTextPosition:(CGPoint)position;
- (void)showGlyphs:(CGGlyph[])glyphs count:(size_t)count;
@end