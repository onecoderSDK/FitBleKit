/********************************************************************************
 * 文件名称：FBKApiCadence.h
 * 内容摘要：踏频速度API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiCadenceDelegate <NSObject>

// 踏频数据
- (void)getCadence:(double)cadence andDevice:(id)bleDevice;

// 速度距离数据
- (void)getSpeed:(double)speed withDistance:(double)distance andDevice:(id)bleDevice;

// 速度踏频数据
//- (void)getSpeedCadence:(double)cadence withSpeed:(double)speed andDevice:(id)bleDevice;

@end

@interface FBKApiCadence : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiCadenceDelegate> delegate;

@property(assign,nonatomic) double whellDiameter;

@end
