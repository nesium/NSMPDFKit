//
//  NSMPDFPage+Parsing.m
//  PDF
//
//  Created by Marc Bauer on 26.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFPage+Parsing.h"
#import "NSMPDFParsingFunctions.m"

@implementation NSMPDFPage (Parsing)

- (NSMPDFContext *)context
{
	return _context;
}

- (id<NSMPDFRenderer>)renderer
{
	return _renderer;
}

- (void)parseProperties
{
	CGPDFDictionaryRef pageDict;
	pageDict = CGPDFPageGetDictionary(_page);
    
    CGRect (^rectForKey)(char const *) = ^CGRect (char const *key) {
    	CGPDFArrayRef arr;
    	if (!CGPDFDictionaryGetArray(pageDict, key, &arr)) {
        	return CGRectZero;
        }
    	CGRect aRect;
        CGPDFArrayGetNumber(arr, 0, &aRect.origin.x);
        CGPDFArrayGetNumber(arr, 1, &aRect.origin.y);
        CGPDFArrayGetNumber(arr, 2, &aRect.size.width);
        CGPDFArrayGetNumber(arr, 3, &aRect.size.height);
        return aRect;
    };
    
    _artBox = rectForKey("ArtBox");
    _bleedBox = rectForKey("BleedBox");
    _cropBox = rectForKey("CropBox");
    _mediaBox = rectForKey("MediaBox");
    _trimBox = rectForKey("TrimBox");
}

- (void)parseResources
{
	CGPDFDictionaryRef pageDict, resourceDict;
	pageDict = CGPDFPageGetDictionary(_page);
    
	if (!CGPDFDictionaryGetDictionary(pageDict, "Resources", &resourceDict))
		return;
    
	CGPDFDictionaryRef xObjects;
	if (CGPDFDictionaryGetDictionary(resourceDict, "XObject", &xObjects)) {
		_xObjects = xObjects;
    }
    
    CGPDFDictionaryRef fonts;
    if (CGPDFDictionaryGetDictionary(resourceDict, "Font", &fonts)) {
    	_fonts = fonts;
    }
    
    CGPDFDictionaryRef properties;
    if (CGPDFDictionaryGetDictionary(resourceDict, "Properties", &properties)) {
    	_properties = properties;
    }
    
    CGPDFDictionaryRef colorSpaces;
    if (CGPDFDictionaryGetDictionary(resourceDict, "ColorSpace", &colorSpaces)) {
    	_colorSpaces = colorSpaces;
    }
    
    CGPDFDictionaryRef shadings;
    if (CGPDFDictionaryGetDictionary(resourceDict, "Shading", &shadings)) {
    	_shadings = shadings;
    }
}

- (void)scanPage
{
	CGPDFOperatorTableRef op = CGPDFOperatorTableCreate();
    
    // Begin marked-content sequence with property list
	CGPDFOperatorTableSetCallback(op, "BDC", &NSMPDF_op_BDC);
    // End marked-content sequence
	CGPDFOperatorTableSetCallback(op, "EMC", &NSMPDF_op_EMC);
    // Begin compatibility section
	CGPDFOperatorTableSetCallback(op, "BX", &NSMPDF_op_BX);
    // End compatibility section
	CGPDFOperatorTableSetCallback(op, "EX", &NSMPDF_op_EX);
    
    // Append rectangle to path
	CGPDFOperatorTableSetCallback(op, "re", &NSMPDF_op_re);
    // Append curved segment to path (final point replicated)
	CGPDFOperatorTableSetCallback(op, "y", &NSMPDF_op_y);
    // Append curved segment to path (initial point replicated)
	CGPDFOperatorTableSetCallback(op, "v", &NSMPDF_op_v);
    // Append straight line segment to path
	CGPDFOperatorTableSetCallback(op, "l", &NSMPDF_op_l);
    // Append curved segment to path (three control points)
	CGPDFOperatorTableSetCallback(op, "c", &NSMPDF_op_c);
    
    // Set color space for stroking operations
    CGPDFOperatorTableSetCallback(op, "CS", &NSMPDF_op_CS);
    // Set color space for nonstroking operations
    CGPDFOperatorTableSetCallback(op, "cs", &NSMPDF_op_cs);
    // Set color for stroking operations (ICCBased and special color spaces)
    CGPDFOperatorTableSetCallback(op, "SCN", &NSMPDF_op_SCN);
    // Set color for nonstroking operations (ICCBased and special color spaces)
    CGPDFOperatorTableSetCallback(op, "scn", &NSMPDF_op_scn);
    // Set color for stroking operations
    CGPDFOperatorTableSetCallback(op, "SC", &NSMPDF_op_SC);
    // Set color for nonstroking operations
    CGPDFOperatorTableSetCallback(op, "sc", &NSMPDF_op_sc);
    // Set gray level for stroking operations
    CGPDFOperatorTableSetCallback(op, "G", &NSMPDF_op_G);
    // Set gray level for nonstroking operations
    CGPDFOperatorTableSetCallback(op, "g", &NSMPDF_op_g);
    // Set RGB color for stroking operations
	CGPDFOperatorTableSetCallback(op, "RG", &NSMPDF_op_RG);
    // Set RGB color for nonstroking operations
	CGPDFOperatorTableSetCallback(op, "rg", &NSMPDF_op_rg);
    // Set CMYK color for stroking operations
    CGPDFOperatorTableSetCallback(op, "K", &NSMPDF_op_K);
    // Set CMYK color for nonstroking operations
    CGPDFOperatorTableSetCallback(op, "k", &NSMPDF_op_k);
    // Set line width
    CGPDFOperatorTableSetCallback(op, "w", &NSMPDF_op_w);
    // Set line dash pattern
    CGPDFOperatorTableSetCallback(op, "d", &NSMPDF_op_d);
    
    // Stroke path
	CGPDFOperatorTableSetCallback(op, "S", &NSMPDF_op_S);
    // Close and stroke path
    CGPDFOperatorTableSetCallback(op, "s", &NSMPDF_op_s);
    // Fill path using nonzero winding number rule
	CGPDFOperatorTableSetCallback(op, "f", &NSMPDF_op_f);
    // Fill path using nonzero winding number rule (obsolete)
	CGPDFOperatorTableSetCallback(op, "F", &NSMPDF_op_f);
    // Fill path using even-odd rule
	CGPDFOperatorTableSetCallback(op, "f*", &NSMPDF_op_f_star);
    // Fill and stroke path using nonzero winding number rule
    CGPDFOperatorTableSetCallback(op, "B", &NSMPDF_op_B);
    // Fill and stroke path using even-odd rule
    CGPDFOperatorTableSetCallback(op, "B*", &NSMPDF_op_B_star);
    // Close, fill, and stroke path using nonzero winding number rule
    CGPDFOperatorTableSetCallback(op, "b", &NSMPDF_op_b);
    // Close, fill, and stroke path using even-odd rule
    CGPDFOperatorTableSetCallback(op, "b*", &NSMPDF_op_b_star);
    // End path without filling or stroking
	CGPDFOperatorTableSetCallback(op, "n", &NSMPDF_op_n);
    // Paint area defined by shading pattern
	CGPDFOperatorTableSetCallback(op, "sh", &NSMPDF_op_sh);
    
    // Save graphics state
	CGPDFOperatorTableSetCallback(op, "q", &NSMPDF_op_q);
    // Restore graphics state
	CGPDFOperatorTableSetCallback(op, "Q", &NSMPDF_op_Q);
    // Concatenate matrix to current transformation matrix
	CGPDFOperatorTableSetCallback(op, "cm", &NSMPDF_op_cm);
    // Begin new subpath
	CGPDFOperatorTableSetCallback(op, "m", &NSMPDF_op_m);
    // Close subpath
	CGPDFOperatorTableSetCallback(op, "h", &NSMPDF_op_h);
	// Set clipping path using nonzero winding number rule
	CGPDFOperatorTableSetCallback(op, "W", &NSMPDF_op_W);
    
    // Invoke named XObject
	CGPDFOperatorTableSetCallback(op, "Do", &NSMPDF_op_Do);
    // Begin text object
    CGPDFOperatorTableSetCallback(op, "BT", &NSMPDF_op_BT);
    // End text object
    CGPDFOperatorTableSetCallback(op, "ET", &NSMPDF_op_ET);
    // Set text font and size
	CGPDFOperatorTableSetCallback(op, "Tf", &NSMPDF_op_Tf);
    // Set text matrix and text line matrix
	CGPDFOperatorTableSetCallback(op, "Tm", &NSMPDF_op_Tm);
    // Show text
	CGPDFOperatorTableSetCallback(op, "Tj", &NSMPDF_op_Tj);
    // Show text, allowing individual glyph positioning
	CGPDFOperatorTableSetCallback(op, "TJ", &NSMPDF_op_TJ);
    // Move text position
	CGPDFOperatorTableSetCallback(op, "Td", &NSMPDF_op_Td);
    // Move text position and set leading
	CGPDFOperatorTableSetCallback(op, "TD", &NSMPDF_op_TD);
    // Move to start of next text line
	CGPDFOperatorTableSetCallback(op, "T*", &NSMPDF_op_T_star);
	
	CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(_page);
	CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, op, (__bridge void *)(self));
	CGPDFScannerScan(scanner);
	CGPDFScannerRelease(scanner);
	CGPDFContentStreamRelease(contentStream);
	CGPDFOperatorTableRelease(op);
}

- (CGImageRef)copyXObjectForKey:(const char *)key
{
	CGPDFStreamRef stream;
    CGPDFDictionaryGetStream(_xObjects, key, &stream);
    CGPDFDictionaryRef dict = CGPDFStreamGetDictionary(stream);
    
    // check if XObject is an image
    const char *name;
    if (!CGPDFDictionaryGetName(dict, "Subtype", &name))
		return nil;
    if (strcmp(name, "Image") != 0)
		return nil;
    
    // read image properties
    CGPDFInteger width, height, bps;
    if (!CGPDFDictionaryGetInteger(dict, "Width", &width))
		return nil;
    if (!CGPDFDictionaryGetInteger(dict, "Height", &height))
		return nil;
    if (!CGPDFDictionaryGetInteger(dict, "BitsPerComponent", &bps))
		return nil;
    
    CGPDFObjectRef colorSpaceObject;
    if (!CGPDFDictionaryGetObject(dict, "ColorSpace", &colorSpaceObject)) {
    	NDCLog(@"Could not get ColorSpace");
    	return nil;
    }
    
    CGColorSpaceRef colorSpace = NULL;
    
    // for the time being, we only support DeviceRGB and ICCBased ColorSpaces
    switch (CGPDFObjectGetType(colorSpaceObject)) {
    	case kCGPDFObjectTypeArray: {
        	CGPDFArrayRef colorSpaceArray;
            CGPDFObjectGetValue(colorSpaceObject,
            	kCGPDFObjectTypeArray, &colorSpaceArray);
        	colorSpace = NSMPDF_newICCColorSpaceFromArray(colorSpaceArray);
        	break;
        }
        
        case kCGPDFObjectTypeName: {
            const char *colorSpaceName;
            CGPDFObjectGetValue(colorSpaceObject, kCGPDFObjectTypeName, &colorSpaceName);
            if (strcmp(colorSpaceName, "DeviceRGB") != 0) {
                NDCLog(@"Image ColorSpace (%s) not supported.", colorSpaceName);
                return nil;
            }
            colorSpace = CGColorSpaceCreateDeviceRGB();
        	break;
        }
        
        default:
        	NDCLog(@"Unsupported ColorSpace type");
        	break;
    }
    
    if (colorSpace == NULL)
    	return nil;
    
    CGPDFDataFormat format;
    CFDataRef data = CGPDFStreamCopyData(stream, &format);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGImageRef image = NULL;
    
    if (format == CGPDFDataFormatJPEGEncoded || format == CGPDFDataFormatJPEG2000) {
        image = CGImageCreateWithJPEGDataProvider(provider, NULL, YES,
            kCGRenderingIntentDefault);
    } else if (format == CGPDFDataFormatRaw) {
        size_t bitsPerPixel = CGColorSpaceGetNumberOfComponents(colorSpace) * bps;
        size_t bytesPerRow = (bitsPerPixel * width) / 8;
        image = CGImageCreate(width, height, bps, bitsPerPixel, bytesPerRow,
            colorSpace, 0, provider, NULL, 1, kCGRenderingIntentDefault);
    }
    
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    CFRelease(data);
    
    return image;
}

- (NSMPDFFont *)fontForKey:(const char *)key
{
	if (_loadedFonts == nil) {
    	_loadedFonts = [[NSMutableDictionary alloc] initWithCapacity:
        	CGPDFDictionaryGetCount(_fonts)];
    }
    
    NSString *theKey = [NSString stringWithUTF8String:key];
	NSMPDFFont *font = [_loadedFonts objectForKey:theKey];
	if (font == nil) {
    	CGPDFDictionaryRef fontDict;
        if (!CGPDFDictionaryGetDictionary(_fonts, key, &fontDict)) {
        	NDCLog(@"No font for id %s", key);
            return nil;
        }
    	font = [[NSMPDFFont alloc] initWithFontDictionary:fontDict];
        [_loadedFonts setObject:font forKey:theKey];
    }
	
	return font;
}

- (NSDictionary *)propertyDictionaryForKey:(const char *)key
{
	CGPDFDictionaryRef dict;
    if (!CGPDFDictionaryGetDictionary(_properties, key, &dict)) {
    	return nil;
    }
    return NSMPDF_dictionaryFromPDFDictionary(dict);
}

- (CGColorSpaceRef)newColorSpaceForKey:(const char *)key
{
	CGPDFArrayRef colorSpaceArray;
    if (!CGPDFDictionaryGetArray(_colorSpaces, key, &colorSpaceArray)) {
    	return NULL;
    }
    
    if (CGPDFArrayGetCount(colorSpaceArray) < 2) {
    	NDCLog(@"ColorSpace Array too short");
        return NULL;
    }
    
    const char *name;
    if (!CGPDFArrayGetName(colorSpaceArray, 0, &name)) {
		return NULL;
    }
    
    if (strcmp(name, "CalRGB") == 0) {
    	NDCLog(@"ColorSpace CalRGB not supported");
        return NULL;
    } else if (strcmp(name, "CalGray") == 0) {
    	NDCLog(@"ColorSpace CalGray not supported");
        return NULL;
    } else if (strcmp(name, "Lab") == 0) {
    	NDCLog(@"ColorSpace Lab not supported");
        return NULL;
    } else if (strcmp(name, "ICCBased") == 0) {
		return NSMPDF_newICCColorSpaceFromArray(colorSpaceArray);
    } else if (strcmp(name, "DeviceRGB") == 0 ||
    	strcmp(name, "DeviceCMYK") == 0 ||
        strcmp(name, "DeviceGray") == 0) {
        return NSMPDF_createColorSpaceWithName(name, (__bridge void *)self);
    } else if (strcmp(name, "Separation") == 0) {
    	NDCLog(@"ColorSpace Separation not supported");
        return NULL;
    } else if (strcmp(name, "DeviceN") == 0) {
    	NDCLog(@"ColorSpace DeviceN not supported");
        return NULL;
    } else if (strcmp(name, "Indexed") == 0) {
    	NDCLog(@"ColorSpace Indexed not supported");
        return NULL;
    } else if (strcmp(name, "Pattern") == 0) {
    	NDCLog(@"ColorSpace Pattern not supported");
        return NULL;
    }
    
	NDCLog(@"Unknown colorSpace %s", name);
    return NULL;
}

- (NSMPDFShading *)shadingForKey:(const char *)key
{
	CGPDFDictionaryRef shadingDict;
    if (!CGPDFDictionaryGetDictionary(_shadings, key, &shadingDict)) {
    	return nil;
    }
    return [[NSMPDFShading alloc] initWithShadingDictionary:shadingDict];
}
@end