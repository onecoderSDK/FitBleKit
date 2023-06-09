/********************************************************************************
* 文件名称：FBKHRRecordAnaly.h
* 内容摘要：心率算法
* 版本编号：1.0.1
* 创建日期：2021年04月28日
********************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKHRRecordAnaly : NSObject

- (NSArray *)analyRecordList:(NSDictionary *)recordDic isNew:(BOOL)isNew;

@end
