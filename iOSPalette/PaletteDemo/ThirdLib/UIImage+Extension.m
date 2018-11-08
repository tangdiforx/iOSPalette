//
//  UIImage-Extensions.m
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//

#import "UIImage+Extension.h"
#import "UIView+snapshot.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (CS_Extensions)
/// 缩放图片尺寸
- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
/// 等比缩放图片尺寸
- (UIImage*)scaleToSizeKeepAspect:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGFloat ws = size.width/self.size.width;
    CGFloat hs = size.height/self.size.height;
    
    if (ws > hs) {
        ws = hs/ws;
        hs = 1.0;
    } else {
        hs = ws/hs;
        ws = 1.0;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(size.width/2-(size.width*ws)/2,
                                           size.height/2-(size.height*hs)/2, size.width*ws,
                                           size.height*hs), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/// 按固定比例缩放，不管图片有多大，保持比例
- (UIImage *)scaledToScale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// Transform the image in grayscale.
- (UIImage*) grayishImage{
    
    // Create a graphic context.
    UIGraphicsBeginImageContextWithOptions(self.size, YES, 1.0);
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [self drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
    
}

-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
//    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
// 着色，将位图和指定色（即参数 color）执行像素相乘。即原图为 0 的像素（黑色）舍弃，为 1（白色）的像素替换为 color。注意位图需要是透明图，可以用 transparentRetainRGBColor 方法创建透明图
- (UIImage *)colorImage:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
// 创建一张透明图，只保留指定颜色（color），其他颜色丢弃
-(UIImage*)transparentRetainRGBColor:(UIColor*)color{
    // color 必须是 rgb 颜色空间，不能是灰度空间（比如黑色）

    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r=components[0];
    CGFloat g=components[1];
    CGFloat b=components[2];

    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        uint8_t* ptr = (uint8_t*)pCurPtr;
        if (ptr[1] == b && ptr[2] == g && ptr[3] == r)    // 将黑色保留
        {
            ptr[0] = 0xff;
        }
        else // 其他颜色丢弃
        {
            ptr[0] = 0;
            
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
// 反相着色。将位图中没有颜色值（黑色）的像素填充为指定色，其他颜色保留。
- (UIImage*)reverseColorImage:(UIColor*)color{
    //  保留黑色，其他颜色丢弃，注意黑色必须用 colorWithRed:green:blue:alpha 创建（rgb空间），不能用 [UIColor blackColor] 创建（灰度空间）。
    UIImage* image = [self transparentRetainRGBColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    image = [image colorImage:color];
    return image;
}
//
// 生成二维码
+ (UIImage*)imageWithErweima:(NSString *)erweima size:(CGSize)size{
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];    //恢复滤镜的默认属性
    
    NSData *data=[erweima dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage=[filter outputImage];// 输出滤镜结果图像
    
    CGRect extent = CGRectIntegral(outputImage.extent); // 获取整数 frame,避免图像模糊
    // 计算需要缩放的倍数 scale
    CGFloat x_scale = size.width/CGRectGetWidth(extent);
    CGFloat y_scale = size.height/CGRectGetHeight(extent);
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();// 创建灰度颜色空间（没必要使用 rgb 空间）
    
    // 创建 Core Graphics 上下文——用于绘图操作
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, extent.size.width * x_scale, extent.size.height * y_scale, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CGColorSpaceRelease(cs);
    
    CIContext *context = [CIContext contextWithOptions:nil]; // Core Image 上下文
    
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    
    // 允许上下文在各个保真度等级插入像素，kCGInterpolationNone-不插入,避免图像模糊
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);//kCGInterpolationHigh
    
    CGContextScaleCTM(bitmapRef, x_scale, y_scale);// x,y 缩放
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);// 开始绘图
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    UIImage *image=[UIImage imageWithCGImage:scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}
// 如果图片超过指定大小，则压缩到指定大小，否则不压缩
-(UIImage*)scaleToMaxSizeKeepAspect:(CGSize)size{
    
    if(self.size.width>size.width || self.size.height > size.height){
        return [self scaleToSizeKeepAspect:size];
    }
    return self;// 返回原图
}
// 按照矩形裁剪图片
- (UIImage *)cutWithRect:(CGRect )rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect rect1 = CGRectMake(rect.origin.x*scale, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect1);
    
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return img;
    
}
-(CGSize)getImageSize{
    CGImageRef cgImage = [self CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    return CGSizeMake(width, height);
}
@end;
