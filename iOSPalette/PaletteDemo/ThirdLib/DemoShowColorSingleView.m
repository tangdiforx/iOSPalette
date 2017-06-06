//
//  DemoShowColorSingleView.m
//  iOSPalette
//
//  Created by 凡铁 on 17/6/6.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import "DemoShowColorSingleView.h"
#import "UIView+Geometry.h"
#import "UIColor+Hex.h"

@interface DemoShowColorViewCell ()

/** showColorLabel */
@property (nonatomic,strong) UILabel *showColorLabel;

@end

@implementation DemoShowColorViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor darkGrayColor];
        
        _showColorLabel = [[UILabel alloc]init];
        _showColorLabel.textColor = [UIColor whiteColor];
        _showColorLabel.shadowColor = [UIColor darkGrayColor];
        _showColorLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _showColorLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:_showColorLabel];
    }
    return self;
}

- (void)configureData:(PaletteColorModel*)model andKey:(NSString *)modeKey{
    NSString *showText;
    if (![model isKindOfClass:[PaletteColorModel class]]){
        showText = [NSString stringWithFormat:@"%@:识别失败",modeKey];
    }else{
        showText = [NSString stringWithFormat:@"%@:%@",modeKey,model.imageColorString];
        self.backgroundColor = [UIColor colorWithHexString:model.imageColorString];
    }
    _showColorLabel.text = showText;
    [_showColorLabel sizeToFit];
    _showColorLabel.origin = CGPointMake((self.width - _showColorLabel.width)/2, (self.height - _showColorLabel.height)/2);
}

@end
