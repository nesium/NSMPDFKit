//
//  NSMPDFDocument.m
//  PDF
//
//  Created by Marc Bauer on 25.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFDocument.h"
#import "NSMPDFPage.h"

@interface NSMPDFDocument ()
- (id)initWithCGPDFDocument:(CGPDFDocumentRef)document;
- (void)loadDocumentInfo;
@end


@implementation NSMPDFDocument
{
	CGPDFDocumentRef _pdf;
    NSArray *_pages;
}

#pragma mark - Initialization & Deallocation

- (id)initWithContentsOfFile:(NSString *)filename
{
    NSURL *fileURL = [NSURL fileURLWithPath:filename isDirectory:NO];
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((__bridge CFURLRef)fileURL);
    
	self = [self initWithCGPDFDocument:document];
    if (document != NULL){
        CFRelease(document);
    }
	return self;
}

- (id)initWithData:(NSData *)data
{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(dataProvider);
    CFRelease(dataProvider);
	
	self = [self initWithCGPDFDocument:document];
    if (document != NULL){
        CFRelease(document);
    }
	return self;
}

- (id)initWithCGPDFDocument:(CGPDFDocumentRef)document
{
    if ((self = [super init])){
        if (document == NULL){
			NSLog(@"Could not open PDF");
            return nil;
        }else{
            _pdf = CGPDFDocumentRetain(document);
            [self loadDocumentInfo];
        }
    }
    return self;
}

- (void)dealloc
{
	CGPDFDocumentRelease(_pdf);
}



#pragma mark - Public methods

- (NSUInteger)numPages
{
	return CGPDFDocumentGetNumberOfPages(_pdf);
}

- (NSArray *)pages
{
	if (!_pages){
    	NSMutableArray *pages = [NSMutableArray arrayWithCapacity:self.numPages];
    	for (NSInteger i = 1; i <= self.numPages; i++){
			NSMPDFPage *page = [[NSMPDFPage alloc] initWithPage:CGPDFDocumentGetPage(_pdf, i) 
            	index:i];
			[pages addObject:page];
        }
        _pages = [pages copy];
    }
    return _pages;
}



#pragma mark - Private methods

- (void)loadDocumentInfo
{
	CGPDFDocumentGetVersion(_pdf, &_majorVersion, &_minorVersion);
	CGPDFDictionaryRef infoDict = CGPDFDocumentGetInfo(_pdf);
	CGPDFStringRef str;
	if (CGPDFDictionaryGetString(infoDict, "Title", &str))
		_title = (NSString *)CFBridgingRelease(CGPDFStringCopyTextString(str));
	if (CGPDFDictionaryGetString(infoDict, "Author", &str))
		_author = (NSString *)CFBridgingRelease(CGPDFStringCopyTextString(str));
	if (CGPDFDictionaryGetString(infoDict, "Subject", &str))
		_subject = (NSString *)CFBridgingRelease(CGPDFStringCopyTextString(str));
	if (CGPDFDictionaryGetString(infoDict, "Keywords", &str))
		_keywords = (NSString *)CFBridgingRelease(CGPDFStringCopyTextString(str));
	if (CGPDFDictionaryGetString(infoDict, "Creator", &str))
		_creator = (NSString *)CFBridgingRelease(CGPDFStringCopyTextString(str));
	if (CGPDFDictionaryGetString(infoDict, "Producer", &str))
		_producer = (NSString *)CFBridgingRelease(CGPDFStringCopyTextString(str));
	if (CGPDFDictionaryGetString(infoDict, "CreationDate", &str))
		_creationDate = (NSDate *)CFBridgingRelease(CGPDFStringCopyDate(str));
	if (CGPDFDictionaryGetString(infoDict, "ModDate", &str))
		_modificationDate = (NSDate *)CFBridgingRelease(CGPDFStringCopyDate(str));
}
@end