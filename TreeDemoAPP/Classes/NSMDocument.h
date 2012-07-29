//
//  NSMDocument.h
//  PDF
//
//  Created by Marc Bauer on 26.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NSMPDFKit/NSMPDFKit.h>

extern NSString *const NSMDocumentBecameMainNotification;

@interface NSMDocument : NSDocument
@property (nonatomic, readonly) NSMPDFDocument *pdfDocument;
@property (nonatomic, readonly) NSMPDFTreeNode *rootNode;
@end