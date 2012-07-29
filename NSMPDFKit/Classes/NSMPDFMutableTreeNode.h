//
//  NSMPDFMutableTreeNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFTreeNode.h"

@interface NSMPDFMutableTreeNode : NSMPDFTreeNode <NSCopying>
- (void)addChildNode:(id)node;
@end