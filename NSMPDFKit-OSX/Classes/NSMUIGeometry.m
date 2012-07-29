//
//  UIGeometry.m
//
//  Created by Marc Bauer on 07.08.11.
//  Copyright 2011 nesiumdotcom. All rights reserved.
//

#import "NSMUIGeometry.h"

NSString *NSStringFromCGPoint(CGPoint point){
	return NSStringFromPoint(NSPointFromCGPoint(point));
}

NSString *NSStringFromCGSize(CGSize size){
	return NSStringFromSize(NSSizeFromCGSize(size));
}

NSString *NSStringFromCGRect(CGRect rect){
	return NSStringFromRect(NSRectFromCGRect(rect));
}

NSString *NSStringFromCGAffineTransform(CGAffineTransform transform){
	return [NSString stringWithFormat:@"[%f, %f, %f, %f, %f, %f]", transform.a, transform.b, 
		transform.c, transform.d, transform.tx, transform.ty];
}

CGPoint CGPointFromString(NSString *string){
	return NSPointToCGPoint(NSPointFromString(string));
}

CGSize CGSizeFromString(NSString *string){
	return NSSizeToCGSize(NSSizeFromString(string));
}

CGRect CGRectFromString(NSString *string){
	return NSRectToCGRect(NSRectFromString(string));
}

CGAffineTransform CGAffineTransformFromString(NSString *string){
	CGAffineTransform transform = CGAffineTransformIdentity;
	if (string != nil){
        sscanf([string cStringUsingEncoding:NSUTF8StringEncoding], "[%lf, %lf, %lf, %lf, %lf, %lf]", 
			&transform.a, &transform.b, &transform.c, &transform.d, &transform.tx, &transform.ty);
	}
    return transform;
}




@implementation NSValue (NSValueUIGeometryExtensions)

+ (NSValue *)valueWithCGPoint:(CGPoint)point{
	return [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
}

+ (NSValue *)valueWithCGSize:(CGSize)size{
	return [NSValue valueWithBytes:&size objCType:@encode(CGSize)];
}

+ (NSValue *)valueWithCGRect:(CGRect)rect{
	return [NSValue valueWithBytes:&rect objCType:@encode(CGRect)];
}

+ (NSValue *)valueWithCGAffineTransform:(CGAffineTransform)transform{
	return [NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)];
}

- (CGPoint)CGPointValue{
	CGPoint p;
	[self getValue:&p];
	return p;
}

- (CGSize)CGSizeValue{
	CGSize size;
	[self getValue:&size];
	return size;
}

- (CGRect)CGRectValue{
	CGRect rect;
	[self getValue:&rect];
	return rect;
}

- (CGAffineTransform)CGAffineTransformValue{
	CGAffineTransform transform;
	[self getValue:&transform];
	return transform;
}
@end