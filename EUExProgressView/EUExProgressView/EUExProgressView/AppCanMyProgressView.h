//
//  AppCanMyProgressView.h
//  AppCanPlugin
//
//  Created by hongbao.cui on 14-12-26.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage(Extact)

@end;
@interface AppCanProgressBarView : UIView

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage;

@property (nonatomic, assign) double progress;
@property(nonatomic,retain)UIImageView *backgroundImageView;
@property(nonatomic,retain)UIImageView *foregroundImageView;
@end
@interface AppCanMyProgressView : UIView{
    CGFloat initProgress;
    UIView *acbgView;//第二种类型的进度条背景
}
@property(nonatomic)CGFloat progress;
@property(nonatomic,retain)NSString *progressStr;
-(void)setViewStyle:(NSDictionary *)styleDict;
@end
