//
//  EUExProgressView.m
//  AppCanPlugin
//
//  Created by hongbao.cui on 14-12-26.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import "EUExProgressView.h"
#import "JSON.h"
#import "AppCanMyProgressView.h"
#import "EUtility.h"
@interface EUExProgressView(){
    
}
@property(nonatomic,retain)AppCanMyProgressView *progView;
@end;
@implementation EUExProgressView
@synthesize progView = _progView;
-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
        
    }
    return self;
}
-(void)open:(NSMutableArray *)array{
    if ([array count] ==0) {
        NSLog(@"paragms is error!!");
        return;
    }
    NSDictionary *dict = [[array objectAtIndex:0] JSONValue];
    CGFloat x = [[dict objectForKey:@"x"] floatValue];
    CGFloat y = [[dict objectForKey:@"y"] floatValue];
    CGFloat width = [[dict objectForKey:@"w"] floatValue];
    CGFloat height = [[dict objectForKey:@"h"] floatValue];
    if (!_progView) {
        _progView = [[AppCanMyProgressView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [_progView setBackgroundColor:[UIColor greenColor]];
        [EUtility brwView:self.meBrwView addSubview:_progView];
    }
    [_progView addObserver:self forKeyPath:@"progressStr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(keyPath&&[keyPath isEqualToString:@"progressStr"])
    {
        if (change) {
            NSString *new = [change objectForKey:@"new"];
            if ([new isKindOfClass:[NSString class]]&&[new isEqualToString:@"1.00"]) {
                NSLog(@"new----->:%@",new);
                NSString *json = [NSString stringWithFormat:@"uexProgressView.onComplete()"];
                [self.meBrwView stringByEvaluatingJavaScriptFromString:json];
            }
        }
    }
}
-(void)setProgress:(NSMutableArray *)argus{
    if ([argus count] ==0) {
        NSLog(@"paragms is error!!");
        return;
    }
    NSDictionary *dict = [[argus objectAtIndex:0] JSONValue];
    NSInteger progress = [[dict objectForKey:@"progress"]integerValue];
    CGFloat p = progress/100.0;
    if (_progView) {
        [_progView setProgress:p];
    }
}
-(void)releaseMyDealloc{
    [_progView removeObserver:self forKeyPath:@"progressStr"];
    if (_progView) {
        [_progView removeFromSuperview];
        [_progView release];
        _progView = nil;
    }
}
-(void)close:(NSMutableArray *)array{
    [self releaseMyDealloc];
}
-(void)setViewStyle:(NSMutableArray *)argus{
    if ([argus count] ==0) {
        NSLog(@"paragms is error!!");
        return;
    }
    NSDictionary *dict = [[argus objectAtIndex:0] JSONValue];
    if (_progView) {
        [_progView setViewStyle:dict];
    }
}
-(void)clean{
    [self releaseMyDealloc];
    [super clean];
}
@end
