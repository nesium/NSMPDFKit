//
//  NSMOutlinePanelController.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NSMPDFKit/NSMPDFKit.h>

@interface NSMOutlinePanelController : NSWindowController
@property (nonatomic, retain) NSMPDFTreeNode *rootNode;
@end