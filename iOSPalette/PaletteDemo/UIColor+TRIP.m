//
//  UIColor+TRIP.m
//  TRIPKit
//
//  Created by bennyguan on 14-6-25.
//  Copyright (c) 2014年 Taobao Trip. All rights reserved.
//

#import "UIColor+TRIP.h"

@implementation UIColor (TRIP)

- (CGFloat)red {
	CGColorRef color = self.CGColor;
    CGFloat const *components = CGColorGetComponents(color);
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelMonochrome)
    {
        return components[0];
    }
	else if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelRGB) {
		return components[0];
	}
    
	return -1;
}


- (CGFloat)green {
	CGColorRef color = self.CGColor;
    CGFloat const *components = CGColorGetComponents(color);
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelMonochrome)
    {
        return components[0];
    }
    else if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelRGB)
    {
        return components[1];
    }
    return -1;
}


- (CGFloat)blue {
	CGColorRef color = self.CGColor;
    CGFloat const *components = CGColorGetComponents(color);
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelMonochrome)
    {
        return components[0];
    }
    else if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelRGB)
    {
        return components[2];
    }
    return -1;
}


- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

+(UIColor*)colorWithRGBA:(NSUInteger)hex {
    float r, g, b, a;
    a = (hex & 0x000000FF) / 255.0;
    hex = hex >> 8;
    b = hex & 0x000000FF;
    hex = hex >> 8;
    g = hex & 0x000000FF;
    hex = hex >> 8;
    r = hex;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+(UIColor*)colorWithRGB:(NSUInteger)hex
                  alpha:(CGFloat)alpha {
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

/**
 * hexString eg. #ff0000
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [UIColor colorWithHexString:hexString alpha:1.0];
}

/**
 * hexString eg. #ffffffff(ARGB格式)
 */
+ (UIColor *)colorWithHexStringWithAlphaARGB:(NSString*)hexString {
   	if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    } else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    unsigned int value = 0;
    BOOL flag = [[NSScanner scannerWithString:hexString] scanHexInt:&value];
    if(NO == flag)
        return [UIColor clearColor];
    float r, g, b, a;
    b = (value & 0x000000FF);
    value = value >> 8;
    g = value & 0x000000FF;
    value = value >> 8;
    r = value & 0x000000FF;
    value = value >> 8;
    a = value / 255;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}


/**
 * hexString eg. #ffffffff
 */
+ (UIColor *)colorWithHexStringWithAlpha:(NSString*)hexString {
   	if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    } else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    unsigned int value = 0;
    BOOL flag = [[NSScanner scannerWithString:hexString] scanHexInt:&value];
    if(NO == flag)
        return [UIColor clearColor];
    float r, g, b, a;
    a = (value & 0x000000FF) / 255.0;
    value = value >> 8;
    b = value & 0x000000FF;
    value = value >> 8;
    g = value & 0x000000FF;
    value = value >> 8;
    r = value;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    } else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    unsigned int value = 0;
    BOOL flag = [[NSScanner scannerWithString:hexString] scanHexInt:&value];
    if(NO == flag)
        return [UIColor clearColor];
    float r, g, b, a;
    a = alpha;
    b = value & 0x0000FF;
    value = value >> 8;
    g = value & 0x0000FF;
    value = value >> 8;
    r = value;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+ (UIColor *)colorFromRGB:(NSInteger)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0];
    
}

-(UIImage*)image
{
    return [self imageWithSize:CGSizeMake(1, 1)];
}

-(UIImage*)imageWithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*)imageWithMask:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    if(color)
    {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
