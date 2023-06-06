/********************************************************************************
* 文件名称：FBKTemAlgorithm.h
* 内容摘要：温度算法
* 版本编号：1.0.1
* 创建日期：2020年06月01日
********************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKTemAlgorithm : NSObject

- (NSDictionary *)algorithmBodyTemperature:(NSDictionary *)temMap;

- (double)listTemperatureData:(double)surTem witEvnTem:(double)evnTem;

- (double)compareFileData:(double)startTem withBetTem:(double)betTem;

@end
