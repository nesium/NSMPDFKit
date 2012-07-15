//
//  NSMPDFShading.h
//  NSMPDF
//
//  Created by Marc Bauer on 15.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum {
	NSMPDFShadingTypeFunctionBased = 1,
    NSMPDFShadingTypeAxial = 2,
    NSMPDFShadingTypeRadial = 3,
    NSMPDFShadingTypeFreeFormGouraudShadedTriangleMesh = 4,
    NSMPDFShadingTypeLatticeFormGouraudShadedTriangleMesh = 5,
    NSMPDFShadingTypeCoonsPatchMesh = 6,
    NSMPDFShadingTypeTensorProductPatchMesh = 7
} NSMPDFShadingType;

typedef enum {
	NSMPDFShadingFunctionTypeSampled = 0,
    NSMPDFShadingFunctionTypeInterpolated = 2,
    NSMPDFShadingFunctionTypeStitched = 3,
    NSMPDFShadingFunctionTypePostScript = 4
} NSMPDFShadingFunctionType;

extern NSString *NSStringFromNSMPDFShadingType(NSMPDFShadingType type);



@interface NSMPDFShading : NSObject
- (id)initWithShadingDictionary:(CGPDFDictionaryRef)dict;

@property (nonatomic, readonly) NSMPDFShadingType type;
@property (nonatomic, readonly) CGColorSpaceRef colorSpace;
@property (nonatomic, readonly) CGColorRef background;
@property (nonatomic, readonly) CGRect bBox;
@property (nonatomic, readonly) BOOL antiAlias;

- (void)drawInContext:(CGContextRef)context;
@end


@interface NSMPDFAxialShading : NSMPDFShading
@property (nonatomic, readonly) CGPoint start;
@property (nonatomic, readonly) CGPoint end;
@property (nonatomic, readonly) CGFloat *domain;
@property (nonatomic, readonly) BOOL extendStart;
@property (nonatomic, readonly) BOOL extendEnd;
@end