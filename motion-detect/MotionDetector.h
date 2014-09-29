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
#import <AVFoundation/AVFoundation.h>
#include <arpa/inet.h> 
#include <net/if.h> 
#include <ifaddrs.h>
#include <net/if_dl.h>
#import <mach/mach.h>


@interface MotionDetector : NSObject

-(void)testFlash;
-(void)testProximitySensor;
-(void)testLightSensor;
-(void)getNetworkFlow;
-(void)getCpuUsage;


-(void)getAccelemetor:(void(^)(CMAccelerometerData *aData))aBlock;
-(void)getGyro:(void(^)(CMGyroData* aData))aBlock;
-(void)getDeviceMotion:(void(^)(CMDeviceMotion* aData))aBlock;
-(void)getMagnet:(void(^)(CMMagnetometerData* aData))aBlock;

-(void)stop;
-(void)start;

+(instancetype)sharedManager;

@end
