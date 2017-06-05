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

//Get the header element and delete it
- (VBox*)poll;

- (NSUInteger)count;

- (NSMutableArray*)getVBoxArray;

@end
