//
//  NSMPageViewController.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 01.12.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPageViewController.h"
#import "NSMPDFPageView.h"

@implementation NSMPageViewController
{
	NSMPDFPage *_page;
}

#pragma mark - Initialization & Deallocation

- (id)initWithPage:(NSMPDFPage *)aPage
{
	if ((self = [super init])) {
    	_page = aPage;
    }
    return self;
}



#pragma mark - UIViewController methods

- (void)loadView
{
	self.view = [[NSMPDFPageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	NSMPDFPageView *pageView = (NSMPDFPageView *)self.view;
    if (pageView.page == nil)
		pageView.page = _page;
}
@end