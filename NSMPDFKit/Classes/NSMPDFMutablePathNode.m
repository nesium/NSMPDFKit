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

#pragma mark - NSObject methods

- (id)copyWithZone:(NSZone *)zone
{
	return [[NSMPDFPathNode alloc] initWithCGPath:_path];
}
@end