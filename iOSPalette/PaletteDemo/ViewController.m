//
//  ViewController.m
//  PaletteDemo
//
//  Created by 凡铁 on 17/6/1.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"
#import "Palette.h"
#import "UIImage+Palette.h"
#import "UIColor+Hex.h"
#import "UIView+Geometry.h"
#import "DemoShowColorSingleView.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign) CGFloat screenWidth;

@property (nonatomic,assign) CGFloat screenHeight;

@property (nonatomic,strong) UIButton *chooseImageBtn;

@property (nonatomic,strong) UIImageView *chooseImageView;

@property (nonatomic,strong) UIView *chooseImageColorView;

@property (nonatomic,strong) UILabel *showColorLabel;

@property (nonatomic,strong) ALAssetsLibrary *assetLibrary;

/** ColorDisplayView */
@property (nonatomic,strong) UICollectionView *colorDisplayView;

@property (nonatomic,copy) NSDictionary *allModeColorDic;

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
    _chooseImageBtn.frame = CGRectMake((_screenWidth - _chooseImageBtn.bounds.size.width)/2, 50.0f, _chooseImageBtn.bounds.size.width,  _chooseImageBtn.bounds.size.height);
    [_chooseImageBtn addTarget:self action:@selector(goToChooseImage) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_chooseImageBtn];
    
    CGFloat imageWidth = _screenWidth - 2 * 50.0f;
    _chooseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50.0f,_chooseImageBtn.bottom + 20.0f , imageWidth, imageWidth)];
    _chooseImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_chooseImageView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing      = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    
    _colorDisplayView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0f,_chooseImageView.bottom + 30.0f, self.view.width, _screenHeight - (_chooseImageView.bottom + 30.0f)) collectionViewLayout:flowLayout];
    _colorDisplayView.backgroundColor = [UIColor clearColor];
    [_colorDisplayView registerClass:[DemoShowColorViewCell class] forCellWithReuseIdentifier:@"colorCell"];
    _colorDisplayView.delegate = self;
    _colorDisplayView.dataSource = self;
    [self.view addSubview:_colorDisplayView];
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
        CGImageRef fullRef = asset.defaultRepresentation.fullResolutionImage;
        UIImage *image =  [UIImage imageWithCGImage:fullRef];
        weakSelf.chooseImageView.image = image;
                
        [image getPaletteImageColorWithMode:ALL_MODE_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic,NSError *error) {
            
            if (!recommendColor){
                weakSelf.showColorLabel.text = @"识别失败";
                return;
            }
            
            weakSelf.allModeColorDic = allModeColorDic;
            [weakSelf.colorDisplayView reloadData];
        }];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"出错了");
    }];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DemoShowColorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    
    if (!cell){
        cell = [[DemoShowColorViewCell alloc]init];
    }
    PaletteColorModel *colorModel;
    NSString *modeKey;
    switch (indexPath.row) {
        case 0:
            colorModel = [self.allModeColorDic objectForKey:@"vibrant"];
            modeKey = @"vibrant";
            break;
        case 1:
            colorModel = [self.allModeColorDic objectForKey:@"muted"];
            modeKey = @"muted";
            break;
        case 2:
            colorModel = [self.allModeColorDic objectForKey:@"light_vibrant"];
            modeKey = @"light_vibrant";
            break;
        case 3:
            colorModel = [self.allModeColorDic objectForKey:@"light_muted"];
            modeKey = @"light_muted";
            break;
        case 4:
            colorModel = [self.allModeColorDic objectForKey:@"dark_vibrant"];
            modeKey = @"dark_vibrant";
            break;
        case 5:
            colorModel = [self.allModeColorDic objectForKey:@"dark_muted"];
            modeKey = @"dark_muted";
            break;
            
        default:
            break;
    }
    [cell configureData:colorModel andKey:modeKey];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.width / 2 , collectionView.height/3);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allModeColorDic.count;
}
#pragma mark - lazyinit
- (ALAssetsLibrary*)assetLibrary{
    if (!_assetLibrary){
        _assetLibrary = [[ALAssetsLibrary alloc]init];
    }
    return _assetLibrary;
}

@end
