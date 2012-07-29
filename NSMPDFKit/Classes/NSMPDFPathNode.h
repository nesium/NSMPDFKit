//
//  NSMPDFPathNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "NSMPDFTreeNode.h"

@interface NSMPDFPathNode : NSMPDFTreeNode
- (id)initWithCGPath:(CGPathRef)path;

@property (nonatomic, readonly) __attribute__((NSObject)) CGPathRef path;
@end