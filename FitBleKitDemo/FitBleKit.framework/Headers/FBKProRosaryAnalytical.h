/********************************************************************************
 * 文件名称：FBKProRosaryAnalytical.h
 * 内容摘要：念珠蓝牙数据解析
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum{
    FBKAnalyticalRosaryRTNumber = 0, // 实时计数
    FBKAnalyticalRosaryPower,        // 电量
    FBKAnalyticalRosaryRemindMode,   // 提醒模式
    FBKAnalyticalRosaryBeadNumber,   // 佛珠个数
    FBKAnalyticalRosarySteps,        // 实时步数
    FBKAnalyticalRosaryRecord,       // 历史
    FBKAnalyticalRosaryNumber,       // 计数
    FBKAnalyticalRosaryANCS,         // 配对
    FBKAnalyticalRosaryRecordStatus, // 历史状态
    FBKAnalyticalRosaryStatus,       // 连接状态
    FBKAnalyticalRosaryError,        // 错误
    FBKAnalyticalRosaryAck,          // 回复
}FBKAnalyticalRosary;


@protocol FBKProRosaryAnalyticalDelegate <NSObject>

// 解析数据返回
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalRosary)resultNumber;

@end


@interface FBKProRosaryAnalytical : NSObject

// 回调协议
@property(assign,nonatomic)id <FBKProRosaryAnalyticalDelegate> delegate;

// 获取到蓝牙回复的数据
- (void)receiveBlueData:(NSString *)hexString;

// 获取到蓝牙回复的数据中断
- (void)receiveBlueDataError;

@end
