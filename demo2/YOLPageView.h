//
//  YOLPageView.h
//  demo2
//
//  Created by lele on 16/7/8.
//  Copyright © 2016年 starrrry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageViewDelegate;

@interface YOLPageView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property(nonatomic,weak) id<PageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (void)rightMove:(float)x animation:(BOOL)animation;
- (void)leftMoveWithWidth:(float)width x:(float)x animation:(BOOL)animation;
- (void)sideMoveX:(float)x left:(BOOL)left animation:(BOOL)animation;
- (void)move:(int)x animation:(BOOL)animation;

@end

@protocol PageViewDelegate <NSObject>
-(void) didFinishMove;
@end
