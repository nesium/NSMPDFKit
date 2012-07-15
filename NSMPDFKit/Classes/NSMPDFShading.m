//
//  NSMPDFShading.m
//  NSMPDF
//
//  Created by Marc Bauer on 15.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFShading.h"

NSString *NSStringFromNSMPDFShadingType(NSMPDFShadingType type)
{
	switch (type) {
    	case NSMPDFShadingTypeAxial:
        	return @"NSMPDFShadingTypeAxial";
        case NSMPDFShadingTypeCoonsPatchMesh:
        	return @"NSMPDFShadingTypeCoonsPatchMesh";
        case NSMPDFShadingTypeFreeFormGouraudShadedTriangleMesh:
        	return @"NSMPDFShadingTypeFreeFormGouraudShadedTriangleMesh";
        case NSMPDFShadingTypeFunctionBased:
        	return @"NSMPDFShadingTypeFunctionBased";
        case NSMPDFShadingTypeLatticeFormGouraudShadedTriangleMesh:
        	return @"NSMPDFShadingTypeLatticeFormGouraudShadedTriangleMesh";
        case NSMPDFShadingTypeRadial:
        	return @"NSMPDFShadingTypeRadial";
        case NSMPDFShadingTypeTensorProductPatchMesh:
        	return @"NSMPDFShadingTypeTensorProductPatchMesh";
    }
    return @"Unkown shading type";
}

static void CGShadingCallback(void *info, const CGFloat *inData, CGFloat *outData)
{
    CGFloat position = *inData;
    NSLog(@"- %f", position);
    
    outData[0] = 1.0f * position;
    outData[1] = 1.0f;
    outData[2] = 0.0f;
    outData[3] = 1.0f;
    
//    // Our colors
//    NSMutableArray* colors = (NSMutableArray*)info;
//    // Position within the gradient, ranging from 0.0 to 1.0
//    CGFloat position = *inData;
//
//    // Find the color that we want to used based on the current position;
//    NSUInteger colorIndex = position * [colors count];
//
//    // Account for the edge case where position == 1.0
//    if (colorIndex >= [colors count])
//        colorIndex = [colors count] - 1;
//
//    // Get our desired color from the array
//    UIColor* color = [colors objectAtIndex:colorIndex];
//
//    // Copy the 4 color components (red, green, blue, alpha) to outData
//    memcpy(outData, CGColorGetComponents(color.CGColor), 4 * sizeof(CGFloat));  
}


@implementation NSMPDFShading

#pragma mark - Initialization & Deallocation

- (id)initWithShadingDictionary:(CGPDFDictionaryRef)dict
{
	if ((self = [super init])) {
    	CGPDFInteger type;
    	CGPDFDictionaryGetInteger(dict, "ShadingType", &type);
        _type = (NSMPDFShadingType)type;
		
        if (_type == NSMPDFShadingTypeAxial) {
        	return [[NSMPDFAxialShading alloc] initWithShadingDictionary:dict];
        }
	}
	return self;
}

- (id)initWithShadingDictionaryInternal:(CGPDFDictionaryRef)dict
{
	if ((self = [super init])) {
    	CGPDFInteger type;
    	CGPDFDictionaryGetInteger(dict, "ShadingType", &type);
        _type = (NSMPDFShadingType)type;
    }
    return self;
}



#pragma mark - Public methods

- (void)drawInContext:(CGContextRef)context{}



#pragma mark - NSObject methods

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08lx> type: %@",
    	NSStringFromClass([self class]), (long)self, NSStringFromNSMPDFShadingType(_type)];
}
@end




@implementation NSMPDFAxialShading

#pragma mark - Initialization & Deallocation

- (id)initWithShadingDictionary:(CGPDFDictionaryRef)dict
{
	if ((self = [super initWithShadingDictionaryInternal:dict])) {
    	_domain = malloc(sizeof(CGFloat) * 2);
    	CGPDFArrayRef domain;
    	if (CGPDFDictionaryGetArray(dict, "Domain", &domain)) {
        	CGPDFReal val;
        	for (size_t i = 0; i < 2; i++) {
            	CGPDFArrayGetNumber(domain, i, &val);
                _domain[i] = val;
            }
        } else {
        	_domain[0] = 0.0f;
            _domain[1] = 1.0f;
        }
        
        CGPDFArrayRef coords;
        if (CGPDFDictionaryGetArray(dict, "Coords", &coords)) {
			CGFloat values[4];
            for (size_t i = 0; i < 4; i++) {
            	CGPDFArrayGetNumber(coords, i, &values[i]);
            }
            _start = (CGPoint){values[0], values[1]};
            _end = (CGPoint){values[2], values[3]};
        } else {
        	NDCLog(@"Could not read shading coords");
            return nil;
        }
        
        CGPDFArrayRef extend;
        if (CGPDFDictionaryGetArray(dict, "Extend", &extend)) {
        	CGPDFBoolean val;
        	CGPDFArrayGetBoolean(extend, 0, &val);
            _extendStart = val;
        	CGPDFArrayGetBoolean(extend, 1, &val);
            _extendEnd = val;
        }
    }
    return self;
}

- (void)dealloc
{
	free(_domain);
}



#pragma mark - Public methods

- (void)drawInContext:(CGContextRef)context
{
    CGFunctionCallbacks callbacks = (CGFunctionCallbacks){0, &CGShadingCallback, NULL};
    size_t rangeDimension = 4; // RGBA
    CGFloat range[8] = (CGFloat[8]){0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f};
    CGFunctionRef func = CGFunctionCreate((__bridge void *)self, 2, _domain, rangeDimension,
	    range, &callbacks);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGShadingRef shading = CGShadingCreateAxial(colorSpace, _start, _end,
    	func, _extendStart, _extendEnd);
    CGContextDrawShading(context, shading);
    CGShadingRelease(shading);
    CGFunctionRelease(func);
}
@end