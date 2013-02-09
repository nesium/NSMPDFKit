//
//  NSMPageViewController.h
//  NSMPDFKit
//
//  Created by Marc Bauer on 01.12.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMPDFPage.h"

@interface NSMPageViewController : UIViewController
- (id)initWithPage:(NSMPDFPage *)aPage;
@end