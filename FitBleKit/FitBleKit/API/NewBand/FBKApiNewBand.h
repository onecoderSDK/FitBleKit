/********************************************************************************
 * 文件名称：FBKApiNewBand.h
 * 内容摘要：新手环API
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"
#import "FBKDeviceUserInfo.h"

@protocol FBKApiNewBandDelegate <NSObject>

// 实时心率
- (void)getRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice;

// 查找手机
- (void)findPhone:(BOOL)status andDevice:(id)bleDevice;

// 照相
- (void)takePhoto:(id)bleDevice;

// 音乐控制
- (void)getMusicStatus:(MusicStatus)musicStatus andDevice:(id)bleDevice;

// 上次同步时间
- (void)getLastSyncTime:(NSString *)syncTime andDevice:(id)bleDevice;

// 硬件版本号
- (void)getDeviceVersion:(NSString *)version andDevice:(id)bleDevice;

// 实时步数
- (void)getRealTimeStepsData:(NSDictionary *)stepsDic andDevice:(id)bleDevice;

// 大数据
- (void)getBigData:(NSDictionary *)bigDataDic andDevice:(id)bleDevice;

@end

@interface FBKApiNewBand : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiNewBandDelegate> delegate;

// 设置时间
- (void)setUtc;

// 设置个人基本信息
- (void)setUserInfoApi:(FBKDeviceUserInfo *)userInfo;

// 设置个人睡眠信息
- (void)setSleepInfoApi:(FBKDeviceSleepInfo *)sleepInfo;

// 设置个人喝水信息
- (void)setWaterInfoApi:(FBKDeviceIntervalInfo *)waterInfo;

// 设置个人久坐信息
- (void)setSitInfoApi:(FBKDeviceIntervalInfo *)sitInfo;

// 设置个人通知信息
- (void)setNoticeInfoApi:(FBKDeviceNoticeInfo *)noticeInfo;

// 设置个人闹钟信息
- (void)setAlarmInfoApi:(NSArray *)alarmInfoArray;

// 设置单车参数命令
- (void)setBikeInfoApi:(NSString *)whellDiameter;

// 设置心率最大值命令
- (void)setHeartRateMaxApi:(NSString *)maxRate;

// 开启实时数据
- (void)openRealTimeStepsApi:(BOOL)status;

// 开启拍照
- (void)openTakePhotoApi:(BOOL)status;

// 开启心率模式
- (void)openHeartRateModeApi:(BOOL)status;

- (void)openHRTenModeApi:(BOOL)status;

// 开启配对
- (void)openANCSModeApi:(BOOL)status;

// 获取所有历史数据
- (void)getTotalHistory;

// 获取运动历史数据
- (void)getStepHistory;

// 获取心率历史数据
- (void)getHeartRateHistory;

// 获取踏频历史数据
- (void)getBikeHistory;

// 获取训练历史数据
- (void)getTrainHistory;

// 获取睡眠历史数据
- (void)getSleepHistory;

// 获取每天步数总和历史数据
- (void)getEverydayHistory;

@end
