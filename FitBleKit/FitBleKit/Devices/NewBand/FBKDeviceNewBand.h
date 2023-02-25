/********************************************************************************
 * 文件名称：FBKDeviceNewBand.h
 * 内容摘要：新手环
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKDeviceBaseInfo.h"
#import "FBKDeviceUserInfo.h"

@interface FBKDeviceNewBand : FBKDeviceBaseInfo

// 基本信息
@property (strong,nonatomic) FBKDeviceUserInfo *userInfo;

// 睡眠信息
@property (strong,nonatomic) FBKDeviceSleepInfo *sleepInfo;

// 喝水提醒
@property (strong,nonatomic) FBKDeviceIntervalInfo *waterInfo;

// 久坐提醒
@property (strong,nonatomic) FBKDeviceIntervalInfo *sitInfo;

// 消息提醒
@property (strong,nonatomic) FBKDeviceNoticeInfo *noticeInfo;

// 闹钟提醒
@property (strong,nonatomic) NSArray *alarmArray;

// 最大心率值
@property (strong,nonatomic) NSString *maxHeartRate;

// 单车轮径
@property (strong,nonatomic) NSString *whellDiameter;

// 心率间隔时间
@property (strong,nonatomic) NSString *HRIntervalTime;

// 协议版本
@property (strong,nonatomic) NSString *protocolVersion;

// 上次同步时间
@property (strong,nonatomic) NSString *lastTimeSync;

// 实时手环数据
@property (strong,nonatomic) NSDictionary *lastTimeSteps;

// 每天总数据
@property (strong,nonatomic) NSArray *dayTotalArray;

// 细分步数
@property (strong,nonatomic) NSArray *stepsArray;

// 细分睡眠
@property (strong,nonatomic) NSArray *sleepArray;

// 细分心率
@property (strong,nonatomic) NSArray *heartRateArray;

// 跑步记录
@property (strong,nonatomic) NSArray *runArray;

// 骑行记录
@property (strong,nonatomic) NSArray *rideArray;

@end

