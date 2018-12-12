//
//  UIColor+Complementary.h
//  
//
//  Created by kmyhy on 2018/11/7.
//  Copyright © 2018年 kmyhy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Complementary)
// MARK: 计算互补色
-(UIColor*)complementaryColor;
// MARK: 黑白互补色
-(UIColor*)blackWhiteComplementaryColor;
@end

NS_ASSUME_NONNULL_END
