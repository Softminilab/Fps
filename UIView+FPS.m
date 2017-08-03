//
//  UIView+FPS.m
//  ShowFPS
//
//  Created by kare on 02/08/2017.
//  Copyright © 2017 kare. All rights reserved.
//

#import "UIView+FPS.h"
@implementation UIView (FPS)

- (void)operation {
    
    UILabel *lable = [self viewWithTag:10909];
    if (lable == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UILabel *showFPS = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 35)];
            showFPS.userInteractionEnabled = YES;
            showFPS.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
            showFPS.font = [UIFont boldSystemFontOfSize:17];
            showFPS.textAlignment = NSTextAlignmentCenter;
            showFPS.layer.masksToBounds = YES;
            showFPS.layer.cornerRadius = 8;
            showFPS.tag = 10909;
            [self onAddGesture:showFPS];
            [self addSubview:showFPS];
            [self onAddDisplayLink];
        });
    }
    lable.hidden = NO;
}

- (void)onAddGesture:(UILabel *)label {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [label addGestureRecognizer:tap];
}

- (void)onTap:(UITapGestureRecognizer *)tap {
    tap.view.hidden = YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, touchLocation) && [[event allTouches] anyObject].tapCount >= 3)
    {
        [self operation];
    }
}

- (void)onAddDisplayLink {
    CADisplayLink *dispalyLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
    [dispalyLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkAction:(CADisplayLink *)link {
    
    static NSTimeInterval lastTime = 0;

    static int frameCount = 0;

    if (lastTime == 0) { lastTime = link.timestamp; return; }
    
    frameCount++; // 累计帧数
    
    NSTimeInterval passTime = link.timestamp - lastTime;// 累计时间

    if (passTime > 1) { // 1秒左右获取一次帧数

        int fps = frameCount / passTime; // 帧数 = 总帧数 / 时间

        lastTime = link.timestamp; // 重置
        
        frameCount = 0; // 重置
        
        UILabel *lable = [self viewWithTag:10909];
        if (fps > 55) {
            lable.textColor = [UIColor greenColor];
        }else if (fps < 30){
            lable.textColor = [UIColor redColor];
        }else {
            lable.textColor = [UIColor redColor];
        }
        lable.text = [NSString stringWithFormat:@"%d fps", fps];
//        NSLog(@"%d fps", fps);
    }
}
@end
