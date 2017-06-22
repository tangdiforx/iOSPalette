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

/** showPercentageLabel */
@property (nonatomic,strong) UILabel *showPercentageLabel;

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
        _showColorLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_showColorLabel];
        
        _showPercentageLabel = [[UILabel alloc]init];
        _showPercentageLabel.textColor = [UIColor whiteColor];
        _showPercentageLabel.shadowColor = [UIColor darkGrayColor];
        _showPercentageLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _showPercentageLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_showPercentageLabel];
    }
    return self;
}

- (void)configureData:(PaletteColorModel*)model andKey:(NSString *)modeKey{
    NSString *showText;
    NSString *percentageText;
    if (![model isKindOfClass:[PaletteColorModel class]]){
        showText = [NSString stringWithFormat:@"%@:识别失败",modeKey];
    }else{
        showText = [NSString stringWithFormat:@"%@:%@",modeKey,model.imageColorString];
        percentageText = [NSString stringWithFormat:@"%.1f%@",model.percentage*100,@"%"];
        self.backgroundColor = [UIColor colorWithHexString:model.imageColorString];
    }
    _showColorLabel.text = showText;
    [_showColorLabel sizeToFit];
    _showColorLabel.origin = CGPointMake((self.width - _showColorLabel.width)/2, (self.height - _showColorLabel.height)/2);
    
    _showPercentageLabel.text = percentageText;
    [_showPercentageLabel sizeToFit];
    _showPercentageLabel.origin = CGPointMake((self.width - _showPercentageLabel.width)/2, _showColorLabel.bottom + 5.0f);
}

@end
