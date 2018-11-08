//
//  UIView+UIView_Snapshot.m
//  Youxin
//
//  Created by yanghongyan on 16/11/15.
//  Copyright (c) 2016年 kmyhy. All rights reserved.
//

#import "UIView+snapshot.h"

@implementation UIView (UIView_Snapshot)

-(UIImage*)snapshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
}
@end
