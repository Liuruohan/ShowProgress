//
//  TaskSingnInProgressView.h
//  NewsClient
//
//  Created by 刘恒 on 2016/12/27.
//  Copyright © 2016年 YunRuiJiTuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskSingnInProgressView : UIView

@property (nonatomic,copy)NSArray * signArray;

- (void)configMaskWithPosition:(NSInteger)position;

- (void)startAnimationWithPosition:(NSInteger)topositon;

@end
