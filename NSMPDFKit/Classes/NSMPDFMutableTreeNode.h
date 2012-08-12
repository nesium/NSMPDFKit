//
//  NSMPDFMutableTreeNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <NSMPDFKit/NSMPDFTreeNode.h>
#if !(TARGET_OS_IPHONE)
#import <NSMPDFKit/NSMUIGeometry.h>
#endif

@interface NSMPDFMutableTreeNode : NSMPDFTreeNode <NSCopying>
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, weak) NSMPDFMutableTreeNode *parentNode;

- (void)addChildNode:(id)node;
- (void)removeChildNode:(id)node;
- (void)removeFromParentNode;
- (void)removeAllChildNodes;

- (void)finalize;
@end