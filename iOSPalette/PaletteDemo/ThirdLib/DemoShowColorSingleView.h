//
//  DemoShowColorSingleView.h
//  iOSPalette
//
//  Created by 凡铁 on 17/6/6.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaletteColorModel.h"

@interface DemoShowColorViewCell : UICollectionViewCell

- (void)configureData:(PaletteColorModel*)model andKey:(NSString*)modeKey;

@end
