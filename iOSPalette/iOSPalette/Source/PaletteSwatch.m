//
//  TRIPPaletteSwatch.m
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "PaletteSwatch.h"

@interface PaletteSwatch ()

@property (nonatomic,assign) NSInteger red;

@property (nonatomic,assign) NSInteger green;

@property (nonatomic,assign) NSInteger blue;

@property (nonatomic,assign) NSInteger population;// the number of pixel

@end

@implementation PaletteSwatch

#pragma mark - getter

- (instancetype)initWithColorInt:(NSInteger)colorInt population:(NSInteger)population{
    self = [super init];
    if (self){
        _red = [self approximateRed:colorInt];
        _green = [self approximateGreen:colorInt];
        _blue = [self approximateBlue:colorInt];
        _population = population;
    }
    return self;
}


- (NSInteger)getPopulation{
    return _population;
}

/**
 * Return this swatch's HSL values.
 *     hsl[0] is Hue [0 .. 360)
 *     hsl[1] is Saturation [0...1]
 *     hsl[2] is Lightness [0...1]
 */
- (NSArray*)getHsl{

    float rf,gf,bf;
    
    rf = (float)_red /255.0f, gf =  (float)_green / 255, bf = (float)_blue / 255;
    float max,min;
    max = MAX(rf, gf) > bf?MAX(rf, gf):bf;
    min = MIN(rf, gf) < bf?MIN(rf, gf):bf;
    float deltaMaxMin = max - min;
    
    float l = (max+min)/2.0;
    float h,s;
    
    if(max == min){
        h = s = 0.0F;
    }else{
        if (max == rf){
//            h = (gf - bf)/deltaMaxMin % 6.0F;
        }else{
            if (max == gf){
                h = (bf - rf)/deltaMaxMin + 2.0F;
            }else{
                h = (rf - gf)/deltaMaxMin + 4.0F;
            }
        }
    }
    s = deltaMaxMin / (1.0f - fabsf(2.0f * l - 1.0f));
    
//    h = h * 60.0F % 360.0F;
    if (h<0.0F){
        h += 360.0F;
    }
    NSArray *hsl = @[[NSNumber numberWithFloat:constrain(h, 0.0F, 360.0F)],[NSNumber numberWithFloat:constrain(s, 0.0F, 1.0F)],[NSNumber numberWithFloat:constrain(l, 0.0F, 1.0F)]];
    return hsl;
}

float constrain(float amount,float low,float high){
    return amount > high ? high : amount < low ? low : amount;
}

- (NSInteger)approximateRed:(NSInteger)color{
    return (color >> (8 + 8)) & ((1 << 8) - 1);
}

- (NSInteger)approximateGreen:(NSInteger)color{
    return color >> 8 & ((1 << 8) - 1);
}

- (NSInteger)approximateBlue:(NSInteger)color{
    return color  & ((1 << 8) - 1);
}

- (NSString*)getTitleTextColorString{
    return @"TODO";
}

- (NSString*)getBodyTextColorString{
    return @"TODO";
}

- (NSString*)getColorString{
    NSString *colorString = [NSString stringWithFormat:@"#%02lx%02lx%02lx",_red,_green,_blue];
    return colorString;
}

- (UIColor*)getColor{
    UIColor *color = [UIColor colorWithRed:(CGFloat)_red/255 green:(CGFloat)_green/255 blue:(CGFloat)_blue/255 alpha:1];
    return color;
}

@end
