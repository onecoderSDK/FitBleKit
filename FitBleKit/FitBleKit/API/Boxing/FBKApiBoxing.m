/********************************************************************************
 * 文件名称：FBKApiArmBand.m
 * 内容摘要：臂带API
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKApiBoxing.h"

@implementation FBKApiBoxing

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.deviceType = BleDeviceBoxing;
    [self.managerController setManagerDeviceType:BleDeviceBoxing];
    
    return self;
}


/********************************************************************************
 * 方法名称：setBoxingTime
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBoxingTime
{
    [self.managerController receiveApiCmd:BoxingCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：getBoxingTotalHistory
 * 功能描述：获取所有历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBoxingTotalHistory
{
    [self.managerController receiveApiCmd:BoxingCmdGetTotalRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：setBoxingZone
 * 功能描述：设置轴区间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBoxingZone:(FBKBoxingSet *)boxingSet {
    [self.managerController receiveApiCmd:BoxingCmdSetAxisZone withObject:boxingSet];
}


/********************************************************************************
 * 方法名称：setBoxingAxisSwitch
 * 功能描述：设置轴数据开关
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBoxingAxisSwitch:(BOOL)isOn {
    NSString *switchString = @"0";
    if (isOn) {
        switchString = @"1";
    }
    [self.managerController receiveApiCmd:BoxingCmdSetAxisSwitch withObject:switchString];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber
{
    FBKAnalyticalNumber resultType = (FBKAnalyticalNumber)resultNumber;
    
    switch (resultType) {
        case FBKAnalyticalDeviceVersion: {
            [self.delegate armBandVersion:(NSString *)resultData andDevice:self];
            break;
        }

        case FBKAnalyticalRTFistInfo: {
            [self.delegate realtimeFistInfo:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalBigData: {
            [self.delegate armBoxingDetailData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKResultBoxingAxis: {
//            [self.delegate boxingAxisSetResult:true andDevice:self];
            break;
        }
            
        case FBKResultBoxingAxisSwitch: {
            NSString *resultString = (NSString *)resultData;
            if ([resultString intValue]) {
                [self.delegate boxingAxisSwitchResult:true andDevice:self];
            }
            else {
                [self.delegate boxingAxisSwitchResult:false andDevice:self];
            }
            break;
        }
            
        case FBKResultAxisList: {
            NSDictionary *dataMap =(NSDictionary *)resultData;
            int sortNumber = [[dataMap objectForKey:@"sortNo"] intValue];
            long int timestamps = [[dataMap objectForKey:@"timestamps"] intValue];
            NSArray *axisArray = [dataMap objectForKey:@"axisDataList"];
            [self.delegate realtimeAxis:axisArray withSort:sortNumber andTimestamps:timestamps andDevice:self];
            break;
        }
            
        default: {
            break;
        }
    }
}

@end
