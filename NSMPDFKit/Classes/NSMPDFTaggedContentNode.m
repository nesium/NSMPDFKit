//
//  NSMPDFTaggedContentNode.m
//  NSMPDFKit
//
//  Created by Marc Bauer on 29.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import "NSMPDFTaggedContentNode.h"

@implementation NSMPDFTaggedContentNode
{
	NSDictionary *_properties;
}

@synthesize properties = _properties;

#pragma mark - Initialization & Deallocation

- (id)initWithFrame:(CGRect)frame bounds:(CGRect)bounds properties:(NSDictionary *)properties
	childNodes:(NSArray *)childNodes
{
	if ((self = [super initWithFrame:frame bounds:bounds childNodes:childNodes])) {
    	_properties = [properties copy];
    }
    return self;
}



#pragma mark - Public methods

- (NSString *)name
{
	NSString *name = _properties[@"Title"];
    if (name == nil)
    	name = [super name];
    return name;
}
@end