/********************************************************************************
 * 文件名称：FBKApiHeartRate.h
 * 内容摘要：心率设备API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiHeartRateDelegate <NSObject>

// 实时心率
- (void)getRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice;

// 心率历史
- (void)getHeartRateRecord:(NSDictionary *)HRData andDevice:(id)bleDevice;

// HRV数据
- (void)HRHrvResultData:(BOOL)status withData:(NSDictionary *)hrvMap andDevice:(id)bleDevice;

- (void)setHRShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)getHRShockStatus:(NSDictionary *)dataMap andDevice:(id)bleDevice;

- (void)closeHRShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setHRMaxIntervalStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setHRLightSwitchStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setHRColorShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setHRColorIntervalStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)clearHRRecordStatus:(BOOL)status andDevice:(id)bleDevice;

@end


@interface FBKApiHeartRate : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiHeartRateDelegate> delegate;

// 获取历史数据
- (void)getRecordHrData;

- (void)enterHRVMode:(BOOL)status;

// 设置震动阈值
- (void)setShock:(int)shockNumber;

// 获取震动阈值
- (void)getShock;

// 关闭震动功能
- (void)closeShock;

// 设置心率区间最大值
- (void)setMaxInterval:(int)maxNumber;

// 设置呼吸灯的开关
- (void)setLightSwitch:(BOOL)isOpen;

// 设置颜色变换震动功能
- (void)setColorShock:(BOOL)isOpen;

// BLE颜色设置阈值
- (void)setColorInterval:(int)colorNumber;

// 清除历史存储数据
- (void)clearRecord;

@end
