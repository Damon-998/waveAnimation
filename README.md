# waveAnimation
最近遇到了水波波动的动画效果，看书资料学习下，做了个小demo，希望别人有所帮助。
这里我是用CAShapeLayer来实现水波动画的，而不是使用Core Graphics直接向原始的CALyer的内容中绘制一个路径，主要还是CAShapeLayer有更多的优点的：
•	渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
•	高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
•	不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉。
•	不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
首先创建一个CAShapeLayer：
```
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
```
我们先分析一下水波动画：
![wave.gif](http://upload-images.jianshu.io/upload_images/1345272-d36fe90c05de7e51.gif?imageMogr2/auto-orient/strip)
通过观察我们可以看到水波动画我们要实现顶部的线条进行上下凹凸、平行移动,通俗来讲就是一条移动的波浪线（~），那怎么才能不断的画对称的波浪线，我们回忆下我们学过的数学知识便可以发现我们高中学习的正弦函数和余弦函数是最相符的，这里我选择用正弦函数来做，首先复习一些正弦函数的信息；
y=sin(x);这是最基本的正弦函数周期为2π，y的最值是±1，显然y的最值对我们意义不大，那我们考虑正线性函数
`y=Asin（ωx+φ）+h
在表达式中
A 表示振幅，也就是使用这个变量来调整波浪的高度
ω表示周期，也就是使用这个变量来调整在屏幕内显示的波浪的数量
φ表示波浪横向的偏移，也就是使用这个变量来调整波浪的流动
h表示波浪纵向的位置，也就是使用这个变量来调整波浪在屏幕中竖直的位置。`
通过上面的函数，我们就能计算出波浪曲线上任意位置的坐标点，把这些点点连起来便可得到一条我们需要的曲线
```
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
        y = 10*self.height_Y * sin((x/180*M_PI) - 2*(self.offset_X/M_PI)) + self.waterWaveHeight;
        CGPathAddLineToPoint(wavePath, nil, x, y);
    }
    //将图像的四个点连起来形成闭合图形
    CGPathAddLineToPoint(wavePath, nil, pathWidth, pathheight);
    CGPathAddLineToPoint(wavePath, nil, 0, pathheight);
    CGPathAddLineToPoint(wavePath, nil, 0, self.waterWaveHeight);
    //结束绘图信息
    CGPathCloseSubpath(wavePath);
    self.shapeLayer.path = wavePath;
    //释放绘图路径
    CGPathRelease(wavePath);
```
下面我们要让这条线自动的动起来，这里不要使用`NSTimer`，因为使用`NSTimer`会有卡顿感，我们创建一个和屏幕刷新频率相同的计时器：`CADisplayLink`，并将它加到`RunLoop`里
```
CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(creatAnimationPath)];
[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
```
每次屏幕刷新时都会执行这个方法
```
- (void)creatAnimationPath{
    self.offset_X += 0.1;
    [self craetWavePath];
}
```
到这我们就实现了一个水波动画，文章介绍的是实现的思路，代码会比较散；demo已经上传可下载代码查看具体的实现：水波动画--
