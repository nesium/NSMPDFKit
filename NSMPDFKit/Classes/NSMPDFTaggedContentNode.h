//
//  NSMPDFTaggedContentNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFTreeNode.h"

@interface NSMPDFTaggedContentNode : NSMPDFTreeNode
- (id)initWithFrame:(CGRect)frame bounds:(CGRect)bounds properties:(NSDictionary *)properties
	childNodes:(NSArray *)childNodes;

@property (nonatomic, readonly) NSDictionary *properties;
@end