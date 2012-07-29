//
//  NSMPDFMutablePathNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "NSMPDFMutableTreeNode.h"

@interface NSMPDFMutablePathNode : NSMPDFMutableTreeNode
@property (nonatomic, retain) __attribute__((NSObject)) CGMutablePathRef path;
@end