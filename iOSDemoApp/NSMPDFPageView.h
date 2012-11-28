//
//  NSMPDFPageView.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 28.11.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSMPDFPage;

@interface NSMPDFPageView : UIView
@property (nonatomic, strong) NSMPDFPage *page;
@end