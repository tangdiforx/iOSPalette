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
@property (nonatomic,copy) NSString *colorHexString;

/** ColorInt eg:"0xFFC300" */
@property (nonatomic,assign) NSInteger colorInt;

/** UIColor */
@property (nonatomic,strong) UIColor *color;

@end
