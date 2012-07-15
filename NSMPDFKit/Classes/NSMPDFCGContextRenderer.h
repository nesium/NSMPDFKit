//
//  NSMCGContextRenderer.h
//  NSMPDF
//
//  Created by Marc Bauer on 15.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMPDFRenderer.h"

@interface NSMPDFCGContextRenderer : NSObject <NSMPDFRenderer>
- (id)initWithContext:(CGContextRef)ctx;
@end