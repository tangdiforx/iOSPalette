# iOSPalette

## 1.Introduction

Objective-C version of Google Palette algorithm in Java.A tool to extract the main color of a image.Compare to traditional algorithm,iOSPalette can help you extract the main color which is more likely to be "The Main Color".It is not always the largest in pixel numbers.

For Chinese user,you can tap the article [iOS图片精确提取主色调算法iOS-Palette](http://www.jianshu.com/p/01df6010dded).It will be helpul.

# 2.Why iOS-Palette

##### 1.It always help you to extract the color you want,no the largest in the pixel count.Just like this case:

<image src="http://upload-images.jianshu.io/upload_images/5806025-9188b291498651e7.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width=400>

You can see the 6 TargetMode from the demo screenshot.They are distinguished by different Saturation and Lightness (According to HSL Color Mode).

```
LIGHT_VIBRANT_MODE (High Lightness , High Saturation)

VIBRANT_MODE(Normal Lightness , High Saturation)

DARK_VIBRANT_MODE(Dark Lightness , High Saturation)

LIGHT_MUTED_MODE(High Lightness , Low Saturation)

MUTED_MODE(Normal Lightness , Low Saturation)

DARK_MUTED_MODE(Dark Lightness , Low Saturation)

```
You can get every target mode color thourgh the iOSPalette API if you need!

##### 2.It helps to combine every single RGB Value into a VBox,then calculate the most representational color.

# 3.How to use iOS-Palette

You can get these simple API in Palette.h and UIImage+Palette.h:

<image src="https://img.alicdn.com/tfs/TB1mwJORFXXXXcNaXXXXXXXXXXX-824-182.jpg" width=500>
<image src="https://img.alicdn.com/tfs/TB1nAx2RFXXXXXjaXXXXXXXXXXX-1274-176.jpg" width=500>

If you need all target mode info, you can use these API in Palette.h and UIImage.Palette.h:
<image src="https://img.alicdn.com/tfs/TB1IhFLRFXXXXaOapXXXXXXXXXX-1456-126.jpg" width=500>

Then you all get the callback with all color infomation you want:
<image src="https://img.alicdn.com/tfs/TB17nl6RFXXXXXQXVXXXXXXXXXX-1480-166.jpg" width=500>

```
Tips:The recommendColor is the color for the vibrant target.In case of null,It will be replaced by this order:MUTE_MODE------LIGHT_VIRANT_MODE ------LIGHT_MUTE_MODE------DARK_VIBRANT_MODE------DARK_MUTE_MODE.

Absolutely,you can change the order if you want different performance.
```

# 4.Demo
1.Before white background:

<image src="https://img.alicdn.com/tfs/TB1rSieRFXXXXajXpXXXXXXXXXX-720-1280.jpg" width=400>

2.In the normal illumination:

<image src="https://img.alicdn.com/tfs/TB1BjuXRFXXXXamXpXXXXXXXXXX-720-1280.jpg" width=400>

# 5.Contact me

if you have any question,you can contact me thourgh the contact infomation below.Or open a issue on Github.I will solve it as soon as possible!Best wishes!


Zhihu:[知乎](https://www.zhihu.com/people/tang-di-78/activities)

Email:564531504@qq.com

简书:[Tap Here](http://www.jianshu.com/p/01df6010dded)