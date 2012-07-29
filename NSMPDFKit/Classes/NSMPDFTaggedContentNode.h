//
//  NSMPDFTaggedContentNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFTreeNode.h"

@interface NSMPDFTaggedContentNode : NSMPDFTreeNode
- (id)initWithProperties:(NSDictionary *)properties childNodes:(NSArray *)childNodes;

@property (nonatomic, readonly) NSDictionary *properties;
@end