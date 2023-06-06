/********************************************************************************
 * 文件名称：FBKProNewBandAnalytical.h
 * 内容摘要：新手环解析数据
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKProNTrackerBigData.h"
#import "FBKEnumList.h"

typedef enum{
    FBKAnalyticalSendSuseed = 0, // 发送命令成功
    FBKAnalyticalAck,            // 回复命令
    FBKAnalyticalFindPhone,      // 查找手机
    FBKAnalyticalTakePhoto,      // 照相
    FBKAnalyticalMusicStatus,    // 音乐控制
    FBKAnalyticalLastSyncTime,   // 最后同步时间
    FBKAnalyticalDeviceVersion,  // 硬件版本号
    FBKAnalyticalRealTimeHR,     // 实时心率
    FBKAnalyticalRealTimeSteps,  // 实时步数
    FBKAnalyticalRTStepFrequency,// 实时步频
    FBKAnalyticalRTTem,          // 实时温度
    FBKAnalyticalRTSPO2,         // 实时血氧
    FBKAnalyticalHRVData,        // HRV数据
    FBKAnalyticalRTFistInfo,     // 实时拳击数据
    FBKAnalyticalRTWeight,       // 实时秤数据
    FBKAnalyticalBigData,        // 大数据
    FBKAnalyticalFitList,        // fit文件列表
    FBKAnalyticalFitData,        // fit文件数据
    FBKAnalyticalSyncing,        // 同步大数据中...
    FBKAnalyticalHubLoginStatus, // hub 登录状态
    FBKAnalyticalHubLoginPw,     // hub 登录密码
    FBKAnalyticalHubWifiWorkMode,// hub wifi工作模式
    FBKAnalyticalHubWifiSTA,     // hub wifi STA 信息
    FBKAnalyticalHubWifiSocket,  // hub wifi Socket 信息
    FBKAnalyticalHubNetWorkMode, // hub 内外网模式
    FBKAnalyticalHubRemark,      // hub 备注信息
    FBKAnalyticalHubIpKey,       // hub IP Key
    FBKAnalyticalHubWifiList,    // hub wifi 列表
    FBKAnalyticalHubWifiStatus,  // hub wifi 状态
    FBKAnalyticalHub4GAPN,       // 上传4G APN信息
    FBKAnalyticalHubSystemStatus, // 上传系统状态
    FBKAnalyticalHubIPV4,         // 上传IPV4信息
    FBKAnalyticalSetLora,         // 设置Lora通道
    FBKAnalyticalDiagnosisLora,   // 诊断Lora通道
    
    FBKArmBandResultGetAge,            // 获取年龄
    FBKArmBandResultSetAge,            // 设置年龄
    FBKArmBandResultSetShock,          // 设置震动阈值
    FBKArmBandResultGetShock,          // 获取震动阈值
    FBKArmBandResultCloseShock,        // 关闭震动功能
    FBKArmBandResultMaxInterval,       // 设置心率区间最大值
    FBKArmBandResultGetMaxHR,          // 获取心率区间最大值
    FBKArmBandResultLightSwitch,       // 设置呼吸灯的开关
    FBKArmBandResultGetLightSwitch,    // 获取呼吸灯的开关
    FBKArmBandResultGetSetting,        // 获取设置信息
    FBKArmBandResultInvalidCmd,        // 无效指令
    FBKArmBandResultColorShock,        // 设置颜色变换震动功能
    FBKArmBandResultColorInterval,     // BLE颜色设置阈值
    FBKArmBandResultClearRecord,       // 清除历史存储数据
    FBKArmBandResultMacAddress,        // MAC地址
    FBKArmBandResultAllVersion,        // 全部的版本号
    FBKArmBandResultECG,               // ECG数据
    FBKArmBandResultECGCOLOR,          // ECG颜色
    FBKArmBandResultECGSwitch,         // ECG数据开关
    FBKECGResultRealHR,                // ECG实时心率数据
    FBKResultAcceleration,             // 加速度数据
    FBKResultBoxingAxis,               // 轴设置结果
    FBKResultBoxingAxisSwitch,         // 轴开关设置结果
    FBKResultAxisList,                 // 轴数据
    
    FBKArmBandResultFiveZone,      // 设置区间UI的展示
    FBKArmBandResultOpenShow,      // 开启设定显示
    FBKArmBandResultCloseShow,     // 关闭设定显示
    
    FBKRunningResultRealData,          // Running
    FBKErgometerResultRealData,        // 拉力计
}FBKAnalyticalNumber;

@protocol FBKProNewBandAnalyticalDelegate <NSObject>

// 解析数据返回
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalNumber)resultNumber;

@end


@interface FBKProNTrackerAnalytical : NSObject<FBKProNTrackerBigDataDelegate>

// 回调协议
@property(assign,nonatomic)id <FBKProNewBandAnalyticalDelegate> delegate;

// 设备类型
@property(assign,nonatomic) BleDeviceType analyticalDeviceType;

// 获取到蓝牙回复的数据
- (void)receiveBlueData:(NSString *)hexString;

// 获取到蓝牙回复的数据中断
- (void)receiveBlueDataError;

@end
