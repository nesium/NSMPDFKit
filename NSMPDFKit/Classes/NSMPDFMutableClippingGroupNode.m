//
//  NSMPDFMutableClippingGroupNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 11.08.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFMutableClippingGroupNode.h"
#import "NSMPDFClippingGroupNode.h"

@implementation NSMPDFMutableClippingGroupNode

#pragma mark - NSCopying Protocol methods

- (id)copyWithZone:(NSZone *)zone
{
	NSMutableArray *copies = [[NSMutableArray alloc] initWithCapacity:self.numberOfChildNodes];
    for (NSMPDFMutableTreeNode *node in self.childNodes) {
    	[copies addObject:[node copy]];
    }
	return [[NSMPDFClippingGroupNode alloc] initWithFrame:self.frame bounds:self.bounds
    	path:_clippingPath childNodes:copies];
}
@end