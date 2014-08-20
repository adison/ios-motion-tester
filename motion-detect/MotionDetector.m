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

/**
 *  背景光量
 */
-(void)testLightSensor {
    // app store 不接受的東西
    // http://iphonedevwiki.net/index.php/AppleISL29003
}

/**
 *  CPU 用量
 */
-(void)getCpuUsage {
    NSLog(@"CPU Usage %+2.f", cpu_usage());
    
}

// from http://stackoverflow.com/questions/8223348/ios-get-cpu-usage-from-application
float cpu_usage() {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}


/**
 *  統計網路流量
 */
-(void)getNetworkFlow {
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name = @"";
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    NSLog(@"%@", @[[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived]]);
}

/**
 *  呼叫閃光燈
    有則閃三下
    沒有就表示有問題
 */
-(void)testFlash {
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn]) {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success) {
            if ([flashLight isTorchActive]) {
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            else {
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }
            [flashLight unlockForConfiguration];
        }
    }
    NSLog(@"Screen Brightness: %f",[[UIScreen mainScreen] brightness]);
}

/**
 *  測試進接感應器，需要有更好的測試方法
 */
-(void)testProximitySensor {
    UIDevice *dd = [UIDevice currentDevice];
    dd.proximityMonitoringEnabled = YES;
    if (dd.proximityMonitoringEnabled == YES) {
        NSLog(@"有進接感應器，請觸控");
        NSLog(@" %@", dd.proximityState? @"進階中" : @"魏晉接");
    }
    dd.proximityMonitoringEnabled = NO;
}


/**
 *  加速計
 */
-(void)getAccelemetor:(void(^)(CMAccelerometerData *aData))aBlock {
    if (manager == nil || !manager.isAccelerometerActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.accelerometerData);
    }
}

/**
 *  陀螺儀
 */
-(void)getGyro:(void(^)(CMGyroData* aData))aBlock {
    if (manager == nil || !manager.isGyroActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.gyroData);
    }
}

/**
 *  裝置動態
 */
-(void)getDeviceMotion:(void(^)(CMDeviceMotion* aData))aBlock {
    if (manager == nil || !manager.isDeviceMotionActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.deviceMotion);
    }
}

/**
 *  磁力計
 */
-(void)getMagnet:(void(^)(CMMagnetometerData* aData))aBlock{
    if (manager == nil || !manager.isMagnetometerActive) {
        aBlock(nil);
    }
    else {
        aBlock(manager.magnetometerData);
    }
}


NSTimeInterval INTERVAL_UPDATE = 0.1f;
/**
 *  啟動 CMMotionManager
 */
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

/**
 *  停止 CMMotionManager
 */
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
