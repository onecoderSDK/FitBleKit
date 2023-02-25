/********************************************************************************
 * 文件名称：FBKProOldBandAnalytical.h
 * 内容摘要：老手环数据解析
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum{
    FBKAnalyticalOldBandAck = 0,      // 回复命令
    FBKAnalyticalOldBandFindPhone,    // 查找手机
    FBKAnalyticalOldBandVersion,      // 查找手机
    FBKAnalyticalOldBandRTSteps,      // 实时步数
    FBKAnalyticalOldBandRTHR,         // 实时心率
    FBKAnalyticalOldBandBigData,      // 大数据
    FBKAnalyOldBandSetShock,          // 设置震动阈值
    FBKAnalyOldBandGetShock,          // 获取震动阈值
    FBKAnalyOldBandCloseShock,        // 关闭震动功能
    FBKAnalyOldBandMaxInterval,       // 设置心率区间最大值
    FBKAnalyOldBandLightSwitch,       // 设置呼吸灯的开关
    FBKAnalyOldBandColorShock,        // 设置颜色变换震动功能
    FBKAnalyOldBandColorInterval,     // BLE颜色设置阈值
    FBKAnalyOldBandClearRecord,       // 清除历史存储数据
}FBKAnalyticalOldBand;


@protocol FBKProOldBandAnalyticalDelegate <NSObject>

// 解析数据返回
- (void)analyticalSucceed:(id)resultData withResultNumber:(int)resultNumber;

@end


@interface FBKProOldBandAnalytical : NSObject

// 回调协议
@property(assign,nonatomic)id <FBKProOldBandAnalyticalDelegate> delegate;

// 获取到蓝牙回复的数据
- (void)receiveBlueData:(NSString *)hexString;

// 获取到蓝牙回复的数据中断
- (void)receiveBlueDataError;

@end
