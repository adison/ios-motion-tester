//
//  ViewController.m
//  motion-detect
//
//  Created by adison.wu on 2014/8/19.
//  Copyright (c) 2014年 adison.wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    MotionDetector *detector;
    NSTimer *updator;
}

@end

@implementation ViewController
@synthesize lblAcc, lblGeny, lblMag, lblMotion;

-(IBAction)toggleFlash:(id)sender {
    [detector testFlash];
    [detector testProximitySensor];
}

-(void)refreshData {
    [detector getMagnet:^(CMMagnetometerData *aData) {
        lblMag.text = NSPRINTF(@"磁力？\nx :%+.2f\ny :%+.2f\nz :%+.2f",
                               aData.magneticField.x,
                               aData.magneticField.y,
                               aData.magneticField.z);
    }];
    
    [detector getAccelemetor:^(CMAccelerometerData *aData) {
        lblAcc.text = NSPRINTF(@"加速度？\nx :%+.2f\ny :%+.2f\nz :%+.2f",
                               aData.acceleration.x,
                               aData.acceleration.y,
                               aData.acceleration.z);
    }];
    [detector getGyro:^(CMGyroData *aData) {
        lblGeny.text = NSPRINTF(@"陀螺？\nx :%+.2f\ny :%+.2f\nz :%+.2f",
                                aData.rotationRate.x,
                                aData.rotationRate.y,
                                aData.rotationRate.z);
    }];
    
    [detector getNetworkFlow];
    [detector getCpuUsage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    lblAcc.numberOfLines = 5;
    lblGeny.numberOfLines = 5;
    lblMag.numberOfLines = 5;
    lblMotion.numberOfLines = 5;
    
    [[MotionDetector sharedManager] start];
    detector = [MotionDetector sharedManager];
    
    updator = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                               target:self
                                             selector:@selector(refreshData)
                                             userInfo:nil
                                              repeats:YES];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
