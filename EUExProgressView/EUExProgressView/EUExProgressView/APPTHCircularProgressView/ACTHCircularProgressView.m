//
//  ACTHCircularProgressBar.m
//
//  Created by Tiago Henriques on 3/4/13.
//  Copyright (c) 2013 Tiago Henriques. All rights reserved.
//

#import "ACTHCircularProgressView.h"

#define CGPointCenterPointOfRect(rect) CGPointMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f)

@interface ACTHCircularProgressView () {
    CGFloat oldFrameWidth;
}
@end

@implementation ACTHCircularProgressView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.lineWidth = 10.0f;
        self.progressBackgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        self.progressColor = [UIColor redColor];
        self.progressBackgroundMode = THProgressBackgroundModeCircumference;
        self.progressMode = THProgressModeFill;
        self.clockwise = YES;
        
        self.backgroundColor = [UIColor clearColor];
        oldFrameWidth = frame.size.width;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.centerLabel = label;
        self.centerLabelVisible = NO;
        self.contentMode = UIViewContentModeRedraw;
        
        [self addSubview:self.centerLabel];
        _pbackgroundColor = [UIColor clearColor];

    }
 
    return self;
}

- (instancetype)initWithCenter:(CGPoint)center
                        radius:(CGFloat)radius
                     lineWidth:(CGFloat)lineWidth
                  progressMode:(THProgressMode)progressMode
                 progressColor:(UIColor *)progressColor
        progressBackgroundMode:(THProgressBackgroundMode)backgroundMode
       progressBackgroundColor:(UIColor *)progressBackgroundColor
                    percentage:(CGFloat)percentage
{
    CGRect rect = CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius);
    
    self = [self initWithFrame:rect];
    if (self) {
        self.lineWidth = lineWidth;
        self.progressMode = progressMode;
        self.progressColor = progressColor;
        self.progressBackgroundMode = backgroundMode;
        self.progressBackgroundColor = progressBackgroundColor;
        self.percentage = percentage;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // scale linewidth and font to match new size
    CGFloat w = self.frame.size.width;
    if (w == 0) {
        return;
    }
    if (oldFrameWidth == 0) { // skip scale if initial frame width is zero
        oldFrameWidth = w;
    }
    CGFloat scale = w/oldFrameWidth;
    if (scale != 1.0) {
        _lineWidth *= scale;
        if (self.centerLabelVisible) {
            CGFloat pointSize = self.centerLabel.font.pointSize * scale;
            UIFont *font = [UIFont fontWithName:self.centerLabel.font.fontName size:pointSize];
            self.centerLabel.font = font;
        }
    }
    oldFrameWidth = w;
}

- (void)drawRect:(CGRect)rect
{
    [self drawBackground:rect];
    [self drawProgress:rect];
}

- (void)drawBackground:(CGRect)rect
{
    switch (self.progressBackgroundMode) {
        case THProgressBackgroundModeCircle: {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextAddEllipseInRect(ctx, rect);
            CGContextSetFillColor(ctx, CGColorGetComponents([self.progressBackgroundColor CGColor]));
            CGContextFillPath(ctx);
            break;
        }
        case THProgressBackgroundModeCircumference: {
//            CGFloat radiusMinusLineWidth = self.radius - self.lineWidth / 2;//cui change
            CGFloat radiusMinusLineWidth = self.radius - self.lineWidth;//cui change
            UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointCenterPointOfRect(rect)
                                                                          radius:radiusMinusLineWidth
                                                                      startAngle:0
                                                                        endAngle:2 * M_PI
                                                                       clockwise:YES];
            [self.progressBackgroundColor setStroke];
            progressCircle.lineWidth = self.lineWidth;
            [progressCircle stroke];
            break;
        }
        case THProgressBackgroundModeNone:
        default:
            break;
    }
}

- (CGFloat) radius
{
    return self.frame.size.width/2.0;
}

- (void) setRadius:(CGFloat)radius
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, radius*2.0f, radius*2.0f);
}

- (void)drawProgress:(CGRect)rect
{
    CGFloat radius = [self radius];
//    CGFloat radiusMinusLineWidth = radius - self.lineWidth / 2; cui change
    CGFloat radiusMinusLineWidth = radius - self.lineWidth*3;
    CGFloat percentage = self.percentage;
    
    if (self.clockwise == NO) {
        percentage = 1.0f - percentage;
    }

    BOOL clockwise = YES;
    if ((self.clockwise && self.progressMode == THProgressModeDeplete) ||
        (self.clockwise == NO && self.progressMode == THProgressModeFill)) {
        clockwise = NO;
    }
    
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + percentage * 2 * M_PI;
    
    if (self.progressMode == THProgressModeFill && percentage > 0) {
        [self drawProgressArcWithStartAngle:startAngle endAngle:endAngle radius:radiusMinusLineWidth clockwise:clockwise];
    }
    else if (self.progressMode == THProgressModeDeplete && percentage < 1) {
        [self drawProgressArcWithStartAngle:startAngle endAngle:endAngle radius:radiusMinusLineWidth clockwise:clockwise];
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( [_pbackgroundColor CGColor]));
    CGContextAddArc(ctx, point.x, point.y, radiusMinusLineWidth-2, 0, 2 * M_PI, clockwise);
    CGContextFillPath(ctx);
}

- (void)drawProgressArcWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius clockwise:(BOOL)clockwise
{
    UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointCenterPointOfRect(self.bounds)
                                                                  radius:radius
                                                              startAngle:startAngle
                                                                endAngle:endAngle
                                                               clockwise:clockwise];
    
    [self.progressColor setStroke];
    progressCircle.lineWidth = self.lineWidth*3;
    [progressCircle stroke];
}

#pragma mark - Public

- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor
{
    _progressBackgroundColor = progressBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setPercentage:(CGFloat)percentage
{
    _percentage = fminf(fmax(percentage, 0), 1);
//    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
//    CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterPercentStyle);
//    CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &_percentage);
//    CFStringRef numberString = CFNumberFormatterCreateStringWithNumber(NULL, numberFormatter, number);
    NSString *numberString = [NSString stringWithFormat:@"%ld%%",(long)(percentage*100)];
    self.centerLabel.text = numberString;
    [self setNeedsDisplay];
}

- (void)setCenterLabelVisible:(BOOL)centerLabelVisible
{
    self.centerLabel.hidden = !centerLabelVisible;
}

- (BOOL)centerLabelVisible
{
    return !self.centerLabel.hidden;
}

@end
