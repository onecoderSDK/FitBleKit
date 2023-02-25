/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FBKECGHeartRate.h
* Function : ECG Heart Rate
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.06.09
******************************************************************************************/

#import "FBKECGHeartRate.h"
#include "process.h"
#include "heart.h"

#define   ECGEffectiveTime   10
#define   ECGHRNumber        2000
#define   ECGStartNumber     1250
#define   ECGHrCalNumber     250
#define   ECGHrTRYNumber     5
#define   RATE 0.012309 //0.0205
#define   RR   30

@implementation FBKECGHeartRate {
    NSMutableArray *m_realEcgArray;
    double dataTimeMark;
    BOOL isStart;
    int beforeHeartRate;
    int compareRateNo; // 和前一次比较，超出10%的次数。
    int m_rriIndex;
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
        m_realEcgArray = [[NSMutableArray alloc] init];
        dataTimeMark = 0;
        isStart = true;
        beforeHeartRate = 0;
        m_rriIndex = -1;
        compareRateNo = 0;
    }
    return self;
}


/*-****************************************************************************************
 * Method: addEcgData
 * Description: addEcgData
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (NSDictionary *)addEcgData:(NSArray *)dataArray {
    double timeSeconds = [[NSDate date] timeIntervalSince1970];
    if (timeSeconds-dataTimeMark > ECGEffectiveTime) {
        [m_realEcgArray removeAllObjects];
        beforeHeartRate = 0;
        m_rriIndex = -1;
        isStart = true;
    }
    dataTimeMark = timeSeconds;
    
    [m_realEcgArray addObjectsFromArray:dataArray];
    if (isStart) {
        if (m_realEcgArray.count > ECGStartNumber) {
            isStart = false;
            for (int i = 0; i < ECGStartNumber; i++) {
                [m_realEcgArray removeObjectAtIndex:0];
            }
        }
    }
    else {
        NSMutableArray *calEcgArray = [[NSMutableArray alloc] init];
        if (m_realEcgArray.count > ECGHRNumber) {
            for (int i = 0; i < ECGHRNumber; i++) {
                [calEcgArray addObject:[m_realEcgArray objectAtIndex:i]];
            }
            
            for (int i = 0; i < ECGHrCalNumber; i++) {
                [m_realEcgArray removeObjectAtIndex:0];
            }
        }
        
        if (calEcgArray.count == ECGHRNumber) {
            NSDictionary *ecMap = [self getEcgHr:calEcgArray];
            NSMutableDictionary *hrMap = [[NSMutableDictionary alloc] initWithDictionary:ecMap];
            int nowHeartRate = [[hrMap objectForKey:@"heartRate"] intValue];
            NSArray *rriList = [hrMap objectForKey:@"interval"];
            if (nowHeartRate > 0) {
                if (beforeHeartRate == 0) {
                    beforeHeartRate = nowHeartRate;
                }
                
                if (nowHeartRate*10 > beforeHeartRate*11) {
                    compareRateNo = compareRateNo+1;
                    if (compareRateNo > ECGHrTRYNumber) {
                        compareRateNo = 0;
                        beforeHeartRate = nowHeartRate;
                    }
                }
                else {
                    beforeHeartRate = nowHeartRate;
                }
            }
            else {
                compareRateNo = compareRateNo+1;
                if (compareRateNo > ECGHrTRYNumber) {
                    compareRateNo = 0;
                    beforeHeartRate = nowHeartRate;
                }
            }
            
            NSMutableArray *intervalArray = [[NSMutableArray alloc] init];
            if (rriList.count > 0) {
                int lastIndex = [[rriList objectAtIndex:rriList.count-1] intValue];
                int startIndex = m_rriIndex;
                NSLog(@"getEcgHr %i --- %i",m_rriIndex, nowHeartRate);
                m_rriIndex = lastIndex - ECGHrCalNumber;
                if (m_rriIndex < 0) {
                    m_rriIndex = -1;
                }
                
                for (int i = 0; i < rriList.count; i++) {
                    int myIndex = [[rriList objectAtIndex:i] intValue];
                    if (startIndex < 0) {
                        startIndex = myIndex;
                    }
                    
                    if (myIndex > startIndex) {
                        NSLog(@"intervalArray %i --- %i --- %i --- %i",startIndex, myIndex, beforeHeartRate, nowHeartRate);
                        int nowRri = myIndex - startIndex;
                        startIndex = myIndex;
                        
                        if (nowRri > 10) {
                            [intervalArray addObject:[NSString stringWithFormat:@"%i",nowRri]];
                        }
                    }
                }
            }
            else {
                m_rriIndex = m_rriIndex - ECGHrCalNumber;
                if (m_rriIndex < 0) {
                    m_rriIndex = -1;
                }
            }
            
            NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
            [resultMap setObject:[NSString stringWithFormat:@"%i",beforeHeartRate] forKey:@"heartRate"];
            [resultMap setObject:intervalArray forKey:@"interval"];
            return resultMap;

        }
    }
    
    return nil;
}


/*-****************************************************************************************
 * Method: getEcgHr
 * Description: getEcgHr
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (NSDictionary *)getEcgHr:(NSArray *)dataArray {
    int length = (int)dataArray.count;
    
    NSMutableArray *intervalArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *hrMap = [[NSMutableDictionary alloc] init];
    int heartRate = 0;
    
    double signal[length];
    for(int i = 0; i < length; i++) {
        signal[i] = [[dataArray objectAtIndex:i] doubleValue];
    }
    
    // baseline_remove
    double* ecg_b = (double*)malloc(2000 * sizeof(double));
    
    // remove baseline
    baseline_wander(signal, ecg_b, 250, 2000);
    
    // 幅度阈值判断
    for(int i = 0; i < 2000; i++) {
        ecg_b[i] = ecg_b[i] * RATE; //乘以比例因子
    }
    
    int counter = 0;
    for(int i = 0; i < 2000; i++) {
        if(fabs(ecg_b[i]) > 2) {
            ecg_b[i] = 0;
            counter += 1;
        }
    }
    
    if (((float)counter/2000.0) < 0.3) {
        int qrs_i_raw[RR];
        int rLength = HeartRate(ecg_b, &heartRate, qrs_i_raw);
        
        for(int i = 0; i < rLength; i++) {
            [intervalArray addObject:[NSString stringWithFormat:@"%i",qrs_i_raw[i]]];
        }
    }
    
    [hrMap setObject:[NSString stringWithFormat:@"%i",heartRate] forKey:@"heartRate"];
    [hrMap setObject:intervalArray forKey:@"interval"];
    return hrMap;
}


@end
