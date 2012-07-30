//
//  NSMPDFMutableTaggedContentNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFMutableTaggedContentNode.h"
#import "NSMPDFTaggedContentNode.h"

@implementation NSMPDFMutableTaggedContentNode

#pragma mark - NSCopying Protocol methods

- (id)copyWithZone:(NSZone *)zone
{
	NSMutableArray *copies = [[NSMutableArray alloc] initWithCapacity:self.numberOfChildNodes];
    for (NSMPDFMutableTreeNode *node in self.childNodes) {
    	[copies addObject:[node copy]];
    }
	return [[NSMPDFTaggedContentNode alloc] initWithFrame:self.frame bounds:self.bounds
    	properties:self.properties childNodes:copies];
}
@end