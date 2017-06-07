//
//  UIColor+TRIP.m
//  TRIPKit
//
//  Created by bennyguan on 14-6-25.
//  Copyright (c) 2014年 Taobao Trip. All rights reserved.
//

#import "UIColor+Hex.h"

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



/**
 * hexString eg. #ff0000
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [UIColor colorWithHexString:hexString alpha:1.0];
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
@end
