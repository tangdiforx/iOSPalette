//
//  UIColor+Complementary.m
//  
//
//  Created by kmyhy on 2018/11/7.
//  Copyright © 2018年 kmyhy. All rights reserved.
//

#import "UIColor+Complementary.h"

@implementation UIColor (Complementary)
-(UIColor*)complementaryColor{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    //Check if color is transparent
    if (alpha == 0) {
        return [UIColor clearColor];
    }else{
        return [UIColor colorWithRed:(1-red) green:(1-green) blue:(1-blue) alpha:alpha];
    }
}
-(UIColor*)blackWhiteComplementaryColor{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    //Check if color is transparent
    if (alpha == 0) {
        return [UIColor clearColor];
    }else{
        // 计算亮度
        red *= 0.2126f; green *= 0.7152f; blue *= 0.0722f;
        CGFloat luminance = red + green + blue;

        UIColor * black = [UIColor colorWithWhite:0 alpha:alpha];
        UIColor * white = [UIColor colorWithWhite:1 alpha:alpha];
        return (luminance > 0.6f)?black:white;
    }
}
@end
