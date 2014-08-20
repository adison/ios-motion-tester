//
//  MotionDetector.m
//  motion-detect
//
//  Created by adison.wu on 2014/8/19.
//  Copyright (c) 2014年 adison.wu. All rights reserved.
//

#import "MotionDetector.h"

@interface MotionDetector(){
    CMMotionManager *manager;
}

@end

@implementation MotionDetector

-(void)getAccelemetor:(void(^)(CMAccelerometerData *aData))aBlock {
    if (manager == nil || !manager.isAccelerometerActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.accelerometerData);
    }
}

-(void)getGyro:(void(^)(CMGyroData* aData))aBlock {
    if (manager == nil || !manager.isGyroActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.gyroData);
    }
}

-(void)getDeviceMotion:(void(^)(CMDeviceMotion* aData))aBlock {
    if (manager == nil || !manager.isDeviceMotionActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.deviceMotion);
    }
}

-(void)getMagnet:(void(^)(CMMagnetometerData* aData))aBlock{
    if (manager == nil || !manager.isMagnetometerActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.magnetometerData);
    }
}

NSTimeInterval INTERVAL_UPDATE = 0.1f;

-(void)start {
    if (manager == nil) {
        manager = [[CMMotionManager alloc] init];
    }
    if (manager.isAccelerometerAvailable) {
        manager.accelerometerUpdateInterval = INTERVAL_UPDATE;
        [manager startAccelerometerUpdates];
    }
    if (manager.isGyroAvailable) {
        manager.gyroUpdateInterval = INTERVAL_UPDATE;
        [manager startGyroUpdates];
    }
    if (manager.isDeviceMotionAvailable) {
        manager.deviceMotionUpdateInterval = INTERVAL_UPDATE;
        [manager startDeviceMotionUpdates];
    }
    if (manager.isMagnetometerAvailable) {
        manager.magnetometerUpdateInterval = INTERVAL_UPDATE;
        [manager startMagnetometerUpdates];
    }
}

-(void)stop {
    if (manager == nil) {
        return;
    }
    [manager stopAccelerometerUpdates];
    [manager stopGyroUpdates];
    [manager stopDeviceMotionUpdates];
    [manager stopMagnetometerUpdates];
    manager = nil;
}

SYNTHESIZE_SINGLETON_FOR_CLASS(MotionDetector);
@end
