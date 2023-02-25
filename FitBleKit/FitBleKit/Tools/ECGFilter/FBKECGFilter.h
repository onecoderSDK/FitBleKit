/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FBKECGFilter.h
* Function : ECG Filter
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.06.09
******************************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKECGFilter : NSObject

- (NSArray *)ecgFilter:(NSArray *)dataArray;

@end
