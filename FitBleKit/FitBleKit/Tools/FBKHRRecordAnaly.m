/********************************************************************************
* 文件名称：FBKHRRecordAnaly.m
* 内容摘要：心率算法
* 版本编号：1.0.1
* 创建日期：2021年04月28日
********************************************************************************/

#import "FBKHRRecordAnaly.h"

@implementation FBKHRRecordAnaly


/*-******************************************************************************
* 方法名称：analyRecordList
* 功能描述：analyRecordList
* 输入参数：
* 返回数据：
********************************************************************************/
- (NSArray *)analyRecordList:(NSDictionary *)recordDic isNew:(BOOL)isNew {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSArray *recordList = nil;
    if (isNew) {
        recordList = [recordDic objectForKey:@"heartRate2SData"];
    }
    else {
        recordList = [recordDic objectForKey:@"heartRateData"];
    }
    
    if (recordList != nil) {
        if ([recordList isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *sportArray = [[NSMutableArray alloc] init];
            long localTime = 0;
            
            for (int i = 0; i < recordList.count; i++) {
                NSMutableDictionary *recordMap = [[NSMutableDictionary alloc] initWithDictionary:[recordList objectAtIndex:i]];
                long timeNo = [[recordMap objectForKey:@"timestamps"] intValue];
                if (i == 0) {
                    localTime = timeNo;
                }
                
                if (i == recordList.count-1) {
                    if (timeNo - localTime <= 60) {
                        [sportArray addObject:recordMap];
                    }
                    
                    if (sportArray.count >= 60) {
                        NSMutableArray *listArray = [[NSMutableArray alloc] initWithArray:sportArray];
                        [resultArray addObject:listArray];
                        [sportArray removeAllObjects];
                    }
                    else {
                        [sportArray removeAllObjects];
                    }
                }
                else {
                    if (timeNo - localTime <= 60) {
                        [sportArray addObject:recordMap];
                    }
                    else {
                        if (sportArray.count >= 60) {
                            NSMutableArray *listArray = [[NSMutableArray alloc] initWithArray:sportArray];
                            [resultArray addObject:listArray];
                            [sportArray removeAllObjects];
                        }
                        else {
                            [sportArray removeAllObjects];
                        }
                    }
                }
                
                localTime = timeNo;
            }
            
            if (sportArray.count >= 60) {
                NSMutableArray *listArray = [[NSMutableArray alloc] initWithArray:sportArray];
                [resultArray addObject:listArray];
                [sportArray removeAllObjects];
            }
        }
    }
    
    return resultArray;
}


@end
