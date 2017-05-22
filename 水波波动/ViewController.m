//
//  ViewController.m
//  水波波动
//
//  Created by 王朝阳 on 2017/5/18.
//  Copyright © 2017年 王朝阳. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) CAShapeLayer *shapeLayer;
/**
 *  水波的高度
 */
@property (nonatomic, assign) CGFloat waterWaveHeight;

///Y周的高度
@property (nonatomic, assign) CGFloat height_Y;

///X轴的偏移量
@property (nonatomic, assign) CGFloat offset_X;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waterWaveHeight = 200;
    self.height_Y = 1.0;
    self.offset_X = 0.0;
    
    //新建一个形状图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //图形填充的颜色
    shapeLayer.fillColor = [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:0.3] CGColor];
    //图形线的宽度
    shapeLayer.lineWidth = 1;
    //图形线（边界）的颜色
    shapeLayer.strokeColor = [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:0.3] CGColor];
    
    //添加形状图层
    [self.view.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    
    
    ///创建一个和屏幕刷新频率相同的计时器：CADisplayLink
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(creatAnimationPath)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)creatAnimationPath{
    self.offset_X += 0.1;
    [self craetWavePath];
}
- (void)craetWavePath{
    
    //绘制图层的路径
    CGMutablePathRef wavePath = CGPathCreateMutable();

    //绘制路径的起始位置
    CGPathMoveToPoint(wavePath, nil, 0, self.waterWaveHeight);
    
    CGFloat y = 0.f;
    //y=Asin（ωx+φ）+h
    //路径最大的宽度，屏幕的宽度
    CGFloat pathWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat pathheight = [UIScreen mainScreen].bounds.size.height;
    //画点
    for (float x = 0.0; x <= pathWidth; x++) {
        y = 10*self.height_Y * sin((x/180*M_PI) - 2*(self.offset_X/M_PI)) + self.waterWaveHeight;//x= 0.0时 y在self.waterWaveHeight的高度
        CGPathAddLineToPoint(wavePath, nil, x, y);
    }
    
    CGPathAddLineToPoint(wavePath, nil, pathWidth, pathheight);
    CGPathAddLineToPoint(wavePath, nil, 0, pathheight);
    CGPathAddLineToPoint(wavePath, nil, 0, self.waterWaveHeight);
    
    //结束绘图信息
    CGPathCloseSubpath(wavePath);
    
    self.shapeLayer.path = wavePath;
    //释放绘图路径
    CGPathRelease(wavePath);
}

@end
