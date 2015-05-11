//
//  AppCanCircleProgressView.m
//  AppCanPlugin
//
//  Created by hongbao.cui on 14-12-27.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "AppCanCircleProgressView.h"
@interface AppCanCircleProgressView ()
@end
@implementation AppCanCircleProgressView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupParams];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupParams];
    }
    
    return self;
}
- (void)setupParams {
    self.backgroundColor = [UIColor clearColor];
    
    self.frameWidth = 3;
    self.progressColor = [UIColor blueColor];
    self.progressBackgroundColor = [UIColor redColor];
    self.circleBackgroundColor = [UIColor whiteColor];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark draw progress
- (void)drawRect:(CGRect)rect {
    [self drawFillPie:rect margin:0 color:self.circleBackgroundColor percentage:1];
    [self drawFramePie:rect];
    [self drawFillPie:rect margin:self.frameWidth color:self.progressBackgroundColor percentage:1];
    [self drawFillPie:rect margin:self.frameWidth color:self.progressColor percentage:self.progress];
}

- (void)drawFillPie:(CGRect)rect margin:(CGFloat)margin color:(UIColor *)color percentage:(CGFloat)percentage {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5 - margin;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, [color CGColor]);
    CGContextMoveToPoint(cgContext, centerX, centerY);
    CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * percentage), 0);
    CGContextClosePath(cgContext);
    CGContextFillPath(cgContext);
}

- (void)drawFramePie:(CGRect)rect {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;
    
    [[UIColor blueColor] set];
    CGFloat fw = self.frameWidth + 1;
    CGRect frameRect = CGRectMake(
                                  centerX - radius + fw,
                                  centerY - radius + fw,
                                  (radius - fw) * 2,
                                  (radius - fw) * 2);
    UIBezierPath *insideFrame = [UIBezierPath bezierPathWithOvalInRect:frameRect];
    insideFrame.lineWidth = 2;
    [insideFrame stroke];
}
-(void)dealloc{
    self.progressBackgroundColor = nil;
    self.progressColor = nil;
    self.circleBackgroundColor = nil;
    [super dealloc];
}
@end
