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
    self.bounds = CGPathGetPathBoundingBox(self.path);
    CGRect frame = self.frame;
    frame.origin.x += CGRectGetMinX(self.bounds);
    frame.origin.y += CGRectGetMinY(self.bounds);
    frame.size.width = CGRectGetWidth(self.bounds);
    frame.size.height = CGRectGetHeight(self.bounds);
    self.frame = frame;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(
        	-CGRectGetMinX(self.bounds), -CGRectGetMinY(self.bounds));
    CGMutablePathRef transformedPath = CGPathCreateMutableCopyByTransformingPath(
    	_path, &transform);
    CGPathRelease(_path);
    _path = transformedPath;
}



#pragma mark - NSObject methods

- (id)copyWithZone:(NSZone *)zone
{
	return [[NSMPDFPathNode alloc] initWithFrame:self.frame bounds:self.bounds path:_path];
}
@end