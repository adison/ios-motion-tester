//
//  MotionDetector.h
//  motion-detect
//
//  Created by adison.wu on 2014/8/19.
//  Copyright (c) 2014年 adison.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import <CoreMotion/CoreMotion.h>
@interface MotionDetector : NSObject

-(void)getAccelemetor:(void(^)(CMAccelerometerData *aData))aBlock;
-(void)getGyro:(void(^)(CMGyroData* aData))aBlock;
-(void)getDeviceMotion:(void(^)(CMDeviceMotion* aData))aBlock;
-(void)getMagnet:(void(^)(CMMagnetometerData* aData))aBlock;

-(void)stop;
-(void)start;
+(instancetype)sharedManager;

@end
