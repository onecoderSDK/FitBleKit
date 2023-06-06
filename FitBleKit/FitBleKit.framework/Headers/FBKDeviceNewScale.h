/********************************************************************************
 * 文件名称：FBKDeviceNewScale.h
 * 内容摘要：新秤
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKDeviceBaseInfo.h"

@interface FBKDeviceNewScale : FBKDeviceBaseInfo

// 稳定数据
@property (strong,nonatomic) NSMutableDictionary *stableDictionary;

// 历史数据
@property (strong,nonatomic) NSMutableArray *recordArray;

@end

