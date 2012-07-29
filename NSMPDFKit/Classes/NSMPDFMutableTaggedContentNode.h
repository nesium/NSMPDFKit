//
//  NSMPDFMutableTaggedContentNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFMutableTreeNode.h"

@interface NSMPDFMutableTaggedContentNode : NSMPDFMutableTreeNode
@property (nonatomic, retain) NSDictionary *properties;
@end