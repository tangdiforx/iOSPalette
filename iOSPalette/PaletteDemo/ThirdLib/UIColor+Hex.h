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

@interface UIColor (Hex)

//颜色分量提取，即R,G,B,A，请保证当前颜色域为RGB模式，否则无法获取
@property (nonatomic, assign, readonly) CGFloat red;
@property (nonatomic, assign, readonly) CGFloat green;
@property (nonatomic, assign, readonly) CGFloat blue;
@property (nonatomic, assign, readonly) CGFloat alpha;


/*!
 *  使用16进制的字符串来设置颜色，eg. #ffffff
 *
 *  @param hexString 16进制形式的字符串
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
