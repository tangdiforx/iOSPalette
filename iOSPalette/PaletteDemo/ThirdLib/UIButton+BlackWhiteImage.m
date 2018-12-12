//
//  UIButton+BlackWhiteImage.m
//  PaletteDemo
//
//  Created by yhy on 2018/11/8.
//  Copyright © 2018年 kmyhy. All rights reserved.
//

#import "UIButton+BlackWhiteImage.h"
#import "UIImage+Palette.h"
#import "UIColor+Complementary.h"
#import "UIColor+Hex.h"
#import "UIImage+Extension.h"
#import "UIView+snapshot.h"

@implementation UIButton (BlackWhiteImage)
-(void)setBlackWhiteImageWithImage:(UIImage*)image backgroundImage:(UIImage*)bgImage{
    [bgImage getPaletteImageColor:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
        UIColor* color = [UIColor colorWithHexString:recommendColor.imageColorString];
        UIColor* complementaryColor = [color blackWhiteComplementaryColor];
        UIImage* colorImage = [image colorImage:complementaryColor];
        [self setImage:colorImage forState:UIControlStateNormal];
    }];
}
-(void)setBlackWhiteImageWithImage:(UIImage*)image backgroundView:(UIView*)bgView withRect:(CGRect)rect{
    UIImage* snapshot = [bgView snapshot];
    snapshot = [snapshot cutWithRect:rect];
    [self setBlackWhiteImageWithImage:image backgroundImage:snapshot];
}

-(void)setBlackWhiteImageWithImage:(UIImage*)image backgroundView:(UIView*)bgView{
    CGRect r = [self convertRect:self.bounds toView:bgView];
    [self setBlackWhiteImageWithImage:image backgroundView:bgView withRect:r];
}
@end
