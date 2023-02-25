/********************************************************************************
 * 文件名称：FBKDeviceNewBand.m
 * 内容摘要：新手环
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKDeviceNewBand.h"

@implementation FBKDeviceNewBand

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.userInfo        = [[FBKDeviceUserInfo alloc] init];
    self.sleepInfo       = [[FBKDeviceSleepInfo alloc] init];
    self.waterInfo       = [[FBKDeviceIntervalInfo alloc] init];
    self.sitInfo         = [[FBKDeviceIntervalInfo alloc] init];
    self.noticeInfo      = [[FBKDeviceNoticeInfo alloc] init];
    self.alarmArray      = [[NSArray alloc] init];
    self.maxHeartRate    = [[NSString alloc] init];
    self.whellDiameter   = [[NSString alloc] init];
    self.HRIntervalTime  = [[NSString alloc] init];
    self.protocolVersion = [[NSString alloc] init];
    self.lastTimeSync    = [[NSString alloc] init];
    self.lastTimeSteps   = [[NSDictionary alloc] init];
    self.dayTotalArray   = [[NSArray alloc] init];
    self.stepsArray      = [[NSArray alloc] init];
    self.sleepArray      = [[NSArray alloc] init];
    self.heartRateArray  = [[NSArray alloc] init];
    self.runArray        = [[NSArray alloc] init];
    self.rideArray       = [[NSArray alloc] init];
    
    return self;
}

@end

