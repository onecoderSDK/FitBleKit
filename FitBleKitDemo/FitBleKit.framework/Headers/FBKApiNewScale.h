/********************************************************************************
 * 文件名称：FBKApiNewScale.h
 * 内容摘要：新秤API
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiNewScaleDelegate <NSObject>

// 硬件版本号
- (void)getDeviceVersion:(NSString *)version andDevice:(id)bleDevice;

//  实时数据
- (void)realTimeData:(NSDictionary *)weightInfo andDevice:(id)bleDevice;

// 大数据
- (void)getWeightData:(NSDictionary *)weightInfo andDevice:(id)bleDevice;

@end

@interface FBKApiNewScale : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiNewScaleDelegate> delegate;

// 设置时间
- (void)setUtc;

// 设置秤单位
- (void)setScaleUnit:(ScaleUnitsType)unit;

// 设置为抱婴模式
- (void)setBabyMode;

// 设置为标准模式
- (void)setStandardMode;

// 历史模式
- (void)loadHistory;

@end
