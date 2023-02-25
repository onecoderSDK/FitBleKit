/********************************************************************************
 * 文件名称：FBKApiBikeComputer.m
 * 内容摘要：码表API
 * 版本编号：1.0.1
 * 创建日期：2018年02月02日
 ********************************************************************************/

#import "FBKApiBikeComputer.h"

@implementation FBKApiBikeComputer

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
    
    self.deviceType = BleDeviceBikeComputer;
    [self.managerController setManagerDeviceType:BleDeviceBikeComputer];
    
    return self;
}


/********************************************************************************
 * 方法名称：setUtc
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setUtc
{
    [self.managerController receiveApiCmd:BikeComputerCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：getFitNameList
 * 功能描述：获取fit文件名列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getFitNameList
{
    [self.managerController receiveApiCmd:BikeComputerCmdGetFitList withObject:nil];
}


/********************************************************************************
 * 方法名称：getFitFile
 * 功能描述：获取fit文件
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getFitFile:(NSString *)fitFileName
{
    [self.managerController receiveApiCmd:BikeComputerCmdGetFitFile withObject:fitFileName];
}


/********************************************************************************
 * 方法名称：deleteFitFile
 * 功能描述：删除fit文件
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deleteFitFile:(NSString *)fitFileName andDeleteType:(BikeComputerDeleteType)type
{
    if (type == BikeComputerDeleteFit)
    {
        [self.managerController receiveApiCmd:BikeComputerCmdDeleteFit withObject:fitFileName];
    }
    else if (type == BikeComputerDeleteFitHistory)
    {
        [self.managerController receiveApiCmd:BikeComputerCmdDeleteFitHis withObject:fitFileName];
    }
    else if (type == BikeComputerDeleteFitTotal)
    {
        [self.managerController receiveApiCmd:BikeComputerCmdDeleteFitAll withObject:fitFileName];
    }
}


/********************************************************************************
 * 方法名称：setFitTimeZone
 * 功能描述：设置码表时区
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setFitTimeZone:(int)timeZone
{
    NSString *timeZoneString = [NSString stringWithFormat:@"%i",timeZone];
    [self.managerController receiveApiCmd:BikeComputerCmdSetZone withObject:timeZoneString];
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
    
    switch (resultType)
    {
        case FBKAnalyticalDeviceVersion:
        {
            [self.delegate getDeviceVersion:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalFitList:
        {
            [self.delegate getNameList:(NSArray *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalFitData:
        {
            [self.delegate getFitFileData:(NSData *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
