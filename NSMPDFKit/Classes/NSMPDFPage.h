//
//  NSMPDFPage.h
//  PDF
//
//  Created by Marc Bauer on 25.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class NSMPDFFont;
@class NSMPDFContext;
@protocol NSMPDFRenderer;

@interface NSMPDFPage : NSObject
{
	@private
		CGPDFPageRef _page;
        
        CGRect _artBox;
        CGRect _bleedBox;
        CGRect _cropBox;
        CGRect _mediaBox;
        CGRect _trimBox;
        
        CGPDFDictionaryRef _xObjects;
        CGPDFDictionaryRef _fonts;
        CGPDFDictionaryRef _properties;
        CGPDFDictionaryRef _colorSpaces;
        CGPDFDictionaryRef _shadings;
        
        NSMutableDictionary *_loadedFonts;
        NSMPDFContext *_context;
        id<NSMPDFRenderer> _renderer;
}
- (id)initWithPage:(CGPDFPageRef)page index:(NSUInteger)index;

@property (nonatomic, readonly) CGRect artBox;
@property (nonatomic, readonly) CGRect bleedBox;
@property (nonatomic, readonly) CGRect cropBox;
@property (nonatomic, readonly) CGRect mediaBox;
@property (nonatomic, readonly) CGRect trimBox;

- (void)renderWithRenderer:(id<NSMPDFRenderer>)renderer;
@end