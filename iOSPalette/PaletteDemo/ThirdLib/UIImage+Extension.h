//
//  UIImage-Extensions.h
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (CS_Extensions)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage*) grayishImage;
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)scaleToSizeKeepAspect:(CGSize)size;
- (UIImage *)scaledToScale:(CGFloat)scale;
- (UIImage *)colorImage:(UIColor *)color;
-(UIImage*)transparentRetainRGBColor:(UIColor*)color;
- (UIImage*)reverseColorImage:(UIColor*)color;
+ (UIImage *)imageWithErweima:(NSString*)erweima size:(CGSize)size;
// 如果图片超过指定大小，则压缩到指定大小，否则不压缩
-(UIImage*)scaleToMaxSizeKeepAspect:(CGSize)size;
// MARK: 按照矩形裁剪图片
- (UIImage *)cutWithRect:(CGRect )rect;
// MARK: 获取图片大小
-(CGSize)getImageSize;
@end;
