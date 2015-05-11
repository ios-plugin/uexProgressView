//
//  AppCanCircleProgressView.h
//  AppCanPlugin
//
//  Created by hongbao.cui on 14-12-27.
//  Copyright (c) 2014年 zywx. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppCanCircleProgressView : UIView{
    
}
@property(nonatomic) CGFloat frameWidth;
@property(nonatomic, retain) UIColor *progressColor;
@property(nonatomic, retain) UIColor *progressBackgroundColor;
@property(nonatomic, retain) UIColor *circleBackgroundColor;
@property(nonatomic,assign) CGFloat progress;
@end
