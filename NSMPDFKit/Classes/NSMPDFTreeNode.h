//
//  NSMPDFTreeNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSMPDFTreeNode : NSObject
- (id)initWithFrame:(CGRect)frame bounds:(CGRect)bounds childNodes:(NSArray *)childNodes;

@property (nonatomic, readonly) CGRect frame;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *childNodes;
@property (nonatomic, readonly) NSInteger numberOfChildNodes;
@property (nonatomic, readonly) BOOL isLeaf;

- (void)drawInContext:(CGContextRef)ctx;
@end