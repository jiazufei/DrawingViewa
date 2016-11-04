//
//  DrawingViewb.m
//  DrawingView
//
//  Created by 曹飞 on 2016/11/4.
//  Copyright © 2016年 tv.buka. All rights reserved.
//

#import "DrawingViewb.h"
@interface DrawingViewb ()

@property (nonatomic, strong) UIBezierPath *path;

@end


@implementation DrawingViewb

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //create a mutable path
        self.path = [[UIBezierPath alloc] init];
        self.path.lineJoinStyle = kCGLineJoinRound;
        self.path.lineCapStyle = kCGLineCapRound;
        self.path.lineWidth = 5;
    }
    return self;
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
    
    //redraw the view
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //draw path
    [[UIColor clearColor] setFill];
    [[UIColor redColor] setStroke];
    [self.path stroke];
}

@end
