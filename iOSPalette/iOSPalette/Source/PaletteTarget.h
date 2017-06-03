//
//  TRIPPaletteTarget.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PaletteTargetMode) {
    LIGHT_VIBRANT_PALETTE = 0,
    VIBRANT_PALETTE = 1,
    DARK_VIBRANT_PALETTE = 2,
    LIGHT_MUTED_PALETTE = 3,
    MUTED_PALETTE = 4,
    DARK_MUTED_PALETTE = 5
};

@interface PaletteTarget : NSObject

- (instancetype)initWithTargetMode:(PaletteTargetMode)mode;

- (float)getMinSaturation;

- (float)getMaxSaturation;

- (float)getMinLuma;

- (float)getMaxLuma;

- (float)getSaturationWeight;

- (float)getLumaWeight;

- (float)getPopulationWeight;

- (float)getTargetSaturation;

- (float)getTargetLuma;

- (NSString*)getTargetKey;

- (void)normalizeWeights;


@end
