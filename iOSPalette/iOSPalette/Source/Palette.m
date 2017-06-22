//
//  Palette.m
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "Palette.h"
#import "PaletteSwatch.h"
#import "PaletteColorUtils.h"
#import "PriorityBoxArray.h"

typedef NS_ENUM(NSInteger,COMPONENT_COLOR){
    COMPONENT_RED = 0,
    COMPONENT_GREEN = 1,
    COMPONENT_BLUE = 2
};

const NSInteger QUANTIZE_WORD_WIDTH = 5;
const NSInteger QUANTIZE_WORD_MASK = (1 << QUANTIZE_WORD_WIDTH) - 1;
const CGFloat resizeArea = 160 * 160;

int hist[32768];

@interface VBox()

@property (nonatomic,assign) NSInteger lowerIndex;

@property (nonatomic,assign) NSInteger upperIndex;

@property (nonatomic,strong) NSMutableArray *distinctColors;

@property (nonatomic,assign) NSInteger population;

@property (nonatomic,assign) NSInteger minRed;

@property (nonatomic,assign) NSInteger maxRed;

@property (nonatomic,assign) NSInteger minGreen;

@property (nonatomic,assign) NSInteger maxGreen;

@property (nonatomic,assign) NSInteger minBlue;

@property (nonatomic,assign) NSInteger maxBlue;

@end

@implementation VBox

- (instancetype)initWithLowerIndex:(NSInteger)lowerIndex upperIndex:(NSInteger)upperIndex colorArray:(NSMutableArray*)colorArray{
    self = [super init];
    if (self){
        
        _lowerIndex = lowerIndex;
        _upperIndex = upperIndex;
        _distinctColors = colorArray;
    
        [self fitBox];
        
    }
    return self;
}

- (NSInteger)getVolume{
    NSInteger volume = (_maxRed - _minRed + 1) * (_maxGreen - _minGreen + 1) *
    (_maxBlue - _minBlue + 1);
    return volume;
}

/**
 * Split this color box at the mid-point along it's longest dimension
 *
 * @return the new ColorBox
 */
- (VBox*)splitBox{
    if (![self canSplit]) {
        return nil;
    }
    
    // find median along the longest dimension
    NSInteger splitPoint = [self findSplitPoint];
    
    VBox *newBox = [[VBox alloc]initWithLowerIndex:splitPoint+1 upperIndex:_upperIndex colorArray:_distinctColors];
    
    // Now change this box's upperIndex and recompute the color boundaries
    _upperIndex = splitPoint;
    [self fitBox];
    
    return newBox;
}

- (NSInteger)findSplitPoint{
    NSInteger longestDimension = [self getLongestColorDimension];
    
    // We need to sort the colors in this box based on the longest color dimension.
    // As we can't use a Comparator to define the sort logic, we modify each color so that
    // it's most significant is the desired dimension
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];
    
    [self sortColorArray];
    
    // Now revert all of the colors so that they are packed as RGB again
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];

//    modifySignificantOctet(colors, longestDimension, mLowerIndex, mUpperIndex);
    
    NSInteger midPoint = _population / 2;
    for (NSInteger i = _lowerIndex, count = 0; i <= _upperIndex; i++)  {
        NSInteger population = hist[[_distinctColors[i] intValue]];
        count += population;
        if (count >= midPoint) {
            return i;
        }
    }
    
    return _lowerIndex;
}

- (void)sortColorArray{
    
    // Now sort... Arrays.sort uses a exclusive toIndex so we need to add 1
    
    NSInteger sortCount = (_upperIndex - _lowerIndex) + 1;
    NSInteger sortArray[sortCount];
    NSInteger sortIndex = 0;
    
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        sortArray[sortIndex] = [_distinctColors[index] integerValue];
        sortIndex++;
    }
    
    NSInteger arrayLength = sortIndex;
    
    //bubble sort
    for(NSInteger i = 0; i < arrayLength-1; i++)
    {
        BOOL isSorted = YES;
        for(NSInteger j=0; j<arrayLength-1-i; j++)
        {
            if(sortArray[j] > sortArray[j+1])
            {
                isSorted = NO;
                NSInteger temp = sortArray[j];
                sortArray[j] = sortArray[j+1];
                sortArray[j+1]=temp;
            }
        }
        if(isSorted)
            break;
    }
    
    sortIndex = 0;
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        _distinctColors[index] = [NSNumber numberWithInteger:sortArray[sortIndex]];
        sortIndex++;
    }
}

/**
 * @return the dimension which this box is largest in
 */
- (NSInteger) getLongestColorDimension{
    NSInteger redLength = _maxRed - _minRed;
    NSInteger greenLength = _maxGreen - _minGreen;
    NSInteger blueLength = _maxBlue - _minBlue;
    
    if (redLength >= greenLength && redLength >= blueLength) {
        return COMPONENT_RED;
    } else if (greenLength >= redLength && greenLength >= blueLength) {
        return COMPONENT_GREEN;
    } else {
        return COMPONENT_BLUE;
    }
}

/**
 * Modify the significant octet in a packed color int. Allows sorting based on the value of a
 * single color component. This relies on all components being the same word size.
 *
 * @see Vbox#findSplitPoint()
 */
- (void) modifySignificantOctetWithDismension:(NSInteger)dimension lowerIndex:(NSInteger)lower upperIndex:(NSInteger)upper{
    switch (dimension) {
        case COMPONENT_RED:
            // Already in RGB, no need to do anything
            break;
        case COMPONENT_GREEN:
            // We need to do a RGB to GRB swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor = [PaletteColorUtils quantizedGreen:color] << (QUANTIZE_WORD_WIDTH + QUANTIZE_WORD_WIDTH)
                | [PaletteColorUtils quantizedRed:color]  << QUANTIZE_WORD_WIDTH | [PaletteColorUtils quantizedBlue:color];
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
        case COMPONENT_BLUE:
            // We need to do a RGB to BGR swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor =  [PaletteColorUtils quantizedBlue:color] << (QUANTIZE_WORD_WIDTH + QUANTIZE_WORD_WIDTH)
                | [PaletteColorUtils quantizedGreen:color]  << QUANTIZE_WORD_WIDTH
                | [PaletteColorUtils quantizedRed:color];
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
    }
}

/**
 * @return the average color of this box.
 */
- (PaletteSwatch*)getAverageColor{
    NSInteger redSum = 0;
    NSInteger greenSum = 0;
    NSInteger blueSum = 0;
    NSInteger totalPopulation = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        NSInteger colorPopulation = hist[color];
        
        totalPopulation += colorPopulation;
        
        redSum += colorPopulation * [PaletteColorUtils quantizedRed:color];
        greenSum += colorPopulation * [PaletteColorUtils quantizedGreen:color];
        blueSum += colorPopulation * [PaletteColorUtils quantizedBlue:color];
    }
    
    //in case of totalPopulation equals to 0
    if (totalPopulation <= 0){
        return nil;
    }
    
    NSInteger redMean = redSum / totalPopulation;
    NSInteger greenMean = greenSum / totalPopulation;
    NSInteger blueMean = blueSum / totalPopulation;
    
    redMean = [PaletteColorUtils modifyWordWidthWithValue:redMean currentWidth:QUANTIZE_WORD_WIDTH targetWidth:8];
    greenMean = [PaletteColorUtils modifyWordWidthWithValue:greenMean currentWidth:QUANTIZE_WORD_WIDTH targetWidth:8];
    blueMean = [PaletteColorUtils modifyWordWidthWithValue:blueMean currentWidth:QUANTIZE_WORD_WIDTH targetWidth:8];

    NSInteger rgb888Color = redMean << 2 * 8 | greenMean << 8 | blueMean;
    
    PaletteSwatch *swatch = [[PaletteSwatch alloc]initWithColorInt:rgb888Color population:totalPopulation];
    
    return swatch;
}

- (BOOL)canSplit{
    if ((_upperIndex - _lowerIndex) <= 0){
        return NO;
    }
    return YES;
}

- (void)fitBox{
    
    // Reset the min and max to opposite values
    NSInteger minRed, minGreen, minBlue;
    minRed = minGreen = minBlue = 32768;
    NSInteger maxRed, maxGreen, maxBlue;
    maxRed = maxGreen = maxBlue = 0;
    NSInteger count = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        count += hist[color];
        
        NSInteger r = [PaletteColorUtils quantizedRed:color];
        NSInteger g =  [PaletteColorUtils quantizedGreen:color];
        NSInteger b =  [PaletteColorUtils quantizedBlue:color];
        
        if (r > maxRed) {
            maxRed = r;
        }
        if (r < minRed) {
            minRed = r;
        }
        if (g > maxGreen) {
            maxGreen = g;
        }
        if (g < minGreen) {
            minGreen = g;
        }
        if (b > maxBlue) {
            maxBlue = b;
        }
        if (b < minBlue) {
            minBlue = b;
        }
    }
    
    _minRed = minRed;
    _maxRed = maxRed;
    _minGreen = minGreen;
    _maxGreen = maxGreen;
    _minBlue = minBlue;
    _maxBlue = maxBlue;
    _population = count;
}

@end

@interface Palette ()

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) PriorityBoxArray *priorityArray;

@property (nonatomic,strong) NSArray *swatchArray;

@property (nonatomic,strong) NSArray *targetArray;

@property (nonatomic,assign) NSInteger maxPopulation;

@property (nonatomic,strong) NSMutableArray *distinctColors;

/** the pixel count of the image */
@property (nonatomic,assign) NSInteger pixelCount;

/** callback */
@property (nonatomic,copy) GetColorBlock getColorBlock;

/** specify mode */
@property (nonatomic,assign) PaletteTargetMode mode;

/** needColorDic */
@property (nonatomic,assign) BOOL isNeedColorDic;

@end

@implementation Palette

-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self){
        _image = image;
    }
    return self;
}

#pragma mark - Core code to analyze the main color of a image

- (void)startToAnalyzeImage:(GetColorBlock)block{
    [self startToAnalyzeForTargetMode:DEFAULT_NON_MODE_PALETTE withCallBack:block];
}

- (void)startToAnalyzeForTargetMode:(PaletteTargetMode)mode withCallBack:(GetColorBlock)block{
    [self initTargetsWithMode:mode];
    
    //Check the image is nil or not
    if (!_image){
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation fail", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The image is nill.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the image input please", nil)
                                   };
        NSError *nullImageError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:userInfo];
        block(nil,nil,nullImageError);
        return;
    }
    _getColorBlock = block;
    [self startToAnalyzeImage];
}

- (void)startToAnalyzeImage{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self clearHistArray];
        
        // Get raw pixel data from image
        unsigned char *rawData = [self rawPixelDataFromImage:_image];
        if (!rawData || self.pixelCount <= 0){
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Operation fail", nil),
                                        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The image is nill.", nil),
                                        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the image input please", nil)
                                           };
            NSError *nullImageError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:userInfo];
            _getColorBlock(nil,nil,nullImageError);
            return;
        }
        
        NSInteger red,green,blue;
        for (int pixelIndex = 0 ; pixelIndex < self.pixelCount; pixelIndex++){
            
            red   = (NSInteger)rawData[pixelIndex*4+0];
            green = (NSInteger)rawData[pixelIndex*4+1];
            blue  = (NSInteger)rawData[pixelIndex*4+2];
            
            //switch RGB888 to RGB555
            red = [PaletteColorUtils modifyWordWidthWithValue:red currentWidth:8 targetWidth:QUANTIZE_WORD_WIDTH];
            green = [PaletteColorUtils modifyWordWidthWithValue:green currentWidth:8 targetWidth:QUANTIZE_WORD_WIDTH];
            blue = [PaletteColorUtils modifyWordWidthWithValue:blue currentWidth:8 targetWidth:QUANTIZE_WORD_WIDTH];
            
            NSInteger quantizedColor = red << 2*QUANTIZE_WORD_WIDTH | green << QUANTIZE_WORD_WIDTH | blue;
            hist [quantizedColor] ++;
        }
        
        free(rawData);
        
        NSInteger distinctColorCount = 0;
        NSInteger length = sizeof(hist)/sizeof(hist[0]);
        for (NSInteger color = 0 ; color < length ;color++){
            if (hist[color] > 0 && [self shouldIgnoreColor:color]){
                hist[color] = 0;
            }
            if (hist[color] > 0){
                distinctColorCount ++;
            }
        }
        
        NSInteger distinctColorIndex = 0;
        _distinctColors = [[NSMutableArray alloc]init];
        for (NSInteger color = 0; color < length ;color++){
            if (hist[color] > 0){
                [_distinctColors addObject: [NSNumber numberWithInteger:color]];
                distinctColorIndex++;
            }
        }
        
        // distinctColorIndex should be equal to (length - 1)
        distinctColorIndex--;
        
        if (distinctColorCount <= kMaxColorNum){
            NSMutableArray *swatchs = [[NSMutableArray alloc]init];
            for (NSInteger i = 0;i < distinctColorCount ; i++){
                NSInteger color = [_distinctColors[i] integerValue];
                NSInteger population = hist[color];
                
                NSInteger red = [PaletteColorUtils quantizedRed:color];
                NSInteger green = [PaletteColorUtils quantizedGreen:color];
                NSInteger blue = [PaletteColorUtils quantizedBlue:color];
                
                red = [PaletteColorUtils modifyWordWidthWithValue:red currentWidth:QUANTIZE_WORD_WIDTH targetWidth:8];
                green = [PaletteColorUtils modifyWordWidthWithValue:green currentWidth:QUANTIZE_WORD_WIDTH targetWidth:8];
                blue = [PaletteColorUtils modifyWordWidthWithValue:blue currentWidth:QUANTIZE_WORD_WIDTH targetWidth:8];
                
                color = red << 2 * 8 | green << 8 | blue;
                
                PaletteSwatch *swatch = [[PaletteSwatch alloc]initWithColorInt:color population:population];
                [swatchs addObject:swatch];
            }
            
            _swatchArray = [swatchs copy];
        }else{
            _priorityArray = [[PriorityBoxArray alloc]init];
            VBox *colorVBox = [[VBox alloc]initWithLowerIndex:0 upperIndex:distinctColorIndex colorArray:_distinctColors];
            [_priorityArray addVBox:colorVBox];
            // split the VBox
            [self splitBoxes:_priorityArray];
            //Switch VBox to Swatch
            self.swatchArray = [self generateAverageColors:_priorityArray];
        }
        
        [self findMaxPopulation];
        
        [self getSwatchForTarget];
    });

}

- (void)splitBoxes:(PriorityBoxArray*)queue{
    //queue is a priority queue.
    while (queue.count < kMaxColorNum) {
        VBox *vbox = [queue poll];
        if (vbox != nil && [vbox canSplit]) {
            // First split the box, and offer the result
            [queue addVBox:[vbox splitBox]];
            // Then offer the box back
            [queue addVBox:vbox];
        }else{
            NSLog(@"All boxes split");
            return;
        }
    }
}

- (NSArray*)generateAverageColors:(PriorityBoxArray*)array{
    NSMutableArray *swatchs = [[NSMutableArray alloc]init];
    NSMutableArray *vboxArray = [array getVBoxArray];
    for (VBox *vbox in vboxArray){
        PaletteSwatch *swatch = [vbox getAverageColor];
        if (swatch){
            [swatchs addObject:swatch];
        }
    }
    return [swatchs copy];
}

#pragma mark - image compress

- (unsigned char *)rawPixelDataFromImage:(UIImage *)image{
    // Get cg image and its size
    
//    image = [self scaleDownImage:image];
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
    // Allocate storage for the pixel data
    unsigned char *rawData = (unsigned char *)malloc(height * width * 4);
    
    // If allocation failed, return NULL
    if (!rawData) return NULL;
    
    // Create the color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Set some metrics
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    // Create context using the storage
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // Release the color space
    CGColorSpaceRelease(colorSpace);
    
    // Draw the image into the storage
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    // We are done with the context
    CGContextRelease(context);
    
    // Write pixel count to passed pointer
    self.pixelCount = (NSInteger)width * (NSInteger)height;
    
    // Return pixel data (needs to be freed)
    return rawData;
}

- (UIImage*)scaleDownImage:(UIImage*)image{
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    double scaleRatio;
    CGFloat imageSize = width * height;
    if (imageSize > resizeArea){
        scaleRatio = resizeArea / ((double)imageSize);
        CGSize scaleSize = CGSizeMake((CGFloat)(width * scaleRatio),(CGFloat)(height * scaleRatio));
        UIGraphicsBeginImageContext(scaleSize);
        [_image drawInRect:CGRectMake(0.0f, 0.0f, scaleSize.width, scaleSize.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        return scaledImage;
    }else{
        return image;
    }
    
}

- (void)initTargetsWithMode:(PaletteTargetMode)mode{
    NSMutableArray *targets = [[NSMutableArray alloc]init];
    
    if (mode < VIBRANT_PALETTE || mode > ALL_MODE_PALETTE || mode == ALL_MODE_PALETTE){
        
        PaletteTarget *vibrantTarget = [[PaletteTarget alloc]initWithTargetMode:VIBRANT_PALETTE];
        [targets addObject:vibrantTarget];
        
        PaletteTarget *mutedTarget = [[PaletteTarget alloc]initWithTargetMode:MUTED_PALETTE];
        [targets addObject:mutedTarget];
        
        PaletteTarget *lightVibrantTarget = [[PaletteTarget alloc]initWithTargetMode:LIGHT_VIBRANT_PALETTE];
        [targets addObject:lightVibrantTarget];
        
        PaletteTarget *lightMutedTarget = [[PaletteTarget alloc]initWithTargetMode:LIGHT_MUTED_PALETTE];
        [targets addObject:lightMutedTarget];

        PaletteTarget *darkVibrantTarget = [[PaletteTarget alloc]initWithTargetMode:DARK_VIBRANT_PALETTE];
        [targets addObject:darkVibrantTarget];

        PaletteTarget *darkMutedTarget = [[PaletteTarget alloc]initWithTargetMode:DARK_MUTED_PALETTE];
        [targets addObject:darkMutedTarget];
        
    }else{
        if (mode & (1 << 0)){
            PaletteTarget *vibrantTarget = [[PaletteTarget alloc]initWithTargetMode:VIBRANT_PALETTE];
            [targets addObject:vibrantTarget];
        }
        if (mode & (1 << 1)){
            PaletteTarget *lightVibrantTarget = [[PaletteTarget alloc]initWithTargetMode:LIGHT_VIBRANT_PALETTE];
            [targets addObject:lightVibrantTarget];
        }
        if (mode & (1 << 2)){
            PaletteTarget *darkVibrantTarget = [[PaletteTarget alloc]initWithTargetMode:DARK_VIBRANT_PALETTE];
            [targets addObject:darkVibrantTarget];
        }
        if (mode & (1 << 3)){
            PaletteTarget *lightMutedTarget = [[PaletteTarget alloc]initWithTargetMode:LIGHT_MUTED_PALETTE];
            [targets addObject:lightMutedTarget];
        }
        if (mode & (1 << 4)){
            PaletteTarget *mutedTarget = [[PaletteTarget alloc]initWithTargetMode:MUTED_PALETTE];
            [targets addObject:mutedTarget];
        }
        if (mode & (1 << 5)){
            PaletteTarget *darkMutedTarget = [[PaletteTarget alloc]initWithTargetMode:DARK_MUTED_PALETTE];
            [targets addObject:darkMutedTarget];
        }
    }
    _targetArray = [targets copy];
    
    if (mode >= VIBRANT_PALETTE && mode <= ALL_MODE_PALETTE){
        _isNeedColorDic = YES;
    }
}

#pragma mark - utils method

- (void)clearHistArray{
    for (NSInteger i = 0;i<32768;i++){
        hist[i] = 0;
    }
}

- (BOOL)shouldIgnoreColor:(NSInteger)color{
    return NO;
}

- (void)findMaxPopulation{
    NSInteger max = 0;
    
    for (NSInteger i = 0; i <_swatchArray.count ; i++){
        PaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        NSInteger swatchPopulation = [swatch getPopulation];
        max =  MAX(max, swatchPopulation);
    }
    _maxPopulation = max;
}

#pragma mark - generate score

- (void)getSwatchForTarget{
    NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]init];
    PaletteColorModel *recommendColorModel;
    for (NSInteger i = 0;i<_targetArray.count;i++){
        PaletteTarget *target = [_targetArray objectAtIndex:i];
        [target normalizeWeights];
        PaletteSwatch *swatch = [self getMaxScoredSwatchForTarget:target];
        if (swatch){
            PaletteColorModel *colorModel = [[PaletteColorModel alloc]init];
            colorModel.imageColorString = [swatch getColorString];
            
            colorModel.percentage = (CGFloat)[swatch getPopulation]/(CGFloat)self.pixelCount;
            
//            colorModel.titleTextColorString = [swatch getTitleTextColorString];
//            colorModel.bodyTextColorString = [swatch getBodyTextColorString];
            
            if (colorModel){
                [finalDic setObject:colorModel forKey:[target getTargetKey]];
            }
            
            if (!recommendColorModel){
                recommendColorModel = colorModel;
                
                if (!_isNeedColorDic){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _getColorBlock(recommendColorModel,nil,nil);
                    });
                    return;
                }
            }
            
        }else{
            [finalDic setObject:@"unrecognized error" forKey:[target getTargetKey]];
        }
    }
    
    
    NSDictionary *finalColorDic = [finalDic copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        _getColorBlock(recommendColorModel,finalColorDic,nil);
    });

}

- (PaletteSwatch*)getMaxScoredSwatchForTarget:(PaletteTarget*)target{
    CGFloat maxScore = 0;
    PaletteSwatch *maxScoreSwatch = nil;
    for (NSInteger i = 0 ; i<_swatchArray.count; i++){
        PaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        if ([self shouldBeScoredForTarget:swatch target:target]){
            CGFloat score = [self generateScoreForTarget:target swatch:swatch];
            if (maxScore == 0 || score > maxScore){
                maxScoreSwatch = swatch;
                maxScore = score;
            }
        }
    }
    return maxScoreSwatch;
}

- (BOOL)shouldBeScoredForTarget:(PaletteSwatch*)swatch target:(PaletteTarget*)target{
    NSArray *hsl = [swatch getHsl];
    return [hsl[1] floatValue] >= [target getMinSaturation] && [hsl[1] floatValue]<= [target getMaxSaturation]
    && [hsl[2] floatValue]>= [target getMinLuma] && [hsl[2] floatValue] <= [target getMaxLuma];
    
}

- (CGFloat)generateScoreForTarget:(PaletteTarget*)target swatch:(PaletteSwatch*)swatch{
    NSArray *hsl = [swatch getHsl];
    
    float saturationScore = 0;
    float luminanceScore = 0;
    float populationScore = 0;
    
    if ([target getSaturationWeight] > 0) {
        saturationScore = [target getSaturationWeight]
        * (1.0f - fabsf([hsl[1] floatValue] - [target getTargetSaturation]));
    }
    if ([target getLumaWeight] > 0) {
        luminanceScore = [target getLumaWeight]
        * (1.0f - fabsf([hsl[2] floatValue] - [target getTargetLuma]));
    }
    if ([target getPopulationWeight] > 0) {
        populationScore = [target getPopulationWeight]
        * ([swatch getPopulation] / (float) _maxPopulation);
    }
    
    return saturationScore + luminanceScore + populationScore;
}

@end
