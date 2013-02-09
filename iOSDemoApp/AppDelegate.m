//
//  AppDelegate.m
//  iOSDemoApp
//
//  Created by Marc Bauer on 28.11.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "AppDelegate.h"
#import "NSMPDFDocument.h"
#import "NSMPDFPageView.h"
#import "NSMPageViewController.h"

@interface AppDelegate () <UIPageViewControllerDataSource>
@end

@implementation AppDelegate
{
	NSMPDFDocument *_pdfDocument;
	NSMutableArray *_pageViewControllers;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"add phone and address slideout"
    	ofType:@"pdf"];
    
    _pdfDocument = [[NSMPDFDocument alloc] initWithContentsOfFile:path];
    _pageViewControllers = [[NSMutableArray alloc] initWithCapacity:_pdfDocument.numPages];
	for (NSUInteger i = 0; i < _pdfDocument.numPages; i++) {
    	_pageViewControllers[i] = [NSNull null];
    }
    
	UIPageViewController *pageViewCtrl = [[UIPageViewController alloc]
    	initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
        options:@{UIPageViewControllerOptionInterPageSpacingKey : @(20.0f)}];
    pageViewCtrl.dataSource = self;
    [pageViewCtrl setViewControllers:@[[self viewControllerAtIndex:0]]
    	direction:UIPageViewControllerNavigationOrientationHorizontal
        animated:NO
        completion:nil];
    self.window.rootViewController = pageViewCtrl;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	viewControllerAfterViewController:(UIViewController *)viewController
{
	NSInteger index = [_pageViewControllers indexOfObject:viewController];
    if (index == NSNotFound || index == _pageViewControllers.count - 1)
    	return nil;
	return [self viewControllerAtIndex:(index + 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSInteger index = [_pageViewControllers indexOfObject:viewController];
    if (index == NSNotFound || index == 0)
    	return nil;
	return [self viewControllerAtIndex:(index - 1)];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return _pdfDocument.numPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	return [_pageViewControllers indexOfObject:pageViewController];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
	NSMPageViewController *ctrl = _pageViewControllers[index];
    if ((id)ctrl == [NSNull null]) {
        NSMPDFPage *page = _pdfDocument.pages[index];
        ctrl = [[NSMPageViewController alloc] initWithPage:page];
		_pageViewControllers[index] = ctrl;
    }
    return ctrl;
}
@end