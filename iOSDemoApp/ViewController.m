//
//  ViewController.m
//  iOSDemoApp
//
//  Created by Marc Bauer on 28.11.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "ViewController.h"
#import "NSMPDFDocument.h"
#import "NSMPDFPageView.h"

@implementation ViewController
{
	NSMPDFDocument *_pdfDocument;
    NSMPDFPageView *_pageView;
}

- (void)viewDidLoad
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"add phone and address slideout"
    	ofType:@"pdf"];
    
    _pageView = [[NSMPDFPageView alloc] initWithFrame:self.view.bounds];
    _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        	UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_pageView];
    
    _pdfDocument = [[NSMPDFDocument alloc] initWithContentsOfFile:path];
	NSMPDFPage *page = _pdfDocument.pages[0];
    _pageView.page = page;
}
@end