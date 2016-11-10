//
//  AFBrushBoard.m
//  AFBrushBoard
//
//  Created by Ordinary on 16/3/24.
//  Copyright © 2016年 Ordinary. All rights reserved.
//

#import "AFBrushBoard.h"

// 最小/大宽度
#define kWIDTH_MIN 5
#define kWIDTH_MAX 13

@interface AFBrushBoard ()

// 点集合 最近三个点的集合
@property (nonatomic, strong) NSMutableArray *points;
// 当前宽度线条宽度
@property (nonatomic, assign) CGFloat currentWidth;
// 初始图片，最原始的，不做任何修改
@property (nonatomic, strong) UIImage *defaultImage;
// 上一次图片 初始化是和原始图一样，随着绘画的进程，不断的更新绘制有线条的UIImage ，self.image
@property (nonatomic, strong) UIImage *lastImage;
// 设置调试
@property (nonatomic, assign) BOOL debug;


@end

@implementation AFBrushBoard
/**
 *  懒加载
 */
- (NSMutableArray *)points {
    
    if (_points == nil) {
        _points = [NSMutableArray array];
    }
    return _points;
}

/**
 *  重写初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self updateUI];
        
    }
    return self;
}

/**
 *  更新UI
 */
- (void)updateUI {
    
//    self.debug = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    // 添加清楚Button
    UIButton *cleanBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,self.frame.size.height-50, self.frame.size.width, 50)];
    cleanBtn.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [cleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cleanBtn.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:18];
    cleanBtn.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    [cleanBtn setTitle:@"Clear" forState:UIControlStateNormal];
    [cleanBtn addTarget:self action:@selector(cleanBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cleanBtn];
    
    // 设置默认图片
    UIImage *tempImage = [UIImage imageNamed:@"apple"];
    self.image = tempImage;
    self.defaultImage = tempImage;
    self.lastImage = tempImage;
    
    if (self.debug) {
        
        NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
        
        [self.points addObjectsFromArray:@[value1,value2,value3]];
        
//        self.currentWidth = 10;
        
        [self changeImage];
        
    }
    
    
}


/**
 *   cleanBtn 响应事件: 恢复初始状态
 */
- (void)cleanBtnDidClick {
    self.image = self.defaultImage;
    self.lastImage = self.defaultImage;
//    self.currentWidth = 13.0;
    
}

/**
 *  画图
 */
- (void)changeImage {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    
    [self.lastImage drawInRect:self.bounds];
    
    // 设置贝塞尔曲线的起始点和末尾点
    CGPoint p0 = [self.points[0] CGPointValue];
    CGPoint p1 = [self.points[1] CGPointValue];
    CGPoint p2 = [self.points[2] CGPointValue];
    
    CGPoint tempPoint1 = CGPointMake((p0.x + p1.x) * 0.5, (p0.y + p1.y) * 0.5);//求得  p0和p1 的中间点
    CGPoint tempPoint2 = CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);//求得  p1和p2 的中间点
    
    if (self.debug) {
        
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:p2 radius:3 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        [[UIColor redColor] set];
        [pointPath stroke];
        
        pointPath = [UIBezierPath bezierPathWithArcCenter:p1 radius:3 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        [pointPath stroke];
        
        pointPath = [UIBezierPath bezierPathWithArcCenter:p0 radius:3 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        [pointPath stroke];
        
        pointPath = [UIBezierPath bezierPathWithArcCenter:tempPoint1 radius:3 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        [pointPath stroke];
        
        pointPath = [UIBezierPath bezierPathWithArcCenter:tempPoint2 radius:3 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        [pointPath stroke];
        
    }
    
    // 估算贝塞尔曲线长度
    int x1 = fabs(tempPoint1.x - tempPoint2.x);  //tempPoint1，tempPoint2两个中间点的x距离绝对值
    int x2 = fabs(tempPoint1.y - tempPoint2.y);  //tempPoint1，tempPoint2两个中间点的x距离绝对值
    int len = (int)(sqrt(pow(x1, 2) + pow(x2, 2))*10); //算啥呢？ 开平方（x1 的平方 +x2的平方）*10  求两个中间点的距离 （a方+b方=c方，求c） 但为什么成10呢？
    
    
    // 如果只点了一下
    if (len == 0) {
        
        UIBezierPath *zeroPath = [UIBezierPath bezierPathWithArcCenter:p1 radius:kWIDTH_MAX * 0.5 - 2 startAngle:0 endAngle:M_PI *2.0 clockwise:YES];
        //设置填充色
        [[UIColor colorWithWhite:0 alpha:0.3] setFill];
        //开始填充
        [zeroPath fill];
        
        // 绘图
        UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext(); //从当前图像上下文获取图像
        self.image = tempImage; //更新self.image
        self.lastImage = tempImage; //更新self.lastImage
        UIGraphicsEndImageContext(); //绘制完成
        
        return;
        
    }
    
    // 如果距离过短，直接画直线 tempPoint1 到 tempPoint2
    if (len < 1) {
        UIBezierPath *zeroPath = [UIBezierPath bezierPath];
        [zeroPath moveToPoint:tempPoint1];
        [zeroPath addLineToPoint:tempPoint2];
        
       
//        self.currentWidth += 0.05;
//        
//        if (self.currentWidth > kWIDTH_MAX) {
//            self.currentWidth = kWIDTH_MAX;
//        }
//        if (self.currentWidth < kWIDTH_MIN) {
//            self.currentWidth = kWIDTH_MIN;
//        }
//        
        // 画线
        zeroPath.lineWidth = self.currentWidth; //设置宽度
        zeroPath.lineCapStyle = kCGLineCapRound; //线条拐角处理
        zeroPath.lineJoinStyle = kCGLineJoinRound; //终点处理
//        [[UIColor colorWithWhite:0 alpha:(self.currentWidth - kWIDTH_MIN)/ kWIDTH_MAX * 0.6 + 0.2] setStroke];//设置颜色
        [[UIColor colorWithWhite:0 alpha:0.3] setStroke];//设置颜色
        [zeroPath stroke]; //Draws line 根据坐标点连线   stroke  和  fill  方法的区别  stroke 是线， fill 是一个区域
        
        // 画图
        UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
        self.image = tempImage;
        UIGraphicsEndImageContext();
        return;
    }
    
    //下面是正常画线的情况
    // 目标半径
    CGFloat aimWidth = 300.0/(CGFloat)len * (kWIDTH_MAX - kWIDTH_MIN); //?这里计算什么?
    // 获取贝塞尔（曲线）点集
    
    NSArray * curvePoints = [self curveFactorizationWithFromPoint:tempPoint1
                                                          toPoint:tempPoint2
                                                    controlPoints:[NSArray arrayWithObject: self.points[1]] // 三个点的中间点
                                                            count:len];  //距离
    
    // 画每条线段
    CGPoint lastPoint = tempPoint1;
    
    for (int i = 0; i< len ; i++) {
        
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath moveToPoint:lastPoint];
        
        // 省略多余点
        CGFloat delta = sqrt(pow([curvePoints[i] CGPointValue].x - lastPoint.x, 2)+ pow([curvePoints[i] CGPointValue].y - lastPoint.y, 2));
        
        if (delta <1) {
            continue;
        }
        
        lastPoint = CGPointMake([curvePoints[i] CGPointValue].x, [curvePoints[i]CGPointValue].y);
        [bPath addLineToPoint:lastPoint];
        
        // 计算当前点
//        if (self.currentWidth > aimWidth) {
//            self.currentWidth -= 0.05;
//        }else {
//            self.currentWidth += 0.05;
//        }
//        
//        if (self.currentWidth > kWIDTH_MAX) {
//            self.currentWidth = kWIDTH_MAX;
//        }
//        
//        if (self.currentWidth < kWIDTH_MIN) {
//            self.currentWidth = kWIDTH_MIN;
//        }
        
        // 画线
        bPath.lineWidth = self.currentWidth;
        bPath.lineCapStyle = kCGLineCapRound;
        bPath.lineJoinStyle = kCGLineJoinRound;
//        [[UIColor colorWithWhite:0 alpha:(self.currentWidth - kWIDTH_MIN)/kWIDTH_MAX *0.3 +0.1] setStroke];
        [[UIColor colorWithWhite:0 alpha:0.3] setStroke];
        [bPath stroke];
    }
        // 保存图片
        self.lastImage = UIGraphicsGetImageFromCurrentImageContext();
        
        int pointCount = (int)sqrt(pow(tempPoint2.x - [self.points[2] CGPointValue].x, 2) + pow(tempPoint2.y - [self.points[2] CGPointValue].y, 2)) *2;
        
        CGFloat delX = (tempPoint2.x - [self.points[2] CGPointValue].x) /(CGFloat)pointCount;
        CGFloat delY = (tempPoint2.y - [self.points[2] CGPointValue].y) /(CGFloat)pointCount;
        
        CGFloat addRadius = self.currentWidth;
        
        // 尾部线段
        for (int i = 0; i < pointCount; i++) {
            UIBezierPath *bPath = [UIBezierPath bezierPath];
            [bPath moveToPoint:lastPoint];
            
            CGPoint newPoint = CGPointMake(lastPoint.x - delX, lastPoint.y - delY);
            lastPoint = newPoint;
            
            [bPath addLineToPoint:newPoint];
            
            
//            if (addRadius > aimWidth) {
//                addRadius -= 0.02;
//            }else {
//                addRadius += 0.02;
//            }
//            
//            if (addRadius > kWIDTH_MAX) {
//                addRadius = kWIDTH_MAX;
//            }
//            if (addRadius < 0) {
//                addRadius = 0;
//            }
            
            // 画线
            bPath.lineWidth = addRadius;
            bPath.lineJoinStyle = kCGLineJoinRound;
            bPath.lineCapStyle = kCGLineCapRound;
            
//            [[UIColor colorWithWhite:0 alpha:(self.currentWidth - kWIDTH_MIN)/ kWIDTH_MAX * 0.5 + 0.05] setStroke];
            [[UIColor colorWithWhite:0 alpha:0.3] setStroke];
            [bPath stroke];
            
        }
        
        UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
        self.image = tempImage;
        UIGraphicsEndImageContext();
    
}




/**
 分解贝塞尔曲线  获取贝塞尔点集

 @param fPoint 开始点
 @param tPoint to 点
 @param points 控制点集合
 @param count  fPoint 到 tPoint 的 距离
 @return 分解贝塞尔曲线的点集合 count + 1个
 */
- (NSArray *)curveFactorizationWithFromPoint:(CGPoint) fPoint
                                     toPoint:(CGPoint) tPoint
                               controlPoints:(NSArray *)points
                                       count:(int) count {
    
    // 如果分解数量为0，生成默认分解数量
    if (count == 0) {
        int x1 = fabs(fPoint.x - tPoint.x);
        int x2 = fabs(fPoint.y - tPoint.y);
        count = (int)sqrt(pow(x1, 2) + pow(x2, 2));
    }
    
    // 计算贝塞尔曲线
    CGFloat s = 0.0;
    NSMutableArray *t = [NSMutableArray array];// 创建包含n多s的数组，s都加了 一个小于1大于0的数
    CGFloat pc = 1/(CGFloat)count;  //小于1大于0的数
    
    int power = (int)(points.count + 1); // 一个数组，但只包含三个点中间的一个点，所以这个power 应该一直是2
    
    //创建包含count + 1个s的数组，s都加了 一个小于1大于0的数
    for (int i =0; i<= count + 1; i++) {
        [t addObject:[NSNumber numberWithFloat:s]];
        s = s + pc;
    }
    
    //记录count +1 新点
    NSMutableArray *newPoints = [NSMutableArray array];
    
    for (int i =0; i<=count +1; i++) {
        //获得新X
        CGFloat resultX = fPoint.x * [self bezMakerWithN:power K:0 T:[t[i] floatValue]]
                                        +
                                        tPoint.x * [self bezMakerWithN:power K:power T:[t[i] floatValue]];
        
        for (int j = 1; j<= power -1; j++) {
            
            resultX += [points[j-1] CGPointValue].x * [self bezMakerWithN:power K:j T:[t[i] floatValue]];
            
        }
        
        //获得新Y
        CGFloat resultY = fPoint.y * [self bezMakerWithN:power K:0 T:[t[i] floatValue]]
                                    +
                                    tPoint.y * [self bezMakerWithN:power K:power T:[t[i] floatValue]];
        
        for (int j = 1; j<= power -1; j++) {
            resultY += [points[j-1] CGPointValue].y * [self bezMakerWithN:power K:j T:[t[i] floatValue]];
        }
        
        [newPoints addObject:[NSValue valueWithCGPoint:CGPointMake(resultX, resultY)]];
    }
    
    return newPoints;
    
}



/**
 ？

 @param n <#n description#>
 @param k <#k description#>
 @return <#return value description#>
 */
- (CGFloat)compWithN:(int)n
                andK:(int)k {
    int s1 = 1;
    int s2 = 1;
    if (k == 0) {
        return 1.0;
    }
    for (int i = n; i>=n-k+1; i--) {
        s1 = s1*i;
    }
    for (int i = k;i>=2;i--) {
        s2 = s2 *i;
    }
    CGFloat res = (CGFloat)s1/s2;
    return  res;
}

/**
 真实的平方？

 @param n <#n description#>
 @param k <#k description#>
 @return <#return value description#>
 */
- (CGFloat)realPowWithN:(CGFloat)n
                      K:(int)k {
    if (k == 0) {
        return 1.0;
    }
    return pow(n, (CGFloat)k);
}

/**
 ？

 @param n <#n description#>
 @param k <#k description#>
 @param t <#t description#>
 @return 返回
 */
- (CGFloat)bezMakerWithN:(int)n
                       K:(int)k
                       T:(CGFloat)t {
    return [self compWithN:n andK:k] * [self realPowWithN:1-t K:n-k] * [self realPowWithN:t K:k];
}




#pragma mark - /*** 触摸事件 ***/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    
    NSValue *vp = [NSValue valueWithCGPoint:p];
    
    //记录三个vp？
    self.points = [NSMutableArray arrayWithObjects:vp,vp,vp, nil];
    
    self.currentWidth = 13;
    
    [self changeImage];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    
    NSValue *vp = [NSValue valueWithCGPoint:p];
    
    //剔除第一个vp，在队尾插入最新的vp？
    self.points = [NSMutableArray arrayWithObjects:_points[1],_points[2],vp, nil];
    
    [self changeImage];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.lastImage =  self.image;
}


@end



