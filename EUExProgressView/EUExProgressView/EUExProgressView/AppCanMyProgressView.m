//
//  AppCanMyProgressView.m
//  AppCanPlugin
//
//  Created by hongbao.cui on 14-12-26.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "AppCanMyProgressView.h"
#import "EUtility.h"
#import "AppCanCircleProgressView.h"
#import "ACTHCircularProgressView.h"
#import "EUExProgressView.h"
@implementation UIImage(Extact)
- (UIImage *)imageWithColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end;
@implementation AppCanProgressBarView{
//    UIImageView * _backgroundImageView;
//    UIImageView * _foregroundImageView;
    CGFloat minimumForegroundWidth;
    CGFloat availableWidth;
}
- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = backgroundImage;
//        _backgroundImageView.backgroundColor = [UIColor redColor];
//        _backgroundImageView.layer.cornerRadius = 10;
//        _backgroundImageView.layer.borderColor =[UIColor yellowColor].CGColor;
        [self addSubview:_backgroundImageView];
        [_backgroundImageView release];
        
        _foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _foregroundImageView.image = foregroundImage;
//        _foregroundImageView.backgroundColor = [UIColor blackColor];
//        _backgroundImageView.layer.cornerRadius = 10;
        [self addSubview:_foregroundImageView];
        [_foregroundImageView release];

        UIEdgeInsets insets = foregroundImage.capInsets;
        minimumForegroundWidth = insets.left + insets.right;
        
        availableWidth = self.bounds.size.width - minimumForegroundWidth;
        
        self.progress = 0.5;
    }
    return self;
}

- (void)setProgress:(double)progress
{
    _progress = progress;
    
    CGRect frame = _foregroundImageView.frame;
    frame.size.width = roundf(minimumForegroundWidth + availableWidth * progress);
    _foregroundImageView.frame = frame;
}
-(void)dealloc{
    if (_backgroundImageView) {
        _backgroundImageView = nil;
    }
    if (_foregroundImageView) {
        _foregroundImageView = nil;
    }
    [super dealloc];
}
@end
@implementation AppCanMyProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)normalProgressView:(CGRect)frame{////第一种进度条
    UIProgressView *prgView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [prgView setFrame:CGRectMake(20, (frame.size.height-prgView.frame.size.height)/2, frame.size.width-70-20-10, prgView.frame.size.height)];
//    prgView.autoresizesSubviews = YES;
//    prgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    [prgView setTag:100];
    [self addSubview:prgView];
    [prgView release];
    UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-20-70-10, (frame.size.height-70)/2, 70, 70)];
    NSString *percent = @"100%";
    CGSize size = [percent sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:CGSizeMake(70, 70) lineBreakMode:NSLineBreakByWordWrapping];
    [percentLabel setFrame:CGRectMake(frame.size.width-70-10, (frame.size.height-size.height)/2, size.width, size.height)];
    [percentLabel setText:@"100%"];
    [percentLabel setTag:101];
    [percentLabel setTextAlignment:NSTextAlignmentCenter];
    [percentLabel setFont:[UIFont systemFontOfSize:20.0]];
//    prgView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:percentLabel];
    [percentLabel release];
    
    [self setProgress:initProgress];//保存设置进度
}
-(UIImage *)getLocalImage:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}
//第二种进度条
-(void)coreProgressView:(CGRect)frame{
    UIImage * backgroundImage = [self getLocalImage:@"uexProgressView/progress-bg"] ;
    backgroundImage = [[backgroundImage imageWithColor:[UIColor colorWithRed:33.0/255.0 green:118.0/255.0 blue:247.0/255.0 alpha:1.0]]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage * foregroundImage = [self getLocalImage:@"uexProgressView/progress-fg"];
    foregroundImage = [[foregroundImage imageWithColor:[UIColor colorWithRed:33.0/255.0 green:118.0/255.0 blue:247.0/255.0 alpha:1.0]]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    AppCanProgressBarView  *barView = [[AppCanProgressBarView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-20)/2, frame.size.width, 20) backgroundImage:backgroundImage foregroundImage:foregroundImage];
    [barView setProgress:initProgress];
    barView.tag = 3;
    if (!acbgView) {
        acbgView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-20)/2, frame.size.width, 20)];
    }
    acbgView.layer.cornerRadius = 10;
    [acbgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:acbgView];
    [self addSubview:barView];
    [barView release];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self normalProgressView:frame];
    }
    return self;
}
//第一种进度条属性
-(void)setPropertyViewStyle:(NSDictionary *)style_dict{
    UIProgressView *prgView  = (UIProgressView *) [self viewWithTag:100];
    UILabel *percentLabel = (UILabel *)[self viewWithTag:101];
    UIColor *normalColor = [EUtility ColorFromString:[style_dict objectForKey:@"normalColor"]];
    UIColor *progressColor = [EUtility ColorFromString:[style_dict objectForKey:@"progressColor"]];
    BOOL isShowText = [[style_dict objectForKey:@"isShowText"] boolValue];
    CGFloat textSize = [[style_dict objectForKey:@"textSize"] floatValue];
    [prgView setProgressTintColor:progressColor];
    [prgView setTrackTintColor:normalColor];
    [percentLabel setTextColor:progressColor];
    if (isShowText) {
        [percentLabel setHidden:YES];
        [prgView setFrame:CGRectMake(20, (self.frame.size.height-prgView.frame.size.height)/2, self.frame.size.width-20-20, prgView.frame.size.height)];
    }else{
        [percentLabel setHidden:NO];
        NSString *percent =[NSString stringWithFormat:@"%.2f",initProgress];
        CGSize size = [@"100%" sizeWithFont:[UIFont systemFontOfSize:textSize] constrainedToSize:CGSizeMake(70, 70) lineBreakMode:NSLineBreakByWordWrapping];
        [percentLabel setFrame:CGRectMake(self.frame.size.width-70-10, (self.frame.size.height-size.height)/2, size.width, size.height)];
        [percentLabel setFont:[UIFont systemFontOfSize:textSize]];
        [prgView setFrame:CGRectMake(20, (self.frame.size.height-prgView.frame.size.height)/2, self.frame.size.width-70-20-10, prgView.frame.size.height)];
    }
}
//第二种进度条属性
-(void)setCoreProgressPropertyViewStyle:(NSDictionary *)style_dict{
    AppCanProgressBarView  *barView = (AppCanProgressBarView *)[self viewWithTag:3];
    UIColor *borderCorlor = [EUtility ColorFromString:[style_dict objectForKey:@"borderCorlor"]];
    UIColor *normalColor = [EUtility ColorFromString:[style_dict objectForKey:@"normalColor"]];
    UIColor *progressColor = [EUtility ColorFromString:[style_dict objectForKey:@"progressColor"]];
    if (acbgView) {
        [acbgView setBackgroundColor:normalColor];
    }
    UIImage * backgroundImage = [self getLocalImage:@"uexProgressView/progress-bg"] ;
    backgroundImage = [[backgroundImage imageWithColor:borderCorlor]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    UIImage * foregroundImage = [self getLocalImage:@"uexProgressView/progress-fg"];
    foregroundImage = [[foregroundImage imageWithColor:progressColor]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    barView.backgroundImageView.image = backgroundImage;
    barView.foregroundImageView.image = foregroundImage;
}
-(void)circleProgressView:(CGRect)frame{
    CGRect pRect;
    CGFloat height = frame.size.height;
    CGFloat width= frame.size.width;
    if (width>height) {
        pRect = CGRectMake((frame.size.width-height)/2, 0, height, height);
    }else{
        pRect = CGRectMake((frame.size.width-width)/2, 0, width, width);
    }
    AppCanCircleProgressView *progressView = [[AppCanCircleProgressView alloc] initWithFrame:pRect];
    progressView.tag = 4;
    progressView.progress = initProgress;
    [self addSubview:progressView];
}
-(void)setCircleProgressViewPropertyViewStyle:(NSDictionary *)style_dict{
    AppCanCircleProgressView  *pView = (AppCanCircleProgressView *)[self viewWithTag:4];
    UIColor *borderCorlor = [EUtility ColorFromString:[style_dict objectForKey:@"borderCorlor"]];
    UIColor *normalColor = [EUtility ColorFromString:[style_dict objectForKey:@"normalColor"]];
    UIColor *progressColor = [EUtility ColorFromString:[style_dict objectForKey:@"progressColor"]];
    pView.circleBackgroundColor = borderCorlor;
    pView.progressBackgroundColor = normalColor;
    pView.progressColor = progressColor;
}
-(void)THCircleProgressView:(CGRect)frame{
    CGRect pRect;
    CGFloat height = frame.size.height;
    CGFloat width= frame.size.width;
    CGFloat radius = floor(width / 4 * 0.8);
    if (width>height) {
        pRect = CGRectMake((frame.size.width-height)/2, 0, height, height);
    }else{
        pRect = CGRectMake((frame.size.width-width)/2, 0, width, width);
    }
    ACTHCircularProgressView *pView = [[ACTHCircularProgressView alloc] initWithFrame:pRect];
    pView.lineWidth = 5.0f;
//    pView.progressColor = [UIColor redColor];
    pView.centerLabel.font = [UIFont boldSystemFontOfSize:radius];
    pView.centerLabelVisible = YES;
    pView.tag = 5;
    pView.percentage = initProgress;
    [self addSubview:pView];
}
-(void)THCircleProgressViewProperty:(NSDictionary *)style_dict{
    ACTHCircularProgressView  *pView = (ACTHCircularProgressView *)[self viewWithTag:5];
    UIColor *borderCorlor = [EUtility ColorFromString:[style_dict objectForKey:@"borderCorlor"]];
    UIColor *normalColor = [EUtility ColorFromString:[style_dict objectForKey:@"normalColor"]];
    UIColor *progressColor = [EUtility ColorFromString:[style_dict objectForKey:@"progressColor"]];
    UIColor *textColor = [EUtility ColorFromString:[style_dict objectForKey:@"textColor"]];
    pView.progressBackgroundColor = borderCorlor;
    pView.progressColor = progressColor;
    pView.centerLabel.textColor = textColor;
    pView.pbackgroundColor = normalColor;
    pView.percentage = initProgress;
    [pView setNeedsDisplay];
}
-(void)setViewStyle:(NSDictionary *)styleDict{
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[UIProgressView class]]) {
            UIProgressView *pv = (UIProgressView *)subView;
            initProgress = pv.progress;
        }else if([subView isKindOfClass:[AppCanProgressBarView class]]){
            AppCanProgressBarView *pv = (AppCanProgressBarView *)subView;
            initProgress = pv.progress;
        }
        [subView removeFromSuperview];
    }
    NSString *type = [styleDict objectForKey:@"type"];
    if ([type isEqualToString:@"1"]) {
        NSDictionary *style_dict = [styleDict objectForKey:@"style"];
        [self normalProgressView:self.frame];
        [self setPropertyViewStyle:style_dict];
    }
    if ([type isEqualToString:@"2"]) {
        NSDictionary *style_dict = [styleDict objectForKey:@"style"];
        [self coreProgressView:self.frame];
        [self setCoreProgressPropertyViewStyle:style_dict];
    }
    if ([type isEqualToString:@"3"]) {
        NSDictionary *style_dict = [styleDict objectForKey:@"style"];
        [self circleProgressView:self.frame];
        [self setCircleProgressViewPropertyViewStyle:style_dict];
    }
    if ([type isEqualToString:@"4"]) {
        NSDictionary *style_dict = [styleDict objectForKey:@"style"];
        [self THCircleProgressView:self.frame];
        [self THCircleProgressViewProperty:style_dict];
    }
}
-(void)setProgress:(CGFloat)progress{
   UIProgressView *prgView  = (UIProgressView *) [self viewWithTag:100];
    UILabel *percentLabel = (UILabel *)[self viewWithTag:101];
    NSString *percentFormat = [NSString stringWithFormat:@"%.2f",progress];
    self.progressStr = percentFormat;
    CGFloat _percent = [percentFormat floatValue];
    [prgView setProgress:_percent];
    initProgress = _percent;
//    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
//    CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterPercentStyle);
//    CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &_percent);
//    
//    CFStringRef numberString = CFNumberFormatterCreateStringWithNumber(NULL, numberFormatter, number);
    NSString *numberString = [NSString stringWithFormat:@"%ld%%",(long)(_percent*100)];
//    CGSize size = [@"100%" sizeWithFont:percentLabel.font constrainedToSize:CGSizeMake(70, 70) lineBreakMode:NSLineBreakByWordWrapping];
//    [percentLabel setFrame:CGRectMake(self.frame.size.width-20-70-10, (self.frame.size.height-size.height)/2, size.width,size.height)];
    [percentLabel setText:(NSString *)numberString];
    NSLog(@"%@",numberString);
    
    AppCanProgressBarView  *barView = (AppCanProgressBarView *)[self viewWithTag:3];
    if (barView) {
        [barView setProgress:_percent];
    }
    AppCanCircleProgressView  *circleView = (AppCanCircleProgressView *)[self viewWithTag:4];
    if (circleView) {
        [circleView setProgress:_percent];
        [circleView setNeedsDisplay];
    }
    ACTHCircularProgressView  *accircleView = (ACTHCircularProgressView *)[self viewWithTag:5];
    if (accircleView) {
        accircleView.percentage = _percent;
    }
}
-(void)dealloc{
    if (acbgView) {
        [acbgView release];
        acbgView = nil;
    }
    if (self.progressStr) {
        self.progressStr = nil;
    }
    [super dealloc];
}
@end
