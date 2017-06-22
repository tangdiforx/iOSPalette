//
//  PaletteColorModel.h
//  iOSPalette
//
//  Created by 凡铁 on 17/6/6.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PaletteColorModel : NSObject

/** ColorHexString eg:"#FFC300" */
@property (nonatomic,copy) NSString *imageColorString;

/** the percentage of the color,default value is 0 */
@property (nonatomic,assign) CGFloat percentage;

/** TitleTextColorStirng */
//@property (nonatomic,copy) NSString *titleTextColorString;

/** bodyTextColorString */
//@property (nonatomic,copy) NSString *bodyTextColorString;

@end
