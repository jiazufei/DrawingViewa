//
//  ViewController.m
//  DrawingView
//
//  Created by 曹飞 on 2016/11/4.
//  Copyright © 2016年 tv.buka. All rights reserved.
//

#import "ViewController.h"

#import "DrawingViewa.h"
#import "DrawingViewb.h"
#import "DrawingViewc.h"
#import "DrawingViewd.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popView:(id)sender {
    
    DrawingViewa * dv = [[DrawingViewa alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height )];
    dv.center = self.view.center;
    dv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dv];
    
}

- (IBAction)popViewb:(id)sender {
    
    DrawingViewb * dv = [[DrawingViewb alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height )];
    dv.center = self.view.center;
    dv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dv];
    
}

- (IBAction)popViewc:(id)sender {
    
    DrawingViewc * dv = [[DrawingViewc alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height )];
    dv.center = self.view.center;
    dv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dv];
    
}
- (IBAction)popViewd:(id)sender {
    
    DrawingViewd * dv = [[DrawingViewd alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height )];
    dv.center = self.view.center;
    dv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dv];
    
}

@end
