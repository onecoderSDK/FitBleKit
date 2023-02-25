/********************************************************************************
 * 文件名称：FBKProNTrackerBigData.h
 * 内容摘要：新手环解析大数据
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

//#define   FBKLOGNTRACKERINFO  // 是否打印解析的结果数据

#import <Foundation/Foundation.h>
#import "FBKEnumList.h"

@protocol FBKProNTrackerBigDataDelegate <NSObject>

// fit名称列表
- (void)fitNameList:(NSArray *)listArray;

// fit文件数据
- (void)fitFileData:(NSData *)fitData;

// 大数据结果
- (void)bigDataResult:(NSDictionary *)bidDataDic;

@end


@interface FBKProNTrackerBigData : NSObject

// 协议
@property(assign,nonatomic)id <FBKProNTrackerBigDataDelegate> delegate;

// 设备类型
@property(assign,nonatomic) BleDeviceType bigDataDeviceType;

// 解析fit文件
- (void)analyticalFitFileData:(NSArray *)hexArray;

// 解析手环大数据
- (void)analyticalBigData:(NSArray *)hexArray;

// 解析秤大数据
- (void)analyticalWeightBigData:(NSArray *)hexArray;

// 蓝牙中断
- (void)bleError;

@end

