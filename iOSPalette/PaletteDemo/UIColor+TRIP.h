//
//  UIColor+TRIP.h
//  TRIPKit
//
//  Created by bennyguan on 14-6-25.
//  Copyright (c) 2014年 Taobao Trip. All rights reserved.
//
//  该类是为了扩充系统UIColor类而建立的Category，在该类中，实现了包括16进制颜色识别，
//  颜色转图片等多个方法。

#import <UIKit/UIKit.h>

@interface UIColor (TRIP)

//颜色分量提取，即R,G,B,A，请保证当前颜色域为RGB模式，否则无法获取
@property (nonatomic, assign, readonly) CGFloat red;
@property (nonatomic, assign, readonly) CGFloat green;
@property (nonatomic, assign, readonly) CGFloat blue;
@property (nonatomic, assign, readonly) CGFloat alpha;

/*!
 *  使用16进制来设置颜色,支持16进制中的alpha值，eg. 0xff00ff00 rgba
 *
 *  @param hex 16进制颜色值
 *
 *  @return UIColor对象
 */
+(UIColor*)colorWithRGBA:(NSUInteger)hex;

/*!
 *  使用16进制来设置颜色,支持16进制中的alpha值，eg. 0xrrggbb
 *
 *  @param rgbValue 16进制颜色值
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorFromRGB:(NSInteger)rgbValue;

/*!
 *  使用16进制来设置颜色，不支持16进制中的alpha值，eg. #ff0000
 *
 *  @param hexString 16进制颜色值
 *  @param alpha     透明度［0～1］
 *
 *  @return UIColor对象
 */
+ (UIColor*)colorWithRGB:(NSUInteger)hex
                  alpha:(CGFloat)alpha;

/*!
 *  使用16进制的字符串来设置颜色，eg. #ffffff
 *
 *  @param hexString 16进制形式的字符串
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/*!
 *  使用16进制的字符串来设置颜色,eg. #ffffff
 *
 *  @param hexString 16进制形式的字符串
 *  @param alpha     透明度[0~1]
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * hexString eg. #ffffffff(ARGB格式)
 */
+ (UIColor *)colorWithHexStringWithAlphaARGB:(NSString*)hexString;

+ (UIColor *)colorWithHexStringWithAlpha:(NSString*)hexString;

/*!
 *  颜色转图片
 *
 *  @return 返回一张CGRect(0,0,1,1)的图片
 */
-(UIImage*)image;

/*!
 *  颜色转图片，并允许设置尺寸
 *
 *  @param size 尺寸
 *
 *  @return 返回一张的图片
 */
-(UIImage*)imageWithSize:(CGSize)size;

-(UIImage*)imageWithMask:(UIColor*)color;

@end
