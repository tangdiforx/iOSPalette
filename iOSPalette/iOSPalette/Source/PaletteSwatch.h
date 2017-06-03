//
//  TRIPPaletteSwatch.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PaletteSwatch : NSObject

- (instancetype)initWithColorInt:(NSInteger)colorInt population:(NSInteger)population;

- (UIColor*)getColor;

//ColorInt
- (NSInteger)getRGB;

//eg:"#FF3000"
- (NSString*)getColorString;

//ColorInt
- (NSInteger)getTitleTextColor;

//ColorInt
- (NSInteger)getBodyTextColor;

- (NSArray*)getHsl;

- (NSInteger)getPopulation;


@end
