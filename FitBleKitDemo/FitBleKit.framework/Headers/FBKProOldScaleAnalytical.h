/********************************************************************************
 * 文件名称：FBKProOldScaleAnalytical.h
 * 内容摘要：老秤数据解析
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum{
    FBKAnalyOScaleAck = 0,    // 回复命令
    FBKAnalyOScaleRealTime,   // 实时称重数据
    FBKAnalyOScaleStable,     // 稳定称重数据
    FBKAnalyOScaleDetail,     // 体脂数据
    FBKAnalyOScaleVersion,    // 版本号
    FBKAnalyOScaleUserInfo,   // 用户信息
    FBKAnalyOScaleDeviceTime, // 设备时间
    FBKAnalyOScaleRecord,     // 历史数据
    FBKAnalyOScaleError,      // 错误回复
}FBKAnalyticalOScale;


@protocol FBKProOldScaleAnalyticalDelegate <NSObject>

// 解析数据返回
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalOScale)resultNumber;

@end


@interface FBKProOldScaleAnalytical : NSObject

// 回调协议
@property(assign,nonatomic)id <FBKProOldScaleAnalyticalDelegate> delegate;

// 获取到蓝牙回复的数据
- (void)receiveBlueData:(NSString *)hexString;

// 获取到蓝牙回复的数据中断
- (void)receiveBlueDataError;

@end
