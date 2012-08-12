//
//  NSMPDFTreeRenderer.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSMPDFKit/NSMPDFRenderer.h>
#import <NSMPDFKit/NSMPDFTreeNode.h>
#if (!TARGET_OS_IPHONE)
#import <NSMPDFKit/NSMUIGeometry.h>
#endif

@interface NSMPDFTreeRenderer : NSObject <NSMPDFRenderer>
@property (nonatomic, readonly) NSMPDFTreeNode *rootNode;
@property (nonatomic, readonly) NSArray *markedContentNodes;
@end