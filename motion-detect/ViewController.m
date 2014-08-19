//
//  ViewController.m
//  motion-detect
//
//  Created by senao.mis on 2014/8/19.
//  Copyright (c) 2014年 senao.mis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    MotionDetector *detector;
    NSTimer *updator;
}

@end

@implementation ViewController
@synthesize lblAcc, lblGeny, lblMag, lblMotion;

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
//    [detector getDeviceMotion:^(CMDeviceMotion *aData) {
//        lblMotion.text = NSPRINTF(@"磁力？\nx :%+2.f\ny :%+2.f\nz :%+2.f",
//                               aData.m.x,
//                               aData.acceleration.y,
//                               aData.acceleration.z);
//    }];
    
}

-(void)runDetect {
    if(manager == nil) {
        manager = [[CMMotionManager alloc] init];
    }
    // 加速度
//    if (!manager.isAccelerometerAvailable){
//        lblAcc.text = @"加速度計不存在";
//        return;
//    }
//    else {
//        if (!manager.isAccelerometerActive ) {
//            lblAcc.text = @"加速度計未啟動";
//        }
//        // 取得資料顯示
//        NSOperationQueue *op1 = [[NSOperationQueue alloc] init];
//        manager.accelerometerUpdateInterval = .2f;
//        [manager
//         startAccelerometerUpdatesToQueue:op1
//         withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//             if (error) {
//                 [manager stopAccelerometerUpdates];
//                 strAcc = NSPRINTF(@"加速度計有錯誤 %@", error);
//                 [lblAcc performSelectorOnMainThread:@selector(setText:) withObject:strAcc waitUntilDone:YES];
//                 return;
//             }
//             strAcc = NSPRINTF(@"加速度計\nx: %+.2f\ny:%+.2f \n z:%+.2f",
//                                    accelerometerData.acceleration.x,
//                                    accelerometerData.acceleration.y,
//                                    accelerometerData.acceleration.z);
//             [lblAcc performSelectorOnMainThread:@selector(setText:) withObject:strAcc waitUntilDone:YES];
//         }];
//    }
    
    
    // 陀螺儀
    // 加速度
//    if (!manager.isGyroAvailable){
//        lblAcc.text = @"陀螺儀不存在";
//        return;
//    }
//    else {
//        if (!manager.isGyroActive ) {
//            lblAcc.text = @"陀螺儀未啟動";
//        }
//        // 取得資料顯示
//        NSOperationQueue *op2 = [[NSOperationQueue alloc] init];
//        manager.gyroUpdateInterval = .2f;
//        [manager
//         startGyroUpdatesToQueue:op2
//         withHandler:^(CMGyroData *gyroData, NSError *error) {
//             if (error) {
//                 [lblGeny performSelectorOnMainThread:@selector(setText:)
//                                           withObject:NSPRINTF(@"陀螺儀錯誤 %@", error)
//                                        waitUntilDone:YES];
//                 [manager stopGyroUpdates];
//                 return ;
//             }
//             [lblGeny performSelectorOnMainThread:@selector(setText:)
//                                       withObject:NSPRINTF(@"陀螺儀\nx: %+.2f\ny: %+.2f\nz: %+.2f",
//                                                           gyroData.rotationRate.x *1000,
//                                                           gyroData.rotationRate.y*1000,
//                                                           gyroData.rotationRate.z*1000)
//                                    waitUntilDone:YES];
//         }];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    lblAcc.numberOfLines = 5;
    lblGeny.numberOfLines = 5;
    lblMag.numberOfLines = 5;
    lblMotion.numberOfLines = 5;
//    [self runDetect];
    
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
