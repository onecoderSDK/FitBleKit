/********************************************************************************
 * 文件名称：NewBandViewController.h
 * 内容摘要：新手环
 * 版本编号：1.0.1
 * 创建日期：2017年11月14日
 ********************************************************************************/

#import "NewBandViewController.h"
#import "BindDeviceViewController.h"
#import "NewBandListViewController.h"

@interface NewBandViewController ()<UITableViewDataSource, UITableViewDelegate, DeviceIdDelegate, FBKApiBsaeDataSource, FBKApiNewBandDelegate> {
    UITableView    *m_cmdTableView;     // 命令列表
    NSMutableArray *m_cmdArray;         // 命令列表数据
    UILabel        *m_alertLab;         // 连接状态
    UILabel        *m_realTimeHR;       // 实时数据展示
    UILabel        *m_realTimeStep;     // 实时数据展示
    UITextView     *m_content;          // 获取到的数据展示
    UITableView    *m_deviceTableView;  // 设备列表
    NSMutableArray *m_deviceList;       // 设备列表数据
    int            m_maxNumber;         // 选择的设备数（不超过7个）
    int            m_chooseNumber;      // 选择设备展示的数据
}

@end

@implementation NewBandViewController

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
        FBKApiNewBand *newBandApi = [[FBKApiNewBand alloc] init];
        newBandApi.delegate = self;
        newBandApi.dataSource = self;
        
        DeviceClass *myBleDevice = [[DeviceClass alloc] init];
        myBleDevice.bleDevice = newBandApi;
        myBleDevice.deviceId = @"";
        myBleDevice.isAvailable = NO;
        myBleDevice.connectStatus = DeviceBleClosed;
        [m_deviceList addObject:myBleDevice];
    }
    
    m_cmdArray = [[NSMutableArray alloc] initWithObjects:
                      @"设置个人基本信息",
                      @"设置个人睡眠信息",
                      @"设置个人喝水信息",
                      @"设置个人久坐信息",
                      @"设置个人通知信息",
                      @"设置个人闹钟信息",
                      @"设置单车参数",
                      @"设置心率最大值",
                      @"开启实时数据",
                      @"开启拍照",
                      @"开启心率模式",
                      @"获取所有历史数据",
                      @"获取运动历史数据",
                      @"获取心率历史数据",
                      @"获取踏频历史数据",
                      @"获取训练历史数据",
                      @"获取睡眠历史数据",
                      @"获取每天步数总和历史数据",
                      @"校准时间",
                      @"关闭实时数据",
                      @"查询电量",
                      @"查询设备固件版本",
                      @"查询设备硬件版本",
                      @"查询设备软件版本",
                      @"十分钟心率采集",
                      @"P_Mac Address",
                      @"P_Total Version",
                      @"P_Enter OTA Mode",
                      nil];
    
    [self loadHeadView];
    [self loadContentView];
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
    titleLab.text = @"NewBand";
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
    
    m_realTimeHR = [[UILabel alloc] initWithFrame:CGRectMake(0, 130+cmdTableHi, self.view.frame.size.width, 50)];
    m_realTimeHR.backgroundColor = [UIColor blackColor];
    m_realTimeHR.text = @"heart rate: --";
    m_realTimeHR.textColor = [UIColor whiteColor];
    m_realTimeHR.textAlignment = NSTextAlignmentCenter;
    m_realTimeHR.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:m_realTimeHR];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [m_realTimeHR addSubview:lineView1];
    
    m_realTimeStep = [[UILabel alloc] initWithFrame:CGRectMake(0, 180+cmdTableHi, self.view.frame.size.width, 100)];
    m_realTimeStep.backgroundColor = [UIColor blackColor];
    m_realTimeStep.text = @"Steps: -- \nCalroies: -- \nDistance: --";
    m_realTimeStep.textColor = [UIColor whiteColor];
    m_realTimeStep.textAlignment = NSTextAlignmentCenter;
    m_realTimeStep.font = [UIFont systemFontOfSize:20];
    m_realTimeStep.numberOfLines = 3;
    [self.view addSubview:m_realTimeStep];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 99, self.view.frame.size.width, 1)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [m_realTimeStep addSubview:lineView2];
    
    m_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 280+cmdTableHi, self.view.frame.size.width, self.view.frame.size.height-280-cmdTableHi)];
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
            m_deviceTableView.frame = CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
        return;
    }
    
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        if (myBleDevice.deviceId.length != 0) {
            FBKApiNewBand *newBandApi = myBleDevice.bleDevice;
            [newBandApi disconnectBleApi];
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
            m_deviceTableView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
    }
    else {
        BindDeviceViewController *bindView = [[BindDeviceViewController alloc] init];
        bindView.scanDeviceType = BleDeviceNewBand;
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
            FBKApiNewBand *newBandApi = myBleDevice.bleDevice;
            [newBandApi startConnectBleApi:myBleDevice.deviceId andIdType:DeviceIdUUID];
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
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        FBKApiNewBand *listApi = myBleDevice.bleDevice;
        if (newBandApi == listApi) {
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
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
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
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nError: %@",newBandApi.deviceId,error];
    }
}


/********************************************************************************
 * 方法名称：bleConnectLog
 * 功能描述：蓝牙连接LOG
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectLog:(NSString *)logString andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：devicePower
 * 功能描述：电量
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        NSString *bai = @"%";
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nPower: %@%@",newBandApi.deviceId,power,bai];
    }
}


/********************************************************************************
 * 方法名称：deviceFirmware
 * 功能描述：固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nFirmware version: %@",newBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceHardware
 * 功能描述：硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nHardware version: %@",newBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceSoftware
 * 功能描述：软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSoftware version: %@",newBandApi.deviceId,version];
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


/********************************************************************************
 * 方法名称：getRealTimeHeartRate
 * 功能描述：实时心率
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice{
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_realTimeHR.text = [NSString stringWithFormat:@"heart rate: %@",[HRInfo objectForKey:@"heartRate"]];
    }
}


/********************************************************************************
 * 方法名称：findPhone
 * 功能描述：查找手机
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)findPhone:(BOOL)status andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nFindPhone: %i",newBandApi.deviceId,status];
    }
}


/********************************************************************************
 * 方法名称：takePhoto
 * 功能描述：照相
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)takePhoto:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nTakePhoto",newBandApi.deviceId];
    }
}


/********************************************************************************
 * 方法名称：getMusicStatus
 * 功能描述：音乐控制
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getMusicStatus:(MusicStatus)musicStatus andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nMusicStatus: %i",newBandApi.deviceId,musicStatus];
    }
}


/********************************************************************************
 * 方法名称：getLastSyncTime
 * 功能描述：上次同步时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getLastSyncTime:(NSString *)syncTime andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nLastSyncTime: %@",newBandApi.deviceId,syncTime];
    }
}


/********************************************************************************
 * 方法名称：getDeviceVersion
 * 功能描述：协议版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getDeviceVersion:(NSString *)version andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nProtocol version: %@",newBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：getRealTimeStepsData
 * 功能描述：实时步数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRealTimeStepsData:(NSDictionary *)stepsDic andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
        m_realTimeStep.text = [NSString stringWithFormat:@"Steps: %@\nCalroies: %@\nDistance: %@",[stepsDic objectForKey:@"stepNum"],[stepsDic objectForKey:@"stepKcal"],[stepsDic objectForKey:@"stepDistance"]];
    }
}


/********************************************************************************
 * 方法名称：getBigData
 * 功能描述：大数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBigData:(NSDictionary *)bigDataDic andDevice:(id)bleDevice {
    FBKApiNewBand *newBandApi = (FBKApiNewBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiNewBand *chooseApi = (FBKApiNewBand *)myBleDevice.bleDevice;
    if (chooseApi == newBandApi) {
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
    static NSString *cellString = @"SkippingCell";
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
            m_deviceTableView.frame = CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
    }
    else {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
        FBKApiNewBand *m_newBandApi = myBleDevice.bleDevice;
        if (m_newBandApi.isConnected) {
            if (myRow == 0) {
                // 设置个人基本信息
                FBKDeviceUserInfo *myUserInfo = [[FBKDeviceUserInfo alloc] init];
                myUserInfo.weight = @"60";     // 体重范围为0-600（千克）
                myUserInfo.height = @"170";    // 身高范围为0-255（厘米）
                myUserInfo.age   = @"30";      // 年龄范围为0-255
                myUserInfo.gender = @"1";      // 0代表女  1代表男
                myUserInfo.walkGoal = @"100"; // 目标步数小于10000000（步）
                [m_newBandApi setUserInfoApi:myUserInfo];
            }
            else if (myRow == 1) {
                // 设置个人睡眠信息
                FBKDeviceSleepInfo *mySleepInfo = [[FBKDeviceSleepInfo alloc] init];
                mySleepInfo.normalStart = @"22:00";  // 时间为24小时制 格式必须为“HH:mm”
                mySleepInfo.normalEnd   = @"08:00";  // 时间为24小时制 格式必须为“HH:mm”
                mySleepInfo.weekdayStart= @"23:49";  // 时间为24小时制 格式必须为“HH:mm”
                mySleepInfo.weekdaylEnd = @"09:00";  // 时间为24小时制 格式必须为“HH:mm”
                [m_newBandApi setSleepInfoApi:mySleepInfo];
            }
            else if (myRow == 2) {
                // 设置个人喝水信息
                FBKDeviceIntervalInfo *myWaterInfo = [[FBKDeviceIntervalInfo alloc] init];
                myWaterInfo.amTime = @"08:00-12:00"; // 时间为24小时制 格式必须为“HH:mm-HH:mm”
                myWaterInfo.pmTime = @"17:00-19:00"; // 时间为24小时制 格式必须为“HH:mm-HH:mm”
                myWaterInfo.intervalTime = @"44";    // 间隔时间的范围为0-255(分钟)
                myWaterInfo.switchStatus = @"0";     // 0代表关闭  1代表打开
                [m_newBandApi setWaterInfoApi:myWaterInfo];
            }
            else if (myRow == 3) {
                // 设置个人久坐信息
                FBKDeviceIntervalInfo *mySitInfo = [[FBKDeviceIntervalInfo alloc] init];
                mySitInfo.amTime = @"08:00-12:00"; // 时间为24小时制 格式必须为“HH:mm-HH:mm”
                mySitInfo.pmTime = @"17:00-19:00"; // 时间为24小时制 格式必须为“HH:mm-HH:mm”
                mySitInfo.intervalTime = @"44";    // 间隔时间的范围为0-255(分钟)
                mySitInfo.switchStatus = @"0";     // 0代表关闭  1代表打开
                [m_newBandApi setSitInfoApi:mySitInfo];
            }
            else if (myRow == 4) {
                // 设置个人通知信息
                FBKDeviceNoticeInfo *myNoticeInfo = [[FBKDeviceNoticeInfo alloc] init];
                myNoticeInfo.missedCall = @"1";   // 0代表关闭  1代表打开
                myNoticeInfo.mail = @"1";         // 0代表关闭  1代表打开
                myNoticeInfo.shortMessage = @"1"; // 0代表关闭  1代表打开
                myNoticeInfo.weChat = @"0";       // 0代表关闭  1代表打开
                myNoticeInfo.qq = @"1";           // 0代表关闭  1代表打开
                myNoticeInfo.skype = @"1";        // 0代表关闭  1代表打开
                myNoticeInfo.whatsAPP = @"1";     // 0代表关闭  1代表打开
                myNoticeInfo.faceBook = @"1";     // 0代表关闭  1代表打开
                myNoticeInfo.others = @"1";       // 0代表关闭  1代表打开
                [m_newBandApi setNoticeInfoApi:myNoticeInfo];
            }
            else if (myRow == 5) {
                // 设置个人闹钟信息
                NSArray *week1 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",nil];
                FBKDeviceAlarmInfo *myAlarmInfo1 = [[FBKDeviceAlarmInfo alloc] init];
                myAlarmInfo1.alarmId = @"0";       // 闹钟的ID号，根据ID号修改闹钟的信息
                myAlarmInfo1.alarmName = @"起床";   // 闹钟提示信息（不超过5个字符）
                myAlarmInfo1.alarmTime = @"14.05"; // 时间为24小时制 格式必须为“HH:mm”
                myAlarmInfo1.switchStatus = @"0";  // 0代表关闭  1代表打开
                myAlarmInfo1.repeatTime = week1;   // 0代表为单次提醒（见下一条信息）  1代表周一 2代表周二......
                
                NSArray *week2 = [NSArray arrayWithObjects:@"0",nil];
                FBKDeviceAlarmInfo *myAlarmInfo2 = [[FBKDeviceAlarmInfo alloc] init];
                myAlarmInfo2.alarmId = @"1";                  // 闹钟的ID号，根据ID号修改闹钟的信息
                myAlarmInfo2.alarmName = @"生日";              // 闹钟提示信息（不超过5个字符）
                myAlarmInfo2.alarmTime = @"2017-11-28 14:17"; // 时间为24小时制 格式必须为“yyyy-MM-dd HH:mm”
                myAlarmInfo2.switchStatus = @"0";             // 0代表关闭  1代表打开
                myAlarmInfo2.repeatTime = week2;              // 0代表为单次提醒
                
                NSArray *alarmArray = [NSArray arrayWithObjects:myAlarmInfo1, myAlarmInfo2, nil];
                [m_newBandApi setAlarmInfoApi:alarmArray];
            }
            else if (myRow == 6) {
                // 设置单车参数
                [m_newBandApi setBikeInfoApi:@"2.096"];
            }
            else if (myRow == 7) {
                // 设置心率最大值
                [m_newBandApi setHeartRateMaxApi:@"195"];
            }
            else if (myRow == 8) {
                // 开启实时数据
                [m_newBandApi openRealTimeStepsApi:YES];
            }
            else if (myRow == 9) {
                // 开启拍照息
                [m_newBandApi openTakePhotoApi:YES];
            }
            else if (myRow == 10) {
                // 开启心率模式
                [m_newBandApi openHeartRateModeApi:YES];
            }
            else if (myRow == 11) {
                // 获取所有历史数据
                [m_newBandApi getTotalHistory];
            }
            else if (myRow == 12) {
                // 获取运动历史数据
                [m_newBandApi getStepHistory];
            }
            else if (myRow == 13) {
                // 获取心率历史数据
                [m_newBandApi getHeartRateHistory];
            }
            else if (myRow == 14) {
                // 获取踏频历史数据
                [m_newBandApi getBikeHistory];
            }
            else if (myRow == 15) {
                // 获取训练历史数据
                [m_newBandApi getTrainHistory];
            }
            else if (myRow == 16) {
                // 获取睡眠历史数据
                [m_newBandApi getSleepHistory];
            }
            else if (myRow == 17) {
                // 获取每天步数总和历史数据
                [m_newBandApi getEverydayHistory];
            }
            else if (myRow == 18) {
                // 校准时间
                [m_newBandApi setUtc];
            }
            else if (myRow == 19) {
                // 关闭实时数据
                [m_newBandApi openRealTimeStepsApi:NO];
            }
            else if (myRow == 20) {
                // 查询电量
                [m_newBandApi readDevicePower];
            }
            else if (myRow == 21) {
                [m_newBandApi readFirmwareVersion];
            }
            else if (myRow == 22) {
                [m_newBandApi readHardwareVersion];
            }
            else if (myRow == 23) {
                [m_newBandApi readSoftwareVersion];
            }
            else if (myRow == 24) {
                [m_newBandApi openHRTenModeApi:YES];
            }
            else if (myRow == 25)
            {
                [m_newBandApi getPrivateMacAddress];
            }
            else if (myRow == 26)
            {
                [m_newBandApi getPrivateVersion];
            }
            else if (myRow == 27)
            {
                [m_newBandApi enterOTAMode];
            }
        }
    }
}


@end
