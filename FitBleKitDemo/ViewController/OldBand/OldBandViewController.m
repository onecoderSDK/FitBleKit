/********************************************************************************
 * 文件名称：OldBandViewController.h
 * 内容摘要：旧手环
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import "OldBandViewController.h"
#import "BindDeviceViewController.h"
#import "NewBandListViewController.h"

@interface OldBandViewController ()<UITableViewDataSource, UITableViewDelegate, DeviceIdDelegate, FBKApiBsaeDataSource, FBKApiOldBandDelegate> {
    UITableView    *m_cmdTableView;     // 命令列表
    NSMutableArray *m_cmdArray;         // 命令列表数据
    UILabel        *m_alertLab;         // 连接状态
    UILabel        *m_realTimeLab;      // 实时数据展示
    UITextView     *m_content;          // 获取到的数据展示
    UITableView    *m_deviceTableView;  // 设备列表
    NSMutableArray *m_deviceList;       // 设备列表数据
    int            m_maxNumber;         // 选择的设备数（不超过7个）
    int            m_chooseNumber;      // 选择设备展示的数据
}

@end

@implementation OldBandViewController

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_maxNumber = 0;
    m_chooseNumber = 0;
    m_deviceList = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        FBKApiOldBand *oldBandApi = [[FBKApiOldBand alloc] init];
        oldBandApi.delegate = self;
        oldBandApi.dataSource = self;
        
        // 设置个人基本信息
        FBKDeviceUserInfo *myUserInfo = [[FBKDeviceUserInfo alloc] init];
        myUserInfo.weight = @"60";     // 体重范围为0-600（千克）
        myUserInfo.height = @"170";    // 身高范围为0-255（厘米）
        myUserInfo.age   = @"30";      // 年龄范围为0-255
        myUserInfo.gender = @"1";      // 0代表女  1代表男
        myUserInfo.walkGoal = @"6000"; // 目标步数小于10000000（步）
        [oldBandApi setUserInfoApi:myUserInfo];
        
        // 设置个人睡眠信息
        FBKDeviceSleepInfo *mySleepInfo = [[FBKDeviceSleepInfo alloc] init];
        mySleepInfo.normalStart = @"20:00";  // 时间为24小时制 格式必须为“HH:mm”
        mySleepInfo.normalEnd   = @"06:00";  // 时间为24小时制 格式必须为“HH:mm”
        mySleepInfo.weekdayStart= @"23:00";  // 时间为24小时制 格式必须为“HH:mm”
        mySleepInfo.weekdaylEnd = @"09:00";  // 时间为24小时制 格式必须为“HH:mm”
        [oldBandApi setSleepInfoApi:mySleepInfo];
        
        // 设置单车参数
        [oldBandApi setBikeInfoApi:@"2.096"];
        
        // 设置限制参数
        FBKDeviceLimit *myLimitInfo = [[FBKDeviceLimit alloc] init];
        myLimitInfo.limitSteps = @"15";   // 每分钟的步数限制
        myLimitInfo.limitMinutes = @"60"; // 限制的总分钟数
        myLimitInfo.timeInterval= @"20";  // 活跃时间的时间间隔
        myLimitInfo.stepStandard = @"35"; // 活跃时间的步数判定标准
        [oldBandApi setLimitInfoApi:myLimitInfo];
        
        DeviceClass *myBleDevice = [[DeviceClass alloc] init];
        myBleDevice.bleDevice = oldBandApi;
        myBleDevice.deviceId = @"";
        myBleDevice.isAvailable = NO;
        myBleDevice.connectStatus = DeviceBleClosed;
        [m_deviceList addObject:myBleDevice];
    }
    
    m_cmdArray = [[NSMutableArray alloc] initWithObjects:
                  @"Get historical data",
                  @"Device power",
                  @"Device firmware version",
                  @"Device hardware version",
                  @"Device software version",
                  @"P_Mac Address",
                  @"P_Total Version",
                  @"P_Enter OTA Mode",
                  @"Test Sleep Time",
                  nil];
    
    [self loadHeadView];
    [self loadContentView];
}


/********************************************************************************
 * 方法名称：chooseDevice
 * 功能描述：选择设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setSleepTime:(FBKDeviceSleepInfo *)mySleepInfo {
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        FBKApiOldBand *listApi = myBleDevice.bleDevice;
        [listApi setSleepInfoApi:mySleepInfo];
    }
}


/********************************************************************************
 * 方法名称：didReceiveMemoryWarning
 * 功能描述：内存警告时，释放内存
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - **************************** 加载界面 *****************************
/********************************************************************************
 * 方法名称：loadHeadView
 * 功能描述：获取头视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadHeadView {
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerBackView];
    
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    powerView.backgroundColor = [UIColor clearColor];
    [headerBackView addSubview:powerView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = @"Old Band";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20];
    [headerBackView addSubview:titleLab];
    
    UIButton *headLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 80, 50)];
    headLeftBtn.backgroundColor = [UIColor clearColor];
    [headLeftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headLeftBtn];
    
    UIImageView *headLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 24, 24)];
    headLeftImg.backgroundColor = [UIColor clearColor];
    headLeftImg.image = [UIImage imageNamed:@"img_app_back.png"];
    [headLeftBtn addSubview:headLeftImg];
    
    UIButton *headRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 30, 80, 50)];
    headRightBtn.backgroundColor = [UIColor clearColor];
    [headRightBtn setTitle:@"Device" forState:UIControlStateNormal];
    [headRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headRightBtn addTarget:self action:@selector(chooseDevice) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headRightBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerBackView addSubview:lineView];
}


/********************************************************************************
 * 方法名称：loadContentView
 * 功能描述：获取内容视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadContentView {
    m_alertLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 50)];
    m_alertLab.backgroundColor = [UIColor clearColor];
    m_alertLab.text = @"No device";
    m_alertLab.textColor = [UIColor redColor];
    m_alertLab.textAlignment = NSTextAlignmentCenter;
    m_alertLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:m_alertLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [m_alertLab addSubview:lineView];
    
    float cmdTableHi = (self.view.frame.size.height-130)/2;
    if (cmdTableHi > 50 * m_cmdArray.count) {
        cmdTableHi = 50 * m_cmdArray.count;
    }
    
    m_cmdTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, cmdTableHi)];
    m_cmdTableView.delegate = self;
    m_cmdTableView.dataSource = self;
    m_cmdTableView.backgroundColor = [UIColor clearColor];
    m_cmdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_cmdTableView];
    
    m_realTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 130+cmdTableHi, self.view.frame.size.width, 100)];
    m_realTimeLab.backgroundColor = [UIColor blackColor];
    m_realTimeLab.text = @"heart rate: --";
    m_realTimeLab.textColor = [UIColor whiteColor];
    m_realTimeLab.textAlignment = NSTextAlignmentCenter;
    m_realTimeLab.font = [UIFont systemFontOfSize:20];
    m_realTimeLab.numberOfLines = 3;
    [self.view addSubview:m_realTimeLab];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 99, self.view.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [m_realTimeLab addSubview:lineView1];
    
    m_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 230+cmdTableHi, self.view.frame.size.width, self.view.frame.size.height-230-cmdTableHi)];
    m_content.backgroundColor = [UIColor blackColor];
    m_content.font = [UIFont systemFontOfSize:20];
    m_content.text = @"";
    m_content.textColor = [UIColor whiteColor];
    [m_content setEditable:NO];
    [self.view addSubview:m_content];
    
    m_deviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_deviceTableView.delegate = self;
    m_deviceTableView.dataSource = self;
    m_deviceTableView.backgroundColor = [UIColor whiteColor];
    m_deviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_deviceTableView];
}


#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction {
    if (m_deviceTableView.frame.origin.x < 10) {
        [UIView animateWithDuration:0.3f animations:^{
            self->m_deviceTableView.frame = CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
        return;
    }
    
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        if (myBleDevice.deviceId.length != 0) {
            FBKApiOldBand *oldBandApi = myBleDevice.bleDevice;
            [oldBandApi disconnectBleApi];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


/********************************************************************************
 * 方法名称：chooseDevice
 * 功能描述：选择设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)chooseDevice {
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    if (myBleDevice.deviceId.length > 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self->m_deviceTableView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80);
         }];
    }
    else {
        BindDeviceViewController *bindView = [[BindDeviceViewController alloc] init];
        bindView.scanDeviceType = BleDeviceOldBand;
        bindView.delegate = self;
        [self.navigationController pushViewController:bindView animated:YES];
    }
}


#pragma mark - **************************** 数据回调 *****************************
/********************************************************************************
 * 方法名称：getDeviceId
 * 功能描述：得到设备ID
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getDeviceId:(NSArray *)deviceIdArray {
    m_maxNumber = (int)deviceIdArray.count;
    for (int i = 0; i < m_maxNumber; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        myBleDevice.deviceId = [[deviceIdArray objectAtIndex:i] objectForKey:@"deviceId"];
        myBleDevice.deviceName = [[deviceIdArray objectAtIndex:i] objectForKey:@"deviceName"];
        if (myBleDevice.isAvailable) {
            FBKApiOldBand *oldBandApi = myBleDevice.bleDevice;
            [oldBandApi startConnectBleApi:myBleDevice.deviceId andIdType:DeviceIdUUID];
            NSLog(@"myBleDevice.deviceId %@",myBleDevice.deviceId);
        }
    }
    [m_deviceTableView reloadData];
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        FBKApiOldBand *listApi = myBleDevice.bleDevice;
        if (oldBandApi == listApi) {
            myBleDevice.connectStatus = status;
            if (status == DeviceBleClosed) {
                myBleDevice.isAvailable = NO;
            }
            else if (status == DeviceBleIsOpen) {
                myBleDevice.isAvailable = YES;
                if (myBleDevice.deviceId.length > 0) {
                    [listApi startConnectBleApi:myBleDevice.deviceId andIdType:DeviceIdUUID];
                }
            }
            break;
        }
    }
    
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        m_alertLab.text = [ShowTools showDeviceStatus:status];
    }
}


/********************************************************************************
 * 方法名称：bleConnectError
 * 功能描述：蓝牙连接错误信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)error andDevice:(id)bleDevice {
    if (m_deviceList.count > m_chooseNumber) {
        FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
        FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
        if (chooseApi == oldBandApi) {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nError: %@",oldBandApi.deviceId,error];
        }
    }
}


/********************************************************************************
 * 方法名称：bleConnectLog
 * 功能描述：蓝牙连接LOG
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectLog:(NSString *)logString andDevice:(id)bleDevice {
    NSLog(@"bleConnectLog --- %@",logString);
}


/********************************************************************************
 * 方法名称：devicePower
 * 功能描述：电量
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        NSString *bai = @"%";
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nPower: %@%@",oldBandApi.deviceId,power,bai];
    }
}


/********************************************************************************
 * 方法名称：deviceFirmware
 * 功能描述：固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nFirmware version: %@",oldBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceHardware
 * 功能描述：硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nHardware version: %@",oldBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceSoftware
 * 功能描述：软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSoftware version: %@",oldBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：privateVersion
 * 功能描述：获取私有版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateVersion:(NSDictionary *)versionMap andDevice:(id)bleDevice {
    m_content.text = [NSString stringWithFormat:@"%@",versionMap];
}


/********************************************************************************
 * 方法名称：privateMacAddress
 * 功能描述：获取私有MAC地址
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateMacAddress:(NSDictionary *)macMap andDevice:(id)bleDevice {
    m_content.text = [NSString stringWithFormat:@"%@",macMap];
}


- (void)deviceSystemData:(NSData *)systemData andDevice:(id)bleDevice {return;}
- (void)deviceModelString:(NSString *)modelString andDevice:(id)bleDevice{return;}
- (void)deviceSerialNumber:(NSString *)serialNumber andDevice:(id)bleDevice{return;}
- (void)deviceManufacturerName:(NSString *)manufacturerName andDevice:(id)bleDevice{return;}


/********************************************************************************
 * 方法名称：getRealTimeHeartRate
 * 功能描述：实时心率
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        m_realTimeLab.text = [NSString stringWithFormat:@"heart rate: %@",[HRInfo objectForKey:@"heartRate"]];
    }
}


/********************************************************************************
 * 方法名称：findPhone
 * 功能描述：查找手机
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)findPhone:(BOOL)status andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        m_content.text = [NSString stringWithFormat:@"findPhone: %i",status];
    }
}


/********************************************************************************
 * 方法名称：getRealTimeStepsData
 * 功能描述：实时步数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRealTimeStepsData:(NSDictionary *)stepsDic andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        m_content.text = [NSString stringWithFormat:@"%@",stepsDic];
    }
}


/********************************************************************************
 * 方法名称：getBigData
 * 功能描述：大数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBigData:(NSDictionary *)bigDataDic andDevice:(id)bleDevice {
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *chooseApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (chooseApi == oldBandApi) {
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:bigDataDic];
        if (bigDataDic.allKeys.count > 0) {
            NewBandListViewController *listView = [[NewBandListViewController alloc] init];
            listView.dataDic = dataDic;
            [self.navigationController pushViewController:listView animated:YES];
        }
    }
}


#pragma mark - **************************** 列表回调 *****************************
/********************************************************************************
 * 方法名称：numberOfSectionsInTableView
 * 功能描述：设置TableView的块数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/********************************************************************************
 * 方法名称：numberOfRowsInSection
 * 功能描述：设置TableView的行数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == m_deviceTableView) {
        return m_maxNumber;
    }
    return m_cmdArray.count;
}


/********************************************************************************
 * 方法名称：heightForRowAtIndexPath
 * 功能描述：设置TableView的行高
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


/********************************************************************************
 * 方法名称：heightForHeaderInSection
 * 功能描述：设置TableView的块的头UI的高度
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


/********************************************************************************
 * 方法名称：viewForHeaderInSection
 * 功能描述：设置TableView的块的头UI
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *lineB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    lineB.backgroundColor = [UIColor clearColor];
    [headView addSubview:lineB];
    
    return headView;
}


/********************************************************************************
 * 方法名称：cellForRowAtIndexPath
 * 功能描述：设置TableView的行UI
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellString = @"ArmBandCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    if (tableView == m_deviceTableView) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:indexPath.row];
        UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, self.view.frame.size.width-20, 20)];
        info1Lab.textAlignment = NSTextAlignmentLeft;
        info1Lab.font = [UIFont systemFontOfSize:15];
        info1Lab.textColor = [UIColor blackColor];
        info1Lab.text = [NSString stringWithFormat:@"%@",myBleDevice.deviceName];
        [cell.contentView addSubview:info1Lab];
        
        UILabel *info2Lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 28, 240, 20)];
        info2Lab.textAlignment = NSTextAlignmentLeft;
        info2Lab.font = [UIFont systemFontOfSize:10];
        info2Lab.textColor = [UIColor blackColor];
        info2Lab.text = myBleDevice.deviceId;
        [cell.contentView addSubview:info2Lab];
        
        UIImageView *chooseImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 15, 20, 20)];
        chooseImg.backgroundColor = [UIColor clearColor];
        chooseImg.image = [UIImage imageNamed:@"img_choose.png"];
        chooseImg.hidden = YES;
        [cell.contentView addSubview:chooseImg];
        
        if (indexPath.row == m_chooseNumber) {
            chooseImg.hidden = NO;
        }
        
        UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
        myLine.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:myLine];
        
        return cell;
    }
    
    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 50)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:15];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"%i、%@",(int)indexPath.row+1,[m_cmdArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:info1Lab];
    
    UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    myLine.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:myLine];
    
    return cell;
}


/********************************************************************************
 * 方法名称：didSelectRowAtIndexPath
 * 功能描述：设置TableView的行的触发方法
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int myRow = (int)indexPath.row;
    
    if (tableView == m_deviceTableView) {
        m_chooseNumber = myRow;
        [tableView reloadData];
        [UIView animateWithDuration:0.3f animations:^{
            self->m_deviceTableView.frame = CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
        return;
    }
    
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiOldBand *oldBandApi = (FBKApiOldBand *)myBleDevice.bleDevice;
    if (oldBandApi.isConnected)
    {
        if (myRow == 0)
        {
            [oldBandApi getRecordData];
        }
        else if (myRow == 1)
        {
            [oldBandApi readDevicePower];
        }
        else if (myRow == 2)
        {
            [oldBandApi readFirmwareVersion];
        }
        else if (myRow == 3)
        {
            [oldBandApi readHardwareVersion];
        }
        else if (myRow == 4)
        {
            [oldBandApi readSoftwareVersion];
        }
        else if (myRow == 5)
        {
            [oldBandApi getPrivateMacAddress];
        }
        else if (myRow == 6)
        {
            [oldBandApi getPrivateVersion];
        }
        else if (myRow == 7)
        {
//            [oldBandApi enterOTAMode];
        }
    }
    
    
    if (myRow == 8) {
        [self getSleepView];
    }

}


- (void)getSleepView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sleep Time" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField1 = [alertController.textFields objectAtIndex:0];
        UITextField *inputField2 = [alertController.textFields objectAtIndex:1];
        UITextField *inputField3 = [alertController.textFields objectAtIndex:2];
        if (inputField1.text.length == 5 && inputField2.text.length == 5 && inputField3.text.length == 5) {
            FBKDeviceSleepInfo *mySleepInfo = [[FBKDeviceSleepInfo alloc] init];
            mySleepInfo.normalStart = inputField1.text;  // 时间为24小时制 格式必须为“HH:mm”
            mySleepInfo.normalEnd   = inputField2.text;  // 时间为24小时制 格式必须为“HH:mm”
            mySleepInfo.weekdayStart= @"23:00";          // 时间为24小时制 格式必须为“HH:mm”
            mySleepInfo.weekdaylEnd = inputField3.text;  // 时间为24小时制 格式必须为“HH:mm”
            [self setSleepTime:mySleepInfo];
            self->m_content.text = [NSString stringWithFormat:@"%@ - %@/%@",inputField1.text,inputField2.text,inputField3.text];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
