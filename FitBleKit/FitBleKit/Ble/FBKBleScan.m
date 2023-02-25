/********************************************************************************
 * 文件名称：FBKBleScan.m
 * 内容摘要：扫描蓝牙设备
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKBleScan.h"
#import "FBKSpliceBle.h"

@implementation FBKBleScan
{
    CBCentralManager *m_manager; // 控制器
    NSMutableArray   *m_deviceListArray;
    BOOL m_isRealTimeList;
    int m_hiRssi;
}

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
    m_manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    m_deviceListArray = [[NSMutableArray alloc] init];
    m_isRealTimeList = NO;
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startScanBleDevice
 * 功能描述：开始查找蓝牙设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)startScanBleDevice:(NSArray *)UUIDArray isRealTimeDevice:(BOOL)isRealTime withRssi:(int)rssi {
    [m_deviceListArray removeAllObjects];
    m_isRealTimeList = isRealTime;
    m_hiRssi = abs(rssi);
    NSArray *systemArray = [self getSettingConnectedBlue:UUIDArray];
    
    if (systemArray != nil)
    {
        if (m_isRealTimeList)
        {
            [m_deviceListArray removeAllObjects];
        }
        
        [m_deviceListArray addObjectsFromArray:systemArray];
        [self.delegate getDeviceList:m_deviceListArray];
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [m_manager scanForPeripheralsWithServices:UUIDArray options:options];
}


/********************************************************************************
 * 方法名称：stopScanBleDevice
 * 功能描述：停止查找蓝牙设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)stopScanBleDevice
{
    [m_deviceListArray removeAllObjects];
    if (m_manager != nil) {
        [m_manager stopScan];
    }
}


/********************************************************************************
 * 方法名称：getSettingConnectedBlue
 * 功能描述：搜索并连接系统已配对的蓝牙
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSArray *)getSettingConnectedBlue:(NSArray *)UUIDArray
{
    if (UUIDArray == nil)
    {
        return nil;
    }
    
    NSArray *settingBlueArray = [m_manager retrieveConnectedPeripheralsWithServices:UUIDArray];
    if ([settingBlueArray isKindOfClass:[NSArray class]])
    {
        if (settingBlueArray.count > 0)
        {
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < settingBlueArray.count; i++)
            {
                CBPeripheral *nowPeripheral = [settingBlueArray objectAtIndex:i];
                NSString *rssiNumber = @"0";
                NSDictionary *advertisementData = [[NSDictionary alloc] init];
                
                NSMutableDictionary *deviceInfoDic = [[NSMutableDictionary alloc] init];
                [deviceInfoDic setObject:nowPeripheral forKey:@"peripheral"];
                [deviceInfoDic setObject:rssiNumber forKey:@"RSSI"];
                [deviceInfoDic setObject:advertisementData forKey:@"advertisementData"];
                [resultArray addObject:deviceInfoDic];
            }
            
            return resultArray;
        }
    }
    
    return nil;
}


#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
 * 方法名称：centralManagerDidUpdateState
 * 功能描述：蓝牙状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
        {
            [self.delegate phoneBleStatus:YES];
            break;
        }
        default:
        {
            [self.delegate phoneBleStatus:NO];
            break;
        }
    }
}


/********************************************************************************
 * 方法名称：didDiscoverPeripheral
 * 功能描述：查到外设，停止扫描，连接设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (abs([RSSI intValue]) > m_hiRssi)
    {
        return;
    }

    NSString *localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (localName == nil) {
        localName = @"Unnamed";
    }
    NSData *byteData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    NSString *macString = [FBKSpliceBle bleDataToString:byteData];
    NSString *MACAddress = [FBKSpliceBle getMacAddress:macString];
    NSString *myIdString = [FBKSpliceBle analyticalDeviceId:byteData];
    
    NSMutableDictionary *deviceInfoDic = [[NSMutableDictionary alloc] init];
    [deviceInfoDic setObject:peripheral forKey:@"peripheral"];
    [deviceInfoDic setObject:[NSString stringWithFormat:@"%@",RSSI] forKey:@"RSSI"];
    [deviceInfoDic setObject:advertisementData forKey:@"advertisementData"];
    [deviceInfoDic setObject:MACAddress forKey:@"MACAddress"];
    [deviceInfoDic setObject:myIdString forKey:@"idString"];
    [deviceInfoDic setObject:localName forKey:@"localName"];
    
    if (m_isRealTimeList)
    {
        [m_deviceListArray removeAllObjects];
        [m_deviceListArray addObject:deviceInfoDic];
        [self.delegate getDeviceList:m_deviceListArray];
    }
    else
    {
        BOOL isHave = NO;
        for (int i = 0; i < m_deviceListArray.count; i++)
        {
            CBPeripheral *peripheralArr = [[m_deviceListArray objectAtIndex:i] objectForKey:@"peripheral"];
            
            if (peripheral == peripheralArr)
            {
                [m_deviceListArray replaceObjectAtIndex:i withObject:deviceInfoDic];
                isHave = YES;
            }
        }
        
        if (!isHave)
        {
            [m_deviceListArray addObject:deviceInfoDic];
        }
        
        [self.delegate getDeviceList:m_deviceListArray];
    }
}


@end

