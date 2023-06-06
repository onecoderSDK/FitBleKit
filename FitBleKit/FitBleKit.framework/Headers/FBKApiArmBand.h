/********************************************************************************
 * 文件名称：FBKApiArmBand.h
 * 内容摘要：臂带API
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"


typedef enum{
    InvalidCmdGetAge = 7,             // 获取年龄
    InvalidCmdSetAge = 8,             // 设置年龄
    InvalidCmdSetShock = 9,           // 设置震动阈值
    InvalidCmdGetShock = 10,          // 获取震动阈值
    InvalidCmdCloseShock = 11,        // 关闭震动功能
    InvalidCmdSetMaxHr = 12,          // 设置心率区间最大值
    InvalidCmdGetMaxHR = 13,          // 获取心率区间最大值
    InvalidCmdSetLightSwitch = 17,    // 设置呼吸灯的开关
    InvalidCmdGetLightSwitch = 18,    // 获取呼吸灯的开关
    InvalidCmdGetSetting = 19,        // 获取设置信息
}ArmBandInvalidCmd;


@protocol FBKApiArmBandDelegate <NSObject>

// 实时心率
- (void)armBandRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice;

// 硬件版本号
- (void)armBandVersion:(NSString *)version andDevice:(id)bleDevice;

// 实时步频
- (void)armBandStepFrequency:(NSDictionary *)frequencyDic andDevice:(id)bleDevice;

// 实时温度
- (void)armBandTemperature:(NSDictionary *)temMap andDevice:(id)bleDevice;

// 实时血氧
- (void)armBandSPO2:(NSDictionary *)spo2Map andDevice:(id)bleDevice;

// HRV数据
- (void)HRVResultData:(NSDictionary *)hrvMap andDevice:(id)bleDevice;

- (void)ABHrvResultData:(BOOL)status withData:(NSDictionary *)hrvMap andDevice:(id)bleDevice;

// 大数据
- (void)armBandDetailData:(NSDictionary *)dataDic andDevice:(id)bleDevice;

- (void)getAgeNumber:(int)age andDevice:(id)bleDevice;

- (void)setAgeStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)getShockStatus:(NSDictionary *)dataMap andDevice:(id)bleDevice;

- (void)closeShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setMaxIntervalStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)getMaxInterval:(int)maxHr andDevice:(id)bleDevice;

- (void)setLightSwitchStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)getLightSwitch:(int)lightSwitch andDevice:(id)bleDevice;

- (void)getSettting:(NSDictionary *)dataMap andDevice:(id)bleDevice;

- (void)invalidCmd:(ArmBandInvalidCmd)cmdId andDevice:(id)bleDevice;

- (void)setColorShockStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)setColorIntervalStatus:(BOOL)status andDevice:(id)bleDevice;

- (void)clearRecordStatus:(BOOL)status andDevice:(id)bleDevice;

// 设备MAC地址
- (void)deviceMacAddress:(NSDictionary *)macMap andDevice:(id)bleDevice;

// 设备版本号
- (void)totalVersion:(NSDictionary *)versionMap andDevice:(id)bleDevice;

// 加速度数据
- (void)accelerationData:(NSArray *)accArray andDevice:(id)bleDevice;


- (void)setPrivateFiveZone:(BOOL)status andDevice:(id)bleDevice;

- (void)openSettingShow:(BOOL)status andDevice:(id)bleDevice;

- (void)closeSettingShow:(BOOL)status andDevice:(id)bleDevice;

- (void)maxOxyResult:(int)maxOxygen andDevice:(id)bleDevice;

@end


@interface FBKApiArmBand : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiArmBandDelegate> delegate;

// 协议
@property(assign,nonatomic)BOOL isHaveMaxOxygen;

// 设置时间
- (void)setArmBandTime;

// 设置心率最大值
- (void)setHeartRateMax:(NSString *)maxRate;

// 设置心率区间颜色
- (void)setHeartRateColor:(FBKDeviceHRColor *)hrColor;

// 进入HRV模式
- (void)enterHRVMode:(BOOL)status isSendCmd:(BOOL)isSend;

// 进入SPO2模式
- (void)enterSPO2Mode:(BOOL)status;

// 进入温度模式
- (void)enterTemperatureMode:(BOOL)status;

// set Hrv Time
- (void)setHrvTime:(int)seconds;

// 获取所有历史数据
- (void)getArmBandTotalHistory;

- (void)getDeviceAge;

- (void)setDeviceAge:(int)ageNumber;

// 设置震动阈值
- (void)setShock:(int)shockNumber;

// 获取震动阈值
- (void)getShock;

// 关闭震动功能
- (void)closeShock;

// 设置心率区间最大值
- (void)setMaxInterval:(int)maxNumber;

- (void)getMaxInterval;

// 设置呼吸灯的开关
- (void)setLightSwitch:(BOOL)isOpen;

- (void)getLightSwitch;

- (void)getDeviceSetting;

// 设置颜色变换震动功能
- (void)setColorShock:(BOOL)isOpen;

// BLE颜色设置阈值
- (void)setColorInterval:(int)colorNumber;

// 清除历史存储数据
- (void)clearRecord;

- (void)getDeviceMacAddress;

- (void)getDeviceVersion;

- (void)enterOTAMode;

- (void)setDataFrequency:(int)dataFrequency;


// 智云医康定制指令
- (void)setPrivateFiveZone:(NSArray *)zoneArray;

- (void)openSettingShow;

- (void)closeSettingShow;

- (void)readMaxOxygen;

@end
