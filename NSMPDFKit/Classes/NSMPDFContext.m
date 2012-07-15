//
//  NSMPDFContext.m
//  PDF
//
//  Created by Marc Bauer on 29.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFContext.h"

@implementation NSMPDFContext

#pragma mark - Public methods

- (void)moveLineMatrixByOffset:(CGPoint)offset
{
    CGAffineTransform matrix = CGAffineTransformTranslate(_lineMatrix, offset.x, offset.y);
    _textMatrix = _lineMatrix = matrix;
}
@end