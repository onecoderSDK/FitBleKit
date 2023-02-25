/********************************************************************************
 * 文件名称：FBKDeviceUserInfo.m
 * 内容摘要：用户基本信息结构
 * 版本编号：1.0.1
 * 创建日期：2017年11月02日
 ********************************************************************************/

#import "FBKDeviceUserInfo.h"

// 用户基本信息
@implementation FBKDeviceUserInfo

- (id)init
{
    self.weight   = [[NSString alloc] init];
    self.height   = [[NSString alloc] init];
    self.age      = [[NSString alloc] init];
    self.gender   = [[NSString alloc] init];
    self.walkGoal = [[NSString alloc] init];
    
    return self;
}

@end


// 用户睡眠信息
@implementation FBKDeviceSleepInfo

- (id)init
{
    self.normalStart   = [[NSString alloc] init];
    self.normalEnd     = [[NSString alloc] init];
    self.weekdayStart  = [[NSString alloc] init];
    self.weekdaylEnd   = [[NSString alloc] init];
    
    return self;
}

@end


// 用户睡眠信息
@implementation FBKDeviceLimit

- (id)init
{
    self.limitSteps   = [[NSString alloc] init];
    self.limitMinutes     = [[NSString alloc] init];
    self.timeInterval  = [[NSString alloc] init];
    self.stepStandard   = [[NSString alloc] init];
    
    return self;
}

@end


// 用户定时间隔提醒信息
@implementation FBKDeviceIntervalInfo

- (id)init
{
    self.amTime       = [[NSString alloc] init];
    self.pmTime       = [[NSString alloc] init];
    self.intervalTime = [[NSString alloc] init];
    self.switchStatus = [[NSString alloc] init];
    
    return self;
}

@end


// 用户消息提醒信息
@implementation FBKDeviceNoticeInfo

- (id)init
{
    self.missedCall   = [[NSString alloc] init];
    self.mail         = [[NSString alloc] init];
    self.shortMessage = [[NSString alloc] init];
    self.weChat       = [[NSString alloc] init];
    self.qq           = [[NSString alloc] init];
    self.skype        = [[NSString alloc] init];
    self.whatsAPP     = [[NSString alloc] init];
    self.faceBook     = [[NSString alloc] init];
    self.others       = [[NSString alloc] init];
    
    return self;
}

@end


// 用户闹钟提醒信息
@implementation FBKDeviceAlarmInfo

- (id)init
{
    self.alarmId      = [[NSString alloc] init];
    self.alarmName    = [[NSString alloc] init];
    self.alarmTime    = [[NSString alloc] init];
    self.repeatTime   = [[NSArray alloc] init];
    self.switchStatus = [[NSString alloc] init];
    
    return self;
}

@end


// 用户秤信息
@implementation FBKDeviceScaleInfo

- (id)init
{
    self.scaleUserId = [[NSString alloc] init];
    self.scaleAge    = [[NSString alloc] init];
    self.scaleHeight = [[NSString alloc] init];
    self.scaleGender = [[NSString alloc] init];
    
    return self;
}

@end


// 心率区间颜色
@implementation FBKDeviceHRColor

- (id)init
{
    self.ColorOne   = [[NSString alloc] init];
    self.ColorTwo   = [[NSString alloc] init];
    self.ColorThree = [[NSString alloc] init];
    self.ColorFour  = [[NSString alloc] init];
    self.ColorFive  = [[NSString alloc] init];
    
    return self;
}

@end


// 加速度数据
@implementation FBKParaAcceleration

- (id)init {
    self.timeStamp = 0;
    self.xAxis = 0;
    self.yAxis = 0;
    self.zAxis = 0;
    
    return self;
}

@end


