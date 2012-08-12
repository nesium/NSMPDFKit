//
//  NSMPDFMutableClippingGroupNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 11.08.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <NSMPDFKit/NSMPDFKit.h>

@interface NSMPDFMutableClippingGroupNode : NSMPDFMutableTreeNode
@property (nonatomic, retain) __attribute__((NSObject)) CGMutablePathRef clippingPath;
@end