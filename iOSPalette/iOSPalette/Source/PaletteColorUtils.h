//
//  TRIPPaletteColorUtils.h
//  Atom
//
//  Created by dylan.tang on 17/4/14.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaletteColorUtils : NSObject

+ (NSInteger)quantizedRed:(NSInteger)color;

+ (NSInteger)quantizedGreen:(NSInteger)color;

+ (NSInteger)quantizedBlue:(NSInteger)color;

+ (NSInteger)modifyWordWidthWithValue:(NSInteger)value currentWidth:(NSInteger)currentWidth targetWidth:(NSInteger)targetWidth;

@end
