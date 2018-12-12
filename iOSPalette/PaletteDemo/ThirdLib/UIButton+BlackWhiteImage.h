//
//  UIButton+BlackWhiteImage.h
//  PaletteDemo
//
//  Created by yhy on 2018/11/8.
//  Copyright © 2018年 kmyhy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BlackWhiteImage)

// 根据一张背景图片生成一张对比强烈的黑白色图片作为 button 的 image
-(void)setBlackWhiteImageWithImage:(UIImage*)image backgroundImage:(UIImage*)bgImage;
/**
 根据背景 view 中的某个区域设置 button 的 image(白或黑）
 @image     button 的 image
 @bgView    button 的背景 view
 @rect      button 在背景 view 上所占据的区域
 **/
-(void)setBlackWhiteImageWithImage:(UIImage*)image backgroundView:(UIView*)bgView withRect:(CGRect)rect;
/**
 上一方法的简化版，最后一个参数自动计算。假设 button 和 backgroundView 是同一个 parent view。
 */
-(void)setBlackWhiteImageWithImage:(UIImage*)image backgroundView:(UIView*)bgView;
@end

NS_ASSUME_NONNULL_END
