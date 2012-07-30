//
//  NSMPDFPageView.h
//  PDF
//
//  Created by Marc Bauer on 25.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <NSMPDFKit/NSMPDFKit.h>

@interface NSMPDFPageView : NSView
@property (nonatomic, retain) NSMPDFTreeNode *rootNode;
@end