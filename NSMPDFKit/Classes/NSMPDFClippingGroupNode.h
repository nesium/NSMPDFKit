//
//  NSMPDFClippingGroupNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 11.08.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <NSMPDFKit/NSMPDFKit.h>

@interface NSMPDFClippingGroupNode : NSMPDFTreeNode
- (id)initWithFrame:(CGRect)frame bounds:(CGRect)bounds path:(CGPathRef)aPath
	childNodes:(NSArray *)childNodes;

@property (nonatomic, retain) __attribute__((NSObject)) CGPathRef clippingPath;
@end