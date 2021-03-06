//
//  DrawingViewa.m
//  DrawingView
//
//  Created by 曹飞 on 2016/11/4.
//  Copyright © 2016年 tv.buka. All rights reserved.
//

#import "DrawingViewa.h"
#import <QuartzCore/QuartzCore.h>

@interface DrawingViewa ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation DrawingViewa

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        
        //configure the layer
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.strokeColor = [UIColor colorWithRed:17.0/255.0 green:102.0/255.0 blue:222.0/255.0 alpha:0.3].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 5;
    }
    return self;
}
+ (Class)layerClass
{
    //this makes our view create a CAShapeLayer
    //instead of a CALayer for its backing layer
    return [CAShapeLayer class];
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add a new line segment to our path
    [self.path addLineToPoint:point];
    
    //update the layer with a copy of the path
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}
@end
