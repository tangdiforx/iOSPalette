//
//  PriorityBoxArray.h
//  iOSPalette
//
//  Created by 凡铁 on 17/6/3.
//  Copyright © 2017年 DylanTang. All rights reserved.
//

#import <Foundation/Foundation.h>

//A queue like PriorityQueue in Java

@class VBox;
@interface PriorityBoxArray : NSObject


- (void)addVBox:(VBox*)box;

- (VBox*)objectAtIndex:(NSInteger)i;

//获取头部元素，并删除头部元素
- (VBox*)poll;

- (NSUInteger)count;

- (NSMutableArray*)getVBoxArray;

@end
