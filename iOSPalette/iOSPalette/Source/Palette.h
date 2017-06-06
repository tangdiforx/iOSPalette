//
//  TRIPPalette.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PaletteTarget.h"

static const NSInteger kMaxColorNum = 16;

typedef void(^GetColorBlock)(NSInteger colorInt,NSString *colorString,UIColor *color);



@interface Palette : NSObject

- (instancetype)initWithImage:(UIImage*)image;

- (void)startToAnalyzeImage:(GetColorBlock)block;

//you can use '|' to separate every target mode ,eg :"DARK_VIBRANT_PALETTE | VIBRANT_PALETTE"
- (void)startToAnalyzeImage:(GetColorBlock)block forTargetMode:(PaletteTargetMode)mode;

@end



@interface VBox : NSObject

- (NSInteger)getVolume;

@end
