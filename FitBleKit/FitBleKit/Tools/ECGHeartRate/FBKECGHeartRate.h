/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FBKECGHeartRate.h
* Function : ECG Heart Rate
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.06.09
******************************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKECGHeartRate : NSObject

- (NSDictionary *)addEcgData:(NSArray *)dataArray;

@end
