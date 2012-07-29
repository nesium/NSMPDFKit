//
//  NSMPDFTreeNode.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMPDFTreeNode : NSObject
- (id)initWithChildNodes:(NSArray *)childNodes;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *childNodes;
@property (nonatomic, readonly) NSInteger numberOfChildNodes;
@property (nonatomic, readonly) BOOL isLeaf;
@end