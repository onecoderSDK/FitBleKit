/********************************************************************************
 * 文件名称：FBKApiOldBand.h
 * 内容摘要：旧手环API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiOldBandDelegate <NSObject>

// 实时心率
- (void)getRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice;

// 查找手机
- (void)findPhone:(BOOL)status andDevice:(id)bleDevice;

// 实时步数
- (void)getRealTimeStepsData:(NSDictionary *)stepsDic andDevice:(id)bleDevice;

// 大数据
- (void)getBigData:(NSDictionary *)bigDataDic andDevice:(id)bleDevice;

@end


@interface FBKApiOldBand : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiOldBandDelegate> delegate;

// 设置个人基本信息
- (void)setUserInfoApi:(FBKDeviceUserInfo *)userInfo;

// 设置个人睡眠信息
- (void)setSleepInfoApi:(FBKDeviceSleepInfo *)sleepInfo;

// 设置单车参数命令
- (void)setBikeInfoApi:(NSString *)whellDiameter;

// 设置限制参数
- (void)setLimitInfoApi:(FBKDeviceLimit *)limitInfo;

// 获取历史数据
- (void)getRecordData;

@end
