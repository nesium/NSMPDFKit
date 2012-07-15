//
//  NSMPDFPath.h
//  PDF
//
//  Created by Marc Bauer on 15.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSMPDFPath : NSObject
@property (nonatomic, strong) __attribute__((NSObject)) CGColorRef fillColor;
@property (nonatomic, strong) __attribute__((NSObject)) CGColorRef strokeColor;
@property (nonatomic, retain) __attribute__((NSObject)) CGPathRef path;
@end