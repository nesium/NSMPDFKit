//
//  NSMPDFMarkedSequence.h
//  PDF
//
//  Created by Marc Bauer on 15.07.12.
//  Copyright (c) 2012 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMPDFMarkedSequence : NSObject
@property (nonatomic, copy) NSDictionary *properties;
@property (nonatomic, retain) NSMutableArray *elements;
@end