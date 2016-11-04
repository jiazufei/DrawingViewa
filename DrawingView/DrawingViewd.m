//
//  DrawingViewd.m
//  DrawingView
//
//  Created by 曹飞 on 2016/11/4.
//  Copyright © 2016年 tv.buka. All rights reserved.
//

#import "DrawingViewd.h"
#import <QuartzCore/QuartzCore.h>
#define BRUSH_SIZE 32
@interface DrawingViewd ()
@property (nonatomic, strong) NSMutableArray *strokes;

@end
@implementation DrawingViewd

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //create array
        self.strokes = [NSMutableArray array];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add brush stroke
    [self addBrushStrokeAtPoint:point];
}

//- (void)addBrushStrokeAtPoint:(CGPoint)point
//{
//    //add brush stroke to array
//    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
//    
//    //needs redraw
//    [self setNeedsDisplay];
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    //redraw strokes
//    for (NSValue *value in self.strokes) {
//        //get point
//        CGPoint point = [value CGPointValue];
//        
//        //get brush rect
//        CGRect brushRect = CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
//        
//        //draw brush stroke    ￼
//        [[UIImage imageNamed:@"Chalk.png"] drawInRect:brushRect];
//    }
//}


- (void)addBrushStrokeAtPoint:(CGPoint)point
{
    //add brush stroke to array
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    //set dirty rect
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}

- (CGRect)brushRectForPoint:(CGPoint)point
{
    return CGRectMake(point.x - BRUSH_SIZE/2, point.y - BRUSH_SIZE/2, BRUSH_SIZE, BRUSH_SIZE);
}

- (void)drawRect:(CGRect)rect
{
    //redraw strokes
    for (NSValue *value in self.strokes) {
        //get point
        CGPoint point = [value CGPointValue];
        
        //get brush rect
        CGRect brushRect = [self brushRectForPoint:point];
        //only draw brush stroke if it intersects dirty rect
        if (CGRectIntersectsRect(rect, brushRect)) {
            //draw brush stroke
            [[UIImage imageNamed:@"bg_scan_red"] drawInRect:brushRect];
        }
    }
}

@end
