//
//  NSMPDFPage.m
//  PDF
//
//  Created by Marc Bauer on 25.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFPage.h"
#import "NSMPDFPage+Parsing.h"
#import "NSMPDFContext.h"
#import "NSMPDFRenderer.h"
#import "NSMPDFCGContextRenderer.h"

@implementation NSMPDFPage

#pragma mark - Initialization & Deallocation

- (id)initWithPage:(CGPDFPageRef)page index:(NSUInteger)index
{
	if ((self = [super init])){
        _page = CGPDFPageRetain(page);
        _context = nil;
        _xObjects = NULL;
        _fonts = NULL;
        _properties = NULL;
        _colorSpaces = NULL;
        _shadings = NULL;
        _loadedFonts = nil;
	}
	return self;
}

- (void)dealloc
{
	CGPDFPageRelease(_page);
}



#pragma mark - Public methods

- (void)renderWithRenderer:(id<NSMPDFRenderer>)renderer
{
	_context = [[NSMPDFContext alloc] init];
    _renderer = renderer;
    
    [self parseResources];
    [_renderer beginRendering];
    [self scanPage];
    [_renderer endRendering];
    
    _context = nil;
    _xObjects = NULL;
    _fonts = NULL;
    _properties = NULL;
    _colorSpaces = NULL;
    _shadings = NULL;
    _loadedFonts = nil;
    _renderer = nil;
}
@end