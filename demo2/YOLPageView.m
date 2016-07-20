//
//  YOLPageView.m
//  demo2
//
//  Created by lele on 16/7/8.
//  Copyright © 2016年 starrrry. All rights reserved.
//

#import "YOLPageView.h"

@implementation YOLPageView

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.image = image;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}

-(void)rightMove:(float)x animation:(BOOL)animation {
    //控制prepage
    _imageView.hidden = NO;
    if (animation) {
        [UIView beginAnimations:@"ad" context:nil];
        [UIView setAnimationDidStopSelector:@selector(didFinishMove)];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
    }
    
    CGRect rect = self.frame;
    rect.origin.x = rect.origin.x + x*0.19;
    rect.size.width = rect.size.width + x*0.81;
    self.frame = rect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _imageView.frame = rect;
    if(animation)
    {
        [UIView commitAnimations];
    }
}

-(void)leftMoveWithWidth:(float)width x:(float)x animation:(BOOL)animation; {
    _imageView.hidden = NO;
    if (animation) {
        [UIView beginAnimations:@"ad" context:nil];
        [UIView setAnimationDidStopSelector:@selector(didFinishMove)];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
    }
    
    CGRect rect = self.frame;
    rect.origin.x = 0 - x*0.19;
    rect.size.width = width - x*0.81;
    self.frame = rect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _imageView.frame = rect;
    if(animation)
    {
        [UIView commitAnimations];
    }
}

-(void)move:(int)x animation:(BOOL)animation
{
    self.hidden = NO;
    if (animation) {
        [UIView beginAnimations:@"ad" context:nil];
        [UIView setAnimationDidStopSelector:@selector(didFinishMove)];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
    }

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (x == 0) {
        CGRect rect = self.frame;
        rect.origin.x = -screenRect.size.width*0.19;
        rect.size.width = screenRect.size.width*0.19;
        self.frame = rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        _imageView.frame = rect;
    } else if (x == 1) {
        CGRect rect = self.frame;
        rect.origin.x = 0;
        rect.size.width = screenRect.size.width;
        self.frame = rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        _imageView.frame = rect;
    } else if (x == 2) {
        CGRect rect = self.frame;
        rect.origin.x = screenRect.size.width * 0.19;
        rect.size.width = screenRect.size.width;
        self.frame = rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        _imageView.frame = rect;
    }
    
    if(animation)
    {
        [UIView commitAnimations];
    }
}

- (void)sideMoveX:(float)x left:(BOOL)left animation:(BOOL)animation {
    self.hidden = NO;
    if (animation) {
        [UIView beginAnimations:@"ad" context:nil];
        [UIView setAnimationDidStopSelector:@selector(didFinishMove)];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (left) {
        CGRect rect = self.frame;
        rect.origin.x = screenRect.size.width*0.19 - x*0.19;
        self.frame = rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        _imageView.frame = rect;
    } else {
        CGRect rect = self.frame;
        rect.origin.x = 0 + x*0.19;
        self.frame = rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        _imageView.frame = rect;
    }
    
    if(animation)
    {
        [UIView commitAnimations];
    }
}

-(void)didFinishMove
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishMove)]) {
        [self.delegate didFinishMove];
    }
}

@end
