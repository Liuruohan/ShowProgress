//
//  TaskSingnInProgressView.m
//  NewsClient
//
//  Created by 刘恒 on 2016/12/27.
//  Copyright © 2016年 YunRuiJiTuan. All rights reserved.
//

#import "TaskSingnInProgressView.h"

#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width
#define color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface TaskSingnInProgressView ()

@property (nonatomic,strong)CAShapeLayer * backgroundLayer;
@property (nonatomic,strong)CAShapeLayer * aboveLayer;
@property (nonatomic,strong)CAShapeLayer * moveLayer;

@property (nonatomic,assign)CGFloat beginX;
@property (nonatomic,assign)CGFloat fromprogress;

@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,assign)CGFloat circalRadius;


@end

@implementation TaskSingnInProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    _fromprogress = 0.0;
    _beginX = 20;
    _circalRadius = 40;
    self.backgroundLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.backgroundLayer];
    self.aboveLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.aboveLayer];
    
    self.backgroundLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.aboveLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}
- (void)setSignArray:(NSArray *)signArray{
    _signArray = signArray;

    _lineWidth = (mainWidth-40*signArray.count-_beginX*2)/(signArray.count-1);
    for (NSInteger i=0; i<signArray.count; i++) {
        NSString * day = [NSString stringWithFormat:@"%@天",[[signArray objectAtIndex:i]objectForKey:@"day"]];
        NSString * gold = [NSString stringWithFormat:@"+%@金币",[[signArray objectAtIndex:i] objectForKey:@"gold"]];
        //根据数组个数创建相等数量的圆圈，分别加在backGroundLayer和aboveLayer上
        [self generatePointWithFrame:CGRectMake(_beginX+(_circalRadius+_lineWidth)*i, 10, _circalRadius, _circalRadius) labelText:day above:NO];
        [self generatePointWithFrame:CGRectMake(_beginX+(_circalRadius+_lineWidth)*i, 10, _circalRadius, _circalRadius) labelText:day above:YES];
        
        //下面这段代码是对进度的每一个圆圈下的说明，自己可以定义,想看效果可以关闭注释
        [self generateTipLabelWithFrame:CGRectMake(_beginX+(_circalRadius+_lineWidth)*i, 10, _circalRadius, _circalRadius) labelText:gold above:NO];
        [self generateTipLabelWithFrame:CGRectMake(_beginX+(_circalRadius+_lineWidth)*i, 10, _circalRadius, _circalRadius) labelText:gold above:YES];
        
        //下面的代码主要是画取两个圆圈之间的连线
        if (i<(signArray.count-1)) {
            [self generateUnitLineWithFrame:CGRectMake(_beginX+(_circalRadius-2)+(_circalRadius+_lineWidth)*i, 28, _lineWidth+4, 4) above:NO];
            [self generateUnitLineWithFrame:CGRectMake(_beginX+(_circalRadius-2)+(_circalRadius+_lineWidth)*i, 28, _lineWidth+4, 4) above:YES];
        }
    }
}
- (void)generatePointWithFrame:(CGRect)frame
                     labelText:(NSString*)text
                         above:(BOOL)aboveFlag{
    CATextLayer * textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(0, (frame.size.height-16)/2, frame.size.width, 16);
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.string = text;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.fontSize = 12;
    CAShapeLayer * backLayer = [CAShapeLayer layer];
    backLayer.cornerRadius = frame.size.width/2;
    backLayer.frame = frame;
    backLayer.borderWidth = 4.0f;
    backLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [backLayer addSublayer:textLayer];
    if (aboveFlag) {
        backLayer.borderColor = color(1, 169, 209, 1).CGColor;
        textLayer.foregroundColor = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
        [self.aboveLayer addSublayer:backLayer];
    }
    else{
        backLayer.borderColor = color(231, 231, 231, 1).CGColor;
        textLayer.foregroundColor = color(153, 153, 153, 1).CGColor;
        [self.backgroundLayer addSublayer:backLayer];
    }
}
- (void)generateUnitLineWithFrame:(CGRect)frame
                            above:(BOOL)aboveFlag{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = frame;
    if (aboveFlag) {
        layer.backgroundColor = color(1, 169, 209, 1).CGColor;
        [self.aboveLayer addSublayer:layer];
    }
    else{
        layer.backgroundColor = color(231, 231, 231, 1).CGColor;
        [self.backgroundLayer addSublayer:layer];
    }
}
- (void)generateTipLabelWithFrame:(CGRect)frame
                        labelText:(NSString *)text
                            above:(BOOL)aboveFlag{
    CATextLayer * bottomText = [CATextLayer layer];
    bottomText.frame = CGRectMake(frame.origin.x-15, frame.size.height+15, frame.size.width+30, 25);
    bottomText.string = text;
    bottomText.contentsScale = [UIScreen mainScreen].scale;
    bottomText.alignmentMode = kCAAlignmentCenter;
    bottomText.fontSize = 12;
    if (aboveFlag) {
        bottomText.foregroundColor = [UIColor whiteColor].CGColor;
        [self.aboveLayer addSublayer:bottomText];
    }
    else{
        bottomText.foregroundColor = [UIColor whiteColor].CGColor;
        [self.backgroundLayer addSublayer:bottomText];
    }
    
}
//根据进度数据获取进度，同时给moveLayer赋值，对aboveLayer进行切割
- (void)configMaskWithPosition:(NSInteger)position{
    _fromprogress = [self obtainProgressWithPosition:position];
    self.moveLayer = [CAShapeLayer layer];
    self.moveLayer.bounds = self.aboveLayer.bounds;
    self.moveLayer.fillColor = [UIColor blackColor].CGColor;
    self.moveLayer.path = [UIBezierPath bezierPathWithRect:self.aboveLayer.bounds].CGPath;
    self.moveLayer.position = CGPointMake(-self.aboveLayer.bounds.size.width / 2.0+_beginX+_fromprogress, self.aboveLayer.bounds.size.height / 2.0);
    self.aboveLayer.mask = self.moveLayer;
}
- (void)startAnimationWithPosition:(NSInteger)topositon{
    CGFloat toprogress = [self obtainProgressWithPosition:topositon];
    self.moveLayer.position = CGPointMake(-self.aboveLayer.bounds.size.width / 2.0+toprogress+_beginX, self.aboveLayer.bounds.size.height / 2.0);
    
     //layer本身就自带动画，下面的代码是为moveLayer换一种速度比较慢的动画
//    CABasicAnimation *rightAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    rightAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-self.aboveLayer.bounds.size.width / 2.0+_fromprogress+_beginX, self.aboveLayer.bounds.size.height / 2.0)];
//    rightAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-self.aboveLayer.bounds.size.width / 2.0+toprogress+_beginX, self.aboveLayer.bounds.size.height / 2.0)];
//    rightAnimation.duration = 1;
//    rightAnimation.repeatCount = 0;
//    rightAnimation.removedOnCompletion = NO;
//    [self.moveLayer addAnimation:rightAnimation forKey:@"rightAnimation"];
}

//根据当前数字获取进度（主要）
- (CGFloat)obtainProgressWithPosition:(NSInteger)position{
    CGFloat progress = 0.0;
    if (position!=0) {
        NSMutableArray * alldaysArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSDictionary* dict in self.signArray) {
            [alldaysArray addObject:[dict objectForKey:@"day"]];
        }
        NSInteger i ;
        NSInteger day=0;
        for (i = 0; i <alldaysArray.count; i++) {
            day = [[alldaysArray objectAtIndex:i]integerValue];
            if (day>=position) {
                break;
            }
        }
        if (day == position) {
            progress = _circalRadius*(i+1)+_lineWidth*i;
        }
        else if(day>position){
            NSInteger lastday = [[alldaysArray objectAtIndex:(i-1)]integerValue];
            NSInteger daySub = day-lastday-1;
            progress = _circalRadius*i+_lineWidth*((position-lastday)/(CGFloat)daySub)+_lineWidth*(i-1);
        }
        else{
            progress = _circalRadius;
        }
    }
    return progress;
}


@end
