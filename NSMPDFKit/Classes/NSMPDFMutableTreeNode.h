//
//  NSMPDFMutableTreeNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <NSMPDFKit/NSMPDFTreeNode.h>
#if TARGET_OS_MAC
#import <NSMPDFKit/NSMUIGeometry.h>
#endif

@interface NSMPDFMutableTreeNode : NSMPDFTreeNode <NSCopying>
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect bounds;

- (void)addChildNode:(id)node;

- (void)finalize;
@end