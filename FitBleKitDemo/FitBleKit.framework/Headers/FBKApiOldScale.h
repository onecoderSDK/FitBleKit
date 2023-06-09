/********************************************************************************
 * 文件名称：FBKApiOldScale.h
 * 内容摘要：旧秤API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiOldScaleDelegate <NSObject>

// 版本号
- (void)getDeviceVersion:(NSDictionary *)version andDevice:(id)bleDevice;

//  实时数据
- (void)realTimeData:(NSDictionary *)weightInfo andDevice:(id)bleDevice;

//  稳定数据
- (void)stableData:(NSDictionary *)weightInfo andDevice:(id)bleDevice;

//  稳定数据
- (void)historyData:(NSDictionary *)weightInfo andDevice:(id)bleDevice;

@end


@interface FBKApiOldScale : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiOldScaleDelegate> delegate;

// 设置时间
- (void)setUtc;

// 设置用户信息
- (void)setUserInfo:(FBKDeviceScaleInfo *)userInfo;

// 设置设备单位
- (void)setUnits:(ScaleUnitsType)unit;

// 获取设备版本
- (void)getVersion;

// 添加用户
- (void)addUserInfo:(FBKDeviceScaleInfo *)userInfo;

// 删除用户
- (void)deleUserInfo:(FBKDeviceScaleInfo *)userInfo;

// 指定用户
- (void)tipUserInfo:(FBKDeviceScaleInfo *)userInfo;

@end
