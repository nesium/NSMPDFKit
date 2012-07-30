//
//  NSMPDFMutablePathNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFMutablePathNode.h"
#import "NSMPDFPathNode.h"

@implementation NSMPDFMutablePathNode

#pragma mark - Public methods

- (void)finalize
{
    self.bounds = CGPathGetBoundingBox(self.path);
    CGRect frame = self.frame;
    frame.size.width = CGRectGetWidth(self.bounds) - CGRectGetMinX(self.bounds);
    frame.size.height = CGRectGetHeight(self.bounds) - CGRectGetMinY(self.bounds);
    self.frame = frame;
}

#pragma mark - NSObject methods

- (id)copyWithZone:(NSZone *)zone
{
	return [[NSMPDFPathNode alloc] initWithFrame:self.frame bounds:self.bounds path:_path];
}
@end