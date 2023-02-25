/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FBKECGFilter.m
* Function : ECG Filter
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.06.09
******************************************************************************************/

#import "FBKECGFilter.h"
#include "denoise.h"

@implementation FBKECGFilter {
    double zi_notch[3];
    double zi_notch_60[3];
    double zi_bandpass[5];
}

/*-****************************************************************************************
 * Method: init
 * Description: init
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (instancetype)init {
    self = [super init];
    if (self) {
        for (int i = 0; i < 3; i++) {
            zi_notch[i] = 0;
        }
        
        for (int i = 0; i < 3; i++) {
            zi_notch_60[i] = 0;
        }
        
        for (int i = 0; i < 5; i++) {
            zi_bandpass[i] = 0;
        }
    }
    return self;
}


/*-****************************************************************************************
 * Method: ecgFilter
 * Description: ecgFilter
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (NSArray *)ecgFilter:(NSArray *)dataArray {
    
    //信号长度
    int length = (int)dataArray.count;
    
    double x[length];
    for(int i = 0; i < length; i++) {
        x[i] = [[dataArray objectAtIndex:i] doubleValue];
    }

    // 滤波
    double y_smooth[length];
    Denoise(x, length, y_smooth, zi_notch, zi_notch_60, zi_bandpass);
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < length; i++) {
        double value = y_smooth[i];
        [resultArray addObject:[NSNumber numberWithDouble:value]];
    }
    
    return resultArray;
}


@end
