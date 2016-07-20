//
//  ViewController.m
//  demo2
//
//  Created by lele on 16/7/8.
//  Copyright © 2016年 starrrry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    currentIndex = 0;
    [super viewDidLoad];
    //初始化第一张图片和预加载第二张图片
    [self indexChange:1];
    minMoveWidth = self.view.frame.size.width /2.0f;
}

-(YOLPageView *)createView:(int)index
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index]];
    int count = 0;
    YOLPageView *vi = [[YOLPageView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 500) image:image];
    count++;
    vi.hidden = YES;

    
    vi.delegate = self;
    
    return vi;
}

-(void)indexChange:(int)newIndex
{
    if(currentIndex == newIndex)
        return;
    if(currentIndex ==0)
    {
        //启动时初始化第一个图片
        [self setVisitPage:[self createView:newIndex]];
        [self.view addSubview:self.visitPage];
        self.visitPage.hidden = NO;
    }
    if(newIndex>0)
    {
        if (newIndex>=currentIndex)
        {
            if(self.prePage)
            {
                //向后滑，将前一页从superview中移除并销毁
                [self.prePage removeFromSuperview];
                self.prePage.imageView.image = nil;
                self.prePage.imageView = nil;
                self.prePage = nil;
            }
            if(newIndex>1)
            {
                //切换到后一页
                [self setPrePage:self.visitPage];
                [self setVisitPage:self.nextPage];
            }
            //新建一页，插到底部
            [self setNextPage:[self createView:newIndex+1]];
            [self.view insertSubview:self.nextPage  atIndex:0];
        }
        else
        {
            if(self.nextPage)
            {
                //向前滑，将下一页从superview中移除并销毁
                [self.nextPage removeFromSuperview];
                self.nextPage.imageView.image = nil;
                self.nextPage.imageView = nil;
                self.nextPage = nil;
            }
            [self setNextPage:self.visitPage];
            [self setVisitPage:self.prePage];
            if(newIndex > 1)
            {
                //加载前一页
                [self setPrePage:[self createView:newIndex-1]];
                [self.view addSubview:self.prePage];
            }
            else
            {
                [self setPrePage:nil];
            }
        }
        currentIndex = newIndex;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //记录began时的坐标和时间
    UITouch *touch = [touches anyObject];
    float x = [touch locationInView:self.view].x;
    startDate = [NSDate date];
    startX = x;
    tap = YES;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    float x = [touch locationInView:self.view].x;
    fromLeft = x > startX;
    if(fromLeft && currentIndex <=1)
        return;
    float offsetX = startX - x;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (fromLeft) {
        //向右滑动，初始化prePage
        _prePage.frame = CGRectMake(-screenRect.size.width*0.19, _prePage.frame.origin.y, screenRect.size.width*0.19, _prePage.frame.size.height);
        if(self.prePage)
        {
            self.prePage.hidden = NO;
            self.nextPage.hidden = YES;
            offsetX = fabsf(offsetX);
            [_prePage rightMove:offsetX animation:NO];
            [_visitPage sideMoveX:offsetX left:NO animation:NO];
        }
        
    }
    else {
        //向左滑动，初始化nextPage
        self.nextPage.frame = CGRectMake(screenRect.size.width*0.19, self.nextPage.frame.origin.y
                                         , self.nextPage.frame.size.width, self.nextPage.frame.size.height);
        self.prePage.hidden = YES;
        self.nextPage.hidden = NO;
        [_visitPage leftMoveWithWidth:screenRect.size.width x:offsetX animation:NO];
        [_nextPage sideMoveX:offsetX left:YES animation:NO];
    }
    tap = NO;
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    float x = [touch locationInView:self.view].x;
    CGFloat offsetTime = [[NSDate date] timeIntervalSinceDate:startDate];
    [self.view setUserInteractionEnabled:NO];
    
    if (!fromLeft && offsetTime < 0.2 && fabsf(startX - x) > 50) {
        //快速向左滑动时触发，使visitPage到最左边并缩小，nextPage回到0位置
        _prePage.hidden = YES;
        nextPageIndex = currentIndex+1;
        [_visitPage move:0 animation:YES];
        [_nextPage move:1 animation:YES];
    } else if (currentIndex > 1 && fromLeft && offsetTime < 0.2 && fabsf(startX - x) > 50) {
        //快速向右滑动时触发，使prePage回复正常，visitPage向右移动
        _nextPage.hidden = YES;
        nextPageIndex = currentIndex-1;
        [_prePage move:1 animation:YES];
        [_visitPage move:2 animation:YES];
    } else if (!fromLeft && _visitPage.frame.origin.x + _visitPage.frame.size.width < minMoveWidth) {
        //向左滑动并且VisitPage的右边缘在屏幕中线左边时触发，使visitPage到最左边并缩小，nextPage回到0位置
        self.nextPage.hidden = NO;
        nextPageIndex = currentIndex+1;
        [_visitPage move:0 animation:YES];
        [_nextPage move:1 animation:YES];
    } else if(!fromLeft && _visitPage.frame.origin.x + _visitPage.frame.size.width >= minMoveWidth) {
        //向左滑动并且visitPage的右边缘在屏幕中线右边时触发，让visitPage和nextPage回到滑动前状态
        [_visitPage move:1 animation:YES];
        [_nextPage move:2 animation:YES];
    } else if(currentIndex >1) {
        _prePage.hidden = NO;
        if (fromLeft && _prePage.frame.origin.x + _prePage.frame.size.width >= minMoveWidth) {
            //向右滑动并且prePage右边缘在屏幕中线右边时触发，使prePage回复正常，visitPage向右移动
            nextPageIndex = currentIndex-1;
            [_prePage move:1 animation:YES];
            [_visitPage move:2 animation:YES];
        } else if(fromLeft &&  _prePage.frame.origin.x + _prePage.frame.size.width < minMoveWidth) {
            //向右滑动并且prePage右边缘在屏幕中线左边时触发，让visitPage和nextPage回到滑动前状态
            [_prePage move:0 animation:YES];
            [_visitPage move:1 animation:YES];
        }
    }
}
-(void)didFinishMove
{
    //移动结束后的调整
    [self indexChange:nextPageIndex];
    [self.view setUserInteractionEnabled:YES];
}

@end
