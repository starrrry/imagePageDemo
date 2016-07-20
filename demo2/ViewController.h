//
//  ViewController.h
//  demo2
//
//  Created by lele on 16/7/8.
//  Copyright © 2016年 starrrry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YOLPageView.h"

@interface ViewController : UIViewController<PageViewDelegate>
{
    int currentIndex;
    BOOL fromLeft;
    BOOL tap;
    float startX;
    NSDate *startDate;
    int nextPageIndex;
    float minMoveWidth;
}
@property(nonatomic,strong) YOLPageView*visitPage;
@property(nonatomic,strong) YOLPageView *prePage;
@property(nonatomic,strong) YOLPageView *nextPage;


@end

