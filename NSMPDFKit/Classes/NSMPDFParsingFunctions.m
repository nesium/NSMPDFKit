//
//  NSMPDFParsingFunctions.c
//  PDF
//
//  Created by Marc Bauer on 26.01.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFPage+Parsing.h"

#define NSM_PAGE(userInfo) ((__bridge NSMPDFPage *)userInfo)
#define NSM_RENDERER(userInfo) NSM_PAGE(userInfo).renderer

static NSDictionary *NSMPDF_dictionaryFromPDFDictionary(CGPDFDictionaryRef dict);


static void NSMPDF_popFloats(CGPDFScannerRef scanner, CGFloat *buffer, NSUInteger count)
{
	for (NSInteger i = count - 1; i >= 0; i--) {
    	CGPDFReal value;
        if (!CGPDFScannerPopNumber(scanner, &value)) {
        	[NSException raise:@"NSMPDFParsingException" format:@"Could not pop float"];
        }
        buffer[i] = value;
    }
}

static CGPoint NSMPDF_popPoint(CGPDFScannerRef scanner)
{
	CGFloat values[2];
    NSMPDF_popFloats(scanner, values, 2);
    return *((CGPoint *)values);
}

static CGAffineTransform NSMPDF_popMatrix(CGPDFScannerRef scanner)
{
	CGFloat values[6];
    NSMPDF_popFloats(scanner, values, 6);
    return *((CGAffineTransform *)values);
}

static NSObject *NSMPDF_objectFromPDFObject(CGPDFObjectRef obj)
{
	CGPDFObjectType objType = CGPDFObjectGetType(obj);
	switch (objType) {
		case kCGPDFObjectTypeArray: {
			CGPDFArrayRef arr;
			CGPDFObjectGetValue(obj, objType, &arr);
			size_t numEntries = CGPDFArrayGetCount(arr);
			NSMutableArray *nsArr = [[NSMutableArray alloc] initWithCapacity:numEntries];
			for (size_t i = 0; i < numEntries; i++) {
				CGPDFObjectRef subObj;
				CGPDFArrayGetObject(arr, i, &subObj);
				[nsArr addObject:NSMPDF_objectFromPDFObject(subObj)];
			}
			return nsArr;
		} case kCGPDFObjectTypeBoolean: {
			CGPDFBoolean pdfBool;
			CGPDFObjectGetValue(obj, objType, &pdfBool);
			return [NSNumber numberWithBool:(pdfBool == 1)];
		} case kCGPDFObjectTypeDictionary: {
			CGPDFDictionaryRef dict;
			CGPDFObjectGetValue(obj, objType, &dict);
			return NSMPDF_dictionaryFromPDFDictionary(dict);
		} case kCGPDFObjectTypeInteger: {
			CGPDFInteger pdfInt;
			CGPDFObjectGetValue(obj, objType, &pdfInt);
			return [NSNumber numberWithLong:pdfInt];
		} case kCGPDFObjectTypeName:{
		    const char *name;
			CGPDFObjectGetValue(obj, objType, &name);
			return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
		} case kCGPDFObjectTypeNull:
			return [NSNull null];
		case kCGPDFObjectTypeReal: {
			CGPDFReal pdfReal;
			CGPDFObjectGetValue(obj, objType, &pdfReal);
			return [NSNumber numberWithFloat:pdfReal];
		} case kCGPDFObjectTypeStream:
			NDCLog(@"IGNORING STREAM");
			break;
		case kCGPDFObjectTypeString: {
			CGPDFStringRef str;
			CGPDFObjectGetValue(obj, objType, &str);
			CFStringRef cfStr = CGPDFStringCopyTextString(str);
			return CFBridgingRelease(cfStr);
		}
	}
	return [NSNull null];
}

static void NSMPDF_copyDictionaryValues(const char *key, CGPDFObjectRef object, void *userInfo)
{
	NSMutableDictionary *dict = (__bridge NSMutableDictionary *)userInfo;
	NSString *nsKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
	[dict setObject:NSMPDF_objectFromPDFObject(object) forKey:nsKey];
}

static NSDictionary *NSMPDF_dictionaryFromPDFDictionary(CGPDFDictionaryRef dict)
{
	size_t numEntries = CGPDFDictionaryGetCount(dict);
	NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] initWithCapacity:numEntries];
	CGPDFDictionaryApplyFunction(dict, &NSMPDF_copyDictionaryValues,
    	(__bridge CFMutableDictionaryRef)nsDict);
	return [nsDict copy];
}

static NSArray *NSMPDF_popArrayWithAllObjects(CGPDFScannerRef scanner, void *userInfo)
{
	CGPDFObjectRef obj;
	NSMutableArray *arr = nil;
	while (CGPDFScannerPopObject(scanner, &obj)) {
		if (!arr) {
			arr = [[NSMutableArray alloc] init];
		}
		[arr addObject:NSMPDF_objectFromPDFObject(obj)];
	}
	return arr;
}

static CGColorRef NSMPDF_createRGBColorWithComponents(CGFloat rgb[3])
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpace, (CGFloat[4]){rgb[0], rgb[1], rgb[2], 1.0f});
    CGColorSpaceRelease(colorSpace);
    return color;
}

static CGColorSpaceRef NSMPDF_createColorSpaceWithName(const char *name, void *userInfo)
{
	if (strcmp(name, "DeviceGray") == 0) {
    	return CGColorSpaceCreateDeviceGray();
    } else if (strcmp(name, "DeviceRGB") == 0) {
    	return CGColorSpaceCreateDeviceRGB();
    } else if (strcmp(name, "DeviceCMYK") == 0) {
    	return CGColorSpaceCreateDeviceCMYK();
    } else if (strcmp(name, "Pattern") == 0) {
    	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    	CGColorSpaceRef colorSpace = CGColorSpaceCreatePattern(rgbColorSpace);
        CGColorSpaceRelease(rgbColorSpace);
        return colorSpace;
    } else {
    	return [NSM_PAGE(userInfo) newColorSpaceForKey:name];
    }
}

static CGColorRef NSMPDF_createColorUsingColorSpace(CGPDFScannerRef scanner,
	CGColorSpaceRef colorSpace) {
	CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
    
    switch (model) {
    	case kCGColorSpaceModelRGB: {
            CGFloat rgb[3];
            NSMPDF_popFloats(scanner, rgb, 3);
            return CGColorCreate(colorSpace, (CGFloat[4]){rgb[0], rgb[1], rgb[2], 1.0f});
        } case kCGColorSpaceModelDeviceN: {
        	NDCLog(@"DeviceN ColorSpace not supported");
            break;
        } case kCGColorSpaceModelCMYK: {
            CGFloat cmyk[3];
            NSMPDF_popFloats(scanner, cmyk, 4);
            return CGColorCreate(colorSpace, cmyk);
        } case kCGColorSpaceModelIndexed: {
        	NDCLog(@"Indexed ColorSpace not supported");
            break;
        } case kCGColorSpaceModelLab: {
        	NDCLog(@"Lab ColorSpace not supported");
            break;
        } case kCGColorSpaceModelMonochrome: {
        	NDCLog(@"Monochrome ColorSpace not supported");
            break;
        } case kCGColorSpaceModelPattern: {
        	NDCLog(@"Pattern ColorSpace not supported");
            break;
        } case kCGColorSpaceModelUnknown: {
        	NDCLog(@"Ingoring unknown ColorSpace");
        }
    }
    return NULL;
}

static CGColorSpaceRef NSMPDF_newICCColorSpaceFromArray(CGPDFArrayRef colorSpaceArray) {
    const char *name;
    if (!CGPDFArrayGetName(colorSpaceArray, 0, &name)) {
    	NDCLog(@"Could not get ColorSpace name");
		return NULL;
    }
    
    if (strcmp(name, "ICCBased") != 0) {
    	NDCLog(@"ColorSpace is not ICCBased (%s)", name);
    }
    
    CGPDFStreamRef ICCStream;
    if (!CGPDFArrayGetStream(colorSpaceArray, 1, &ICCStream)) {
        NDCLog(@"Could not read ICCStream");
        return NULL;
    }
    
    CGPDFDataFormat format;
    CFDataRef data = CGPDFStreamCopyData(ICCStream, &format);
    if (format != CGPDFDataFormatRaw) {
        NDCLog(@"ICC data format not supported.");
        CFRelease(data);
        return NULL;
    }
    
    return CGColorSpaceCreateWithICCProfile(data);
}




static void NSMPDF_op_BDC(CGPDFScannerRef scanner, void *info)
{
	CGPDFObjectRef value;
    CGPDFObjectType valueType;
    NSDictionary *dict;
    
	if (!CGPDFScannerPopObject(scanner, &value)) {
    	NDCLog(@"Could not pop object");
        return;
    }
	
	valueType = CGPDFObjectGetType(value);
    if (valueType == kCGPDFObjectTypeDictionary) {
    	CGPDFDictionaryRef inlineDict;
    	CGPDFObjectGetValue(value, kCGPDFObjectTypeDictionary, &inlineDict);
    	dict = NSMPDF_dictionaryFromPDFDictionary(inlineDict);
    } else if (valueType == kCGPDFObjectTypeName) {
    	const char *tagName;
        CGPDFObjectGetValue(value, kCGPDFObjectTypeName, &tagName);
        dict = [NSM_PAGE(info) propertyDictionaryForKey:tagName];
    }
    
	[NSM_RENDERER(info) beginMarkedContentWithProperties:dict];
}

static void NSMPDF_op_EMC(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) endMarkedContent];
}

static void NSMPDF_op_BX(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) beginCompatibilitySection];
}

static void NSMPDF_op_EX(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) endCompatibilitySection];
}

static void NSMPDF_op_re(CGPDFScannerRef scanner, void *info)
{
	CGFloat values[4];
    NSMPDF_popFloats(scanner, values, 4);
    CGRect rect = *((CGRect *)values);
	[NSM_RENDERER(info) addRectangle:rect];
}

static void NSMPDF_op_y(CGPDFScannerRef scanner, void *info)
{
    CGPoint p = NSMPDF_popPoint(scanner);
    CGPoint cp2 = p;
    CGPoint cp1 = NSMPDF_popPoint(scanner);
    [NSM_RENDERER(info) addCurveToPoint:p controlPoint1:cp1 controlPoint2:cp2];
}

static void NSMPDF_op_v(CGPDFScannerRef scanner, void *info)
{
    CGPoint cp1 = [NSM_RENDERER(info) pathCurrentPoint];
    CGPoint p = NSMPDF_popPoint(scanner);
    CGPoint cp2 = NSMPDF_popPoint(scanner);
    [NSM_RENDERER(info) addCurveToPoint:p controlPoint1:cp1 controlPoint2:cp2];
}

static void NSMPDF_op_CS(CGPDFScannerRef scanner, void *info)
{
	const char *name;
    if (!CGPDFScannerPopName(scanner, &name)) {
    	NDCLog(@"Could not pop name");
        return;
    }
    NSM_PAGE(info).context.strokeColorSpace = NSMPDF_createColorSpaceWithName(name, info);
}

static void NSMPDF_op_cs(CGPDFScannerRef scanner, void *info)
{
	const char *name;
    if (!CGPDFScannerPopName(scanner, &name)) {
    	NDCLog(@"Could not pop name");
        return;
    }
    NSM_PAGE(info).context.fillColorSpace = NSMPDF_createColorSpaceWithName(name, info);
}

static void NSMPDF_op_SCN(CGPDFScannerRef scanner, void *info)
{
	CGColorSpaceRef colorSpace = NSM_PAGE(info).context.strokeColorSpace;
	CGColorRef color = NSMPDF_createColorUsingColorSpace(scanner, colorSpace);
    [NSM_RENDERER(info) setStrokeColor:color];
    CGColorRelease(color);
}

static void NSMPDF_op_scn(CGPDFScannerRef scanner, void *info)
{
	CGColorSpaceRef colorSpace = NSM_PAGE(info).context.fillColorSpace;
	CGColorRef color = NSMPDF_createColorUsingColorSpace(scanner, colorSpace);
    [NSM_RENDERER(info) setFillColor:color];
    CGColorRelease(color);
}

static void NSMPDF_op_SC(CGPDFScannerRef scanner, void *info)
{
}

static void NSMPDF_op_sc(CGPDFScannerRef scanner, void *info)
{
}

static void NSMPDF_op_G(CGPDFScannerRef scanner, void *info)
{
}

static void NSMPDF_op_g(CGPDFScannerRef scanner, void *info)
{
}

static void NSMPDF_op_RG(CGPDFScannerRef scanner, void *info)
{
	CGFloat rgb[3];
    NSMPDF_popFloats(scanner, rgb, 3);
    CGColorRef color = NSMPDF_createRGBColorWithComponents(rgb);
    [NSM_RENDERER(info) setStrokeColor:color];
    CGColorRelease(color);
}

static void NSMPDF_op_rg(CGPDFScannerRef scanner, void *info)
{
	CGFloat rgb[3];
    NSMPDF_popFloats(scanner, rgb, 3);
    CGColorRef color = NSMPDF_createRGBColorWithComponents(rgb);
    [NSM_RENDERER(info) setFillColor:color];
    CGColorRelease(color);
}

static void NSMPDF_op_d(CGPDFScannerRef scanner, void *info)
{
	CGPDFArrayRef dashArray;
    CGFloat dashPhase;
    if (!CGPDFScannerPopNumber(scanner, &dashPhase)) {
    	NDCLog(@"Could not pop float");
        return;
    }
    if (!CGPDFScannerPopArray(scanner, &dashArray)) {
    	NDCLog(@"Could not pop array");
        return;
    }
    
    size_t count = CGPDFArrayGetCount(dashArray);
    
    if (count == 0) {
    	return;
    }
    
    CGFloat *lengths = malloc(sizeof(CGFloat) * count);
    for (size_t i = 0; i < count; i++) {
    	CGPDFArrayGetNumber(dashArray, i, &lengths[i]);
    }
    [NSM_RENDERER(info) setLineDashWithPhase:dashPhase lengths:lengths count:count];
    free(lengths);
}

static void NSMPDF_op_K(CGPDFScannerRef scanner, void *info)
{
}

static void NSMPDF_op_k(CGPDFScannerRef scanner, void *info)
{
}

static void NSMPDF_op_w(CGPDFScannerRef scanner, void *info)
{
	CGFloat width;
    NSMPDF_popFloats(scanner, &width, 1);
    [NSM_RENDERER(info) setLineWidth:width];
}

static void NSMPDF_op_S(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) strokePath];
}

static void NSMPDF_op_s(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) closePath];
    [NSM_RENDERER(info) strokePath];
}

static void NSMPDF_op_f(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) closePath];
	[NSM_RENDERER(info) fillPath];
}

static void NSMPDF_op_f_star(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) fillPathEO];
}

static void NSMPDF_op_B(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) fillPath];
	[NSM_RENDERER(info) strokePath];
}

static void NSMPDF_op_B_star(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) fillPathEO];
	[NSM_RENDERER(info) strokePath];
}

static void NSMPDF_op_b(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) closePath];
	[NSM_RENDERER(info) fillPath];
	[NSM_RENDERER(info) strokePath];
}

static void NSMPDF_op_b_star(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) closePath];
	[NSM_RENDERER(info) fillPathEO];
	[NSM_RENDERER(info) strokePath];
}

static void NSMPDF_op_q(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) saveGraphicsState];
}

static void NSMPDF_op_Q(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) restoreGraphicsState];
}

static void NSMPDF_op_cm(CGPDFScannerRef scanner, void *info)
{
    CGAffineTransform transform = NSMPDF_popMatrix(scanner);
    [NSM_RENDERER(info) concatCTM:transform];
}

static void NSMPDF_op_m(CGPDFScannerRef scanner, void *info)
{
    CGPoint p = NSMPDF_popPoint(scanner);
    [NSM_RENDERER(info) addPath];
    [NSM_RENDERER(info) moveToPoint:p];
}

static void NSMPDF_op_h(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) closePath];
}

static void NSMPDF_op_l(CGPDFScannerRef scanner, void *info)
{
    CGPoint p = NSMPDF_popPoint(scanner);
    [NSM_RENDERER(info) addLineToPoint:p];
}

static void NSMPDF_op_c(CGPDFScannerRef scanner, void *info)
{
    CGPoint p = NSMPDF_popPoint(scanner);
    CGPoint cp2 = NSMPDF_popPoint(scanner);
    CGPoint cp1 = NSMPDF_popPoint(scanner);
    [NSM_RENDERER(info) addCurveToPoint:p controlPoint1:cp1 controlPoint2:cp2];
}

static void NSMPDF_op_W(CGPDFScannerRef scanner, void *info)
{
    [NSM_RENDERER(info) clip];
}

static void NSMPDF_op_n(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) closePath];
}

static void NSMPDF_op_sh(CGPDFScannerRef scanner, void *info)
{
	const char *name;
    if (!CGPDFScannerPopName(scanner, &name)) {
    	NDCLog(@"Could not pop name");
        return;
    }
    NSMPDFShading *shading = [NSM_PAGE(info) shadingForKey:name];
    [NSM_RENDERER(info) drawShading:shading];
}

static void NSMPDF_op_Do(CGPDFScannerRef scanner, void *info)
{
	const char *xObjectName;
    if (!CGPDFScannerPopName(scanner, &xObjectName)) {
    	NDCLog(@"Could not pop xObject name");
        return;
    }
    CGImageRef img = [NSM_PAGE(info) copyXObjectForKey:xObjectName];
    [NSM_RENDERER(info) drawImage:img inRect:(CGRect){CGPointZero, 1.0f, 1.0f}];
	CGImageRelease(img);
}

static void NSMPDF_op_BT(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) beginTextObject];
    NSMPDFContext *ctx = NSM_PAGE(info).context;
    ctx.textMatrix = ctx.lineMatrix = CGAffineTransformIdentity;
    [NSM_RENDERER(info) setTextMatrix:CGAffineTransformIdentity];
}

static void NSMPDF_op_ET(CGPDFScannerRef scanner, void *info)
{
	[NSM_RENDERER(info) endTextObject];
}

static void NSMPDF_op_Tf(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal fontSize;
    if (!CGPDFScannerPopNumber(scanner, &fontSize)) {
		NDCLog(@"Could not pop font size");
        return;
    }
    
	const char *fontName;
	if (!CGPDFScannerPopName(scanner, &fontName)) {
    	NDCLog(@"Could not pop font name");
        return;
    }
    
    NSMPDFFont *font = [NSM_PAGE(info) fontForKey:fontName];
	font.size = fontSize;
    NSM_PAGE(info).context.font = font;
    [NSM_RENDERER(info) setFont:font.CGFont];
    [NSM_RENDERER(info) setFontSize:fontSize];
}

static void NSMPDF_op_Tm(CGPDFScannerRef scanner, void *info)
{
    CGAffineTransform transform = NSMPDF_popMatrix(scanner);
    NSMPDFContext *ctx = NSM_PAGE(info).context;
    ctx.textMatrix = ctx.lineMatrix = transform;
    [NSM_RENDERER(info) setTextMatrix:transform];
}

static void NSMPDF_op_Tj(CGPDFScannerRef scanner, void *info)
{
	CGPDFStringRef str;
	if (!CGPDFScannerPopString(scanner, &str)) {
    	NDCLog(@"Could not pop string");
        return;
    }
	[NSM_PAGE(info).context.font showText:str renderer:NSM_RENDERER(info)];
}

static void NSMPDF_op_TJ(CGPDFScannerRef scanner, void *info)
{
	CGPDFArrayRef entries;
	if (!CGPDFScannerPopArray(scanner, &entries)) {
    	NDCLog(@"Could not pop text array");
        return;
    }
    
    NSMPDFFont *font = NSM_PAGE(info).context.font;
    
	size_t count = CGPDFArrayGetCount(entries);
	for (size_t i = 0; i < count; i++) {
		CGPDFObjectRef entry;
		CGPDFArrayGetObject(entries, i, &entry);
    	
		if (CGPDFObjectGetType(entry) == kCGPDFObjectTypeString) {
			CGPDFStringRef str;
			CGPDFObjectGetValue(entry, kCGPDFObjectTypeString, &str);
            [font showText:str renderer:NSM_RENDERER(info)];
		}else{
        	CGPDFReal offset;
            CGPDFObjectGetValue(entry, kCGPDFObjectTypeReal, &offset);
            CGPoint pos = [NSM_RENDERER(info) textPosition];
            pos.x -= offset / 1000.0f;
            [NSM_RENDERER(info) setTextPosition:pos];
		}
	}
}

static void NSMPDF_op_Td(CGPDFScannerRef scanner, void *info)
{
    CGPoint offset = NSMPDF_popPoint(scanner);
    NSMPDFContext *ctx = NSM_PAGE(info).context;
    [ctx moveLineMatrixByOffset:offset];
    [NSM_RENDERER(info) setTextMatrix:ctx.textMatrix];
}

static void NSMPDF_op_TD(CGPDFScannerRef scanner, void *info)
{
    CGPoint offset = NSMPDF_popPoint(scanner);
    NSMPDFContext *ctx = NSM_PAGE(info).context;
    [ctx moveLineMatrixByOffset:offset];
    ctx.leading = offset.y;
    [NSM_RENDERER(info) setTextMatrix:ctx.textMatrix];
}

static void NSMPDF_op_T_star(CGPDFScannerRef scanner, void *info)
{
    NSMPDFContext *ctx = NSM_PAGE(info).context;
    [ctx moveLineMatrixByOffset:(CGPoint){0.0f, ctx.leading}];
    [NSM_RENDERER(info) setTextMatrix:ctx.textMatrix];
}