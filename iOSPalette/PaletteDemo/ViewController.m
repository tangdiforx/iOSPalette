//
//  ViewController.m
//  PaletteDemo
//
//  Created by 凡铁 on 17/6/1.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import "ViewController.h"
#import "Palette.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Palette.h"
#import "UIColor+TRIP.h"


@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) CGFloat screenWidth;

@property (nonatomic,assign) CGFloat screenHeight;

@property (nonatomic,strong) UIButton *chooseImageBtn;

@property (nonatomic,strong) UIImageView *chooseImageView;

@property (nonatomic,strong) UIView *chooseImageColorView;

@property (nonatomic,strong) UILabel *showColorLabel;

@property (nonatomic,strong) ALAssetsLibrary *assetLibrary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initParams];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParams{
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _chooseImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_chooseImageBtn setTitle:@"选择照片" forState:UIControlStateNormal];
    [_chooseImageBtn sizeToFit];
    _chooseImageBtn.frame = CGRectMake((_screenWidth - _chooseImageBtn.bounds.size.width)/2, 100.0f, _chooseImageBtn.bounds.size.width,  _chooseImageBtn.bounds.size.height);
    [_chooseImageBtn addTarget:self action:@selector(goToChooseImage) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_chooseImageBtn];
    
    _chooseImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.screenWidth - 200.0f)/2, 200.0f, 200.0f, 200.0f)];
    _chooseImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_chooseImageView];
    
    _chooseImageColorView = [[UIView alloc]initWithFrame:CGRectMake((self.screenWidth - 100.0f)/2, 420.0f, 100.0f, 100.0f)];
    [self.view addSubview:_chooseImageColorView];
    
    _showColorLabel = [[UILabel alloc]init];
    _showColorLabel.textColor = [UIColor grayColor];
    _showColorLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:_showColorLabel];
}

- (void)goToChooseImage{
    
    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];

    NSString *type = [info objectForKey:@"UIImagePickerControllerMediaType"];
    if (![type isEqualToString:@"public.image"]){
        NSLog(@"请选择图片格式");
    }
    NSURL *assetUrl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    if (!assetUrl){
        NSLog(@"出现未知错误");
    }
    
    __weak typeof (self) weakSelf = self;
    [self.assetLibrary assetForURL:assetUrl resultBlock:^(ALAsset *asset) {
        NSLog(@"thread是%@",[NSThread currentThread]);
        CGImageRef fullRef = asset.defaultRepresentation.fullResolutionImage;
        UIImage *image =  [UIImage imageWithCGImage:fullRef];
        weakSelf.chooseImageView.image = image;
        [image getPaletteImageColorWithMode:ALL_MODE_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic) {
            if (!recommendColor){
                weakSelf.showColorLabel.text = @"识别失败";
                return;
            }
            weakSelf.chooseImageColorView.backgroundColor = [UIColor colorWithHexString:recommendColor.imageColorString];
            weakSelf.showColorLabel.text = recommendColor.imageColorString;
            [weakSelf.showColorLabel sizeToFit];
            weakSelf.showColorLabel.frame = CGRectMake((weakSelf.screenWidth - weakSelf.showColorLabel.bounds.size.width)/2, 530.0f,weakSelf.showColorLabel.bounds.size.width,weakSelf.showColorLabel.bounds.size.height);
        }];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"出错了出错了");
    }];
}

- (ALAssetsLibrary*)assetLibrary{
    if (!_assetLibrary){
        _assetLibrary = [[ALAssetsLibrary alloc]init];
    }
    return _assetLibrary;
}

@end
