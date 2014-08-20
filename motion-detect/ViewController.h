//
//  ViewController.h
//  motion-detect
//
//  Created by adison.wu on 2014/8/19.
//  Copyright (c) 2014年 adison.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "commonMacro.h"
#import "MotionDetector.h"

@interface ViewController : UIViewController {
    
    CMMotionManager *manager;
    NSString *strAcc;
}

// 加速度
@property (nonatomic) IBOutlet UILabel *lblAcc;
// 陀螺儀
@property (nonatomic) IBOutlet UILabel *lblGeny;
// 磁力
@property (nonatomic) IBOutlet UILabel *lblMag;
// 動態
@property (nonatomic) IBOutlet UILabel *lblMotion;

@end
