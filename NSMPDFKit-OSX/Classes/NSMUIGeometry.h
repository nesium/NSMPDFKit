//
//  UIGeometry.h
//
//  Created by Marc Bauer on 07.08.11.
//  Copyright 2011 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *NSStringFromCGPoint(CGPoint point);
NSString *NSStringFromCGSize(CGSize size);
NSString *NSStringFromCGRect(CGRect rect);
NSString *NSStringFromCGAffineTransform(CGAffineTransform transform);

CGPoint CGPointFromString(NSString *string);
CGSize CGSizeFromString(NSString *string);
CGRect CGRectFromString(NSString *string);
CGAffineTransform CGAffineTransformFromString(NSString *string);




@interface NSValue (NSValueUIGeometryExtensions)
+ (NSValue *)valueWithCGPoint:(CGPoint)point;
+ (NSValue *)valueWithCGSize:(CGSize)size;
+ (NSValue *)valueWithCGRect:(CGRect)rect;
+ (NSValue *)valueWithCGAffineTransform:(CGAffineTransform)transform;

- (CGPoint)CGPointValue;
- (CGSize)CGSizeValue;
- (CGRect)CGRectValue;
- (CGAffineTransform)CGAffineTransformValue;
@end