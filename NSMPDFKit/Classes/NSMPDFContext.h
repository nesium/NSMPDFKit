//
//  NSMPDFContext.h
//  PDF
//
//  Created by Marc Bauer on 29.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMPDFFont.h"

@interface NSMPDFContext : NSObject
@property (nonatomic, strong) NSMPDFFont *font;
@property (nonatomic, assign) CGAffineTransform textMatrix;
@property (nonatomic, assign) CGAffineTransform lineMatrix;
@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, strong) __attribute__((NSObject)) CGColorSpaceRef strokeColorSpace;
@property (nonatomic, strong) __attribute__((NSObject)) CGColorSpaceRef fillColorSpace;

- (void)moveLineMatrixByOffset:(CGPoint)offset;
@end