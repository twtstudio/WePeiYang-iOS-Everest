//
//  WMScrollView+gesture.m
//  WePeiYang
//
//  Created by JinHongxu on 16/8/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "WMScrollView+gesture.h"
@import JBChartView;
@implementation WMScrollView (gesture)


//修改了源码,使在chartView上不响应手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //NSLog(@"class :%@", [touch.view class]);
    //touch.view.backgroundColor = [UIColor redColor];
    if ([touch.view isKindOfClass: [JBLineChartDotView class]] || [touch.view isKindOfClass: [JBLineChartDotsView class]] || [touch.view isKindOfClass: [JBChartVerticalSelectionView class]] || [touch.view isKindOfClass: [UIScrollView class]]){
        // NSLog(@"class :%@", [touch.view class]);
        
        return NO;
    }
    return YES;
}

@end
