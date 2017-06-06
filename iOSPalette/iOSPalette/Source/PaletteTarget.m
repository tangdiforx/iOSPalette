//
//  TRIPPaletteTarget.m
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "PaletteTarget.h"

const float TARGET_DARK_LUMA = 0.26f;
const float MAX_DARK_LUMA = 0.45f;

const float MIN_LIGHT_LUMA = 0.55f;
const float TARGET_LIGHT_LUMA = 0.74f;

const float MIN_NORMAL_LUMA = 0.3f;
const float TARGET_NORMAL_LUMA = 0.5f;
const float MAX_NORMAL_LUMA = 0.7f;

const float TARGET_MUTED_SATURATION = 0.3f;
const float MAX_MUTED_SATURATION = 0.4f;

const float TARGET_VIBRANT_SATURATION = 1.0f;
const float MIN_VIBRANT_SATURATION = 0.35f;

const float WEIGHT_SATURATION = 0.24f;
const float WEIGHT_LUMA = 0.52f;
const float WEIGHT_POPULATION = 0.24f;

const NSInteger INDEX_MIN = 0;
const NSInteger INDEX_TARGET = 1;
const NSInteger INDEX_MAX = 2;

const NSInteger INDEX_WEIGHT_SAT = 0;
const NSInteger INDEX_WEIGHT_LUMA = 1;
const NSInteger INDEX_WEIGHT_POP = 2;

@interface PaletteTarget()

@property (nonatomic,strong) NSMutableArray *saturationTargets;

@property (nonatomic,strong) NSMutableArray *lightnessTargets;

@property (nonatomic,strong) NSMutableArray* weights;

@property (nonatomic,assign) BOOL isExclusive; // default to true

@property (nonatomic,assign) PaletteTargetMode mode;

@end

@implementation PaletteTarget

- (instancetype)initWithTargetMode:(PaletteTargetMode)mode{
    self = [super init];
    if (self){
        _mode = mode;
        [self initParams];
        [self configureLumaAndSaturationWithMode:mode];
    }
    return self;
}

- (void)initParams{
    _saturationTargets = [[NSMutableArray alloc]init];
    _lightnessTargets = [[NSMutableArray alloc]init];
    _weights = [[NSMutableArray alloc]init];
    
    [self setDefaultWeights];
    [self setDefaultLuma];
    [self setDefaultSaturation];
}

#pragma mark - configure luma and saturation with mode

- (void)configureLumaAndSaturationWithMode:(PaletteTargetMode)mode{
    switch (mode) {
        case LIGHT_VIBRANT_PALETTE:
            [self setDefaultLightLuma];
            [self setDefaultVibrantSaturation];
            break;
        case VIBRANT_PALETTE:
            [self setDefaultNormalLuma];
            [self setDefaultVibrantSaturation];
            break;
        case DARK_VIBRANT_PALETTE:
            [self setDefaultDarkLuma];
            [self setDefaultVibrantSaturation];
            break;
        case LIGHT_MUTED_PALETTE:
            [self setDefaultLightLuma];
            [self setDefaultMutedSaturation];
            break;
        case MUTED_PALETTE:
            [self setDefaultNormalLuma];
            [self setDefaultMutedSaturation];
            break;
        case DARK_MUTED_PALETTE:
            [self setDefaultDarkLuma];
            [self setDefaultMutedSaturation];
            break;
        default:
            break;
    }
}

- (void)setDefaultWeights{
    [_weights addObject:[NSNumber numberWithFloat:WEIGHT_SATURATION]];
    [_weights addObject:[NSNumber numberWithFloat:WEIGHT_LUMA]];
    [_weights addObject:[NSNumber numberWithFloat:WEIGHT_POPULATION]];
}

- (void)setDefaultLuma{
    [_lightnessTargets addObject:[NSNumber numberWithFloat:0.0f]];
    [_lightnessTargets addObject:[NSNumber numberWithFloat:0.5f]];
    [_lightnessTargets addObject:[NSNumber numberWithFloat:1.0f]];
}

- (void)setDefaultSaturation{
    [_saturationTargets addObject:[NSNumber numberWithFloat:0.0f]];
    [_saturationTargets addObject:[NSNumber numberWithFloat:0.5f]];
    [_saturationTargets addObject:[NSNumber numberWithFloat:1.0f]];
}

- (void)setDefaultLightLuma{
    _lightnessTargets[INDEX_MIN] = [NSNumber numberWithFloat:MIN_LIGHT_LUMA];
    _lightnessTargets[INDEX_TARGET] = [NSNumber numberWithFloat:TARGET_LIGHT_LUMA];
}

- (void)setDefaultNormalLuma{
    _lightnessTargets[INDEX_MIN] = [NSNumber numberWithFloat:MIN_NORMAL_LUMA];
    _lightnessTargets[INDEX_TARGET] = [NSNumber numberWithFloat:TARGET_NORMAL_LUMA];
    _lightnessTargets[INDEX_MAX] = [NSNumber numberWithFloat:MAX_NORMAL_LUMA];
}

- (void)setDefaultDarkLuma{
    _lightnessTargets[INDEX_TARGET] = [NSNumber numberWithFloat:TARGET_DARK_LUMA];
    _lightnessTargets[INDEX_MAX] = [NSNumber numberWithFloat:MAX_DARK_LUMA];
}

- (void)setDefaultMutedSaturation{
    _saturationTargets[INDEX_TARGET] = [NSNumber numberWithFloat:TARGET_MUTED_SATURATION];
    _saturationTargets[INDEX_MAX] = [NSNumber numberWithFloat:MAX_MUTED_SATURATION];
}

- (void)setDefaultVibrantSaturation{
    _saturationTargets[INDEX_MIN] = [NSNumber numberWithFloat:MIN_VIBRANT_SATURATION];
    _saturationTargets[INDEX_TARGET] = [NSNumber numberWithFloat:TARGET_VIBRANT_SATURATION];
}

#pragma mark - getter

- (float)getMinSaturation{
    return [_saturationTargets[INDEX_MIN] floatValue];
}

- (float)getMaxSaturation{
    NSInteger maxIndex;
    maxIndex = MIN(INDEX_MAX, _saturationTargets.count - 1);
    return [_saturationTargets[maxIndex] floatValue];
}

- (float)getMinLuma{
    return [_lightnessTargets[INDEX_MIN] floatValue];
}

- (float)getMaxLuma{
    NSInteger maxIndex;
    maxIndex = INDEX_MAX>=_lightnessTargets.count?_lightnessTargets.count:INDEX_MAX;
    return [_lightnessTargets[maxIndex] floatValue];

}

- (float)getSaturationWeight{
    return [_weights[INDEX_WEIGHT_SAT] floatValue];
}

- (float)getLumaWeight{
    return [_weights[INDEX_WEIGHT_LUMA] floatValue];

}

- (float)getPopulationWeight{
    return [_weights[INDEX_WEIGHT_POP] floatValue];

}

- (float)getTargetSaturation{
    return [_saturationTargets[INDEX_TARGET] floatValue];
}

- (float)getTargetLuma{
    return [_lightnessTargets[INDEX_TARGET] floatValue];
}
#pragma mark - utils

- (NSString*)getTargetKey{
    return [PaletteTarget getTargetModeKey:_mode];
}


+ (NSString*)getTargetModeKey:(PaletteTargetMode)mode{
    NSString *key;
    switch (mode) {
        case LIGHT_VIBRANT_PALETTE:
            key = @"light_vibrant";
            break;
        case VIBRANT_PALETTE:
            key = @"vibrant";
            break;
        case DARK_VIBRANT_PALETTE:
            key = @"dark_vibrant";
            break;
        case LIGHT_MUTED_PALETTE:
            key = @"light_muted";
            break;
        case MUTED_PALETTE:
            key = @"muted";
            break;
        case DARK_MUTED_PALETTE:
            key = @"dark_muted";
            break;
        default:
            break;
    }
    return key;
}

- (void)normalizeWeights{
    float sum = 0;
    for (NSUInteger i = 0, z = [_weights count]; i < z; i++) {
        float weight = [_weights[i] floatValue];
        if (weight > 0) {
            sum += weight;
        }
    }
    if (sum != 0) {
        for (NSUInteger i = 0, z = [_weights count]; i < z; i++) {
            if ([_weights[i] floatValue] > 0) {
                float weight = [_weights[i] floatValue];
                weight /= sum;
                _weights[i] = [NSNumber numberWithFloat:weight];
            }
        }
    }
}

@end
