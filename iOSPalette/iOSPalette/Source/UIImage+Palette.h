//
//  UIImage+Palette.h
//  Atom
//
//  Created by dylan.tang on 17/4/20.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"

@interface UIImage (Palette)

- (void)getImageColor:(GetColorBlock)block;

@end
