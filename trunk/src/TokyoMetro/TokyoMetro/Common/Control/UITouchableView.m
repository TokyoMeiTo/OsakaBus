//
//  UITouchableView.m
//  TokyoMetro
//
//  Created by limc on 2014/09/25.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//


#import "UITouchableView.h"

@implementation UITouchableView
@synthesize touchedPoint;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesBegan:touches withEvent:event];
    
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        self.touchedPoint = [[allTouches objectAtIndex:0] locationInView:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesMoved:touches withEvent:event];
    
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        self.touchedPoint = [[allTouches objectAtIndex:0] locationInView:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesEnded:touches withEvent:event];
    
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        self.touchedPoint = [[allTouches objectAtIndex:0] locationInView:self];
    }
}

@end

