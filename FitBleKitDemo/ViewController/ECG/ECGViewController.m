/********************************************************************************
 * 文件名称：ECGViewController.m
 * 内容摘要：ECG
 * 版本编号：1.0.1
 * 创建日期：2021年01月20日
 ********************************************************************************/

#import "ECGViewController.h"
#import "BindDeviceViewController.h"
#import "CFileOperate.h"

@interface ECGViewController () <UITableViewDataSource, UITableViewDelegate, DeviceIdDelegate, FBKApiBsaeDataSource, FBKApiECGDelegate> {
    UITableView    *m_cmdTableView;     // 命令列表
    NSMutableArray *m_cmdArray;         // 命令列表数据
    UILabel        *m_alertLab;         // 连接状态
    UILabel        *m_realTimeLab;      // 实时数据展示
    UITextView     *m_content;          // 获取到的数据展示
    UITableView    *m_deviceTableView;  // 设备列表
    NSMutableArray *m_deviceList;       // 设备列表数据
    int            m_maxNumber;         // 选择的设备数（不超过7个）
    int            m_chooseNumber;      // 选择设备展示的数据
    ECGShowColor   m_showColor;
    
    NSMutableArray *m_ECGArray;         // ECG数据
    UIDocumentInteractionController *m_documentController;
}

@end

@implementation ECGViewController

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
    
    m_showColor = ShowGreenColor;
    m_maxNumber = 0;
    m_chooseNumber = 0;
    m_deviceList = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        FBKApiECG *ecgApi = [[FBKApiECG alloc] init];
        ecgApi.delegate = self;
        ecgApi.dataSource = self;
        
        DeviceClass *myBleDevice = [[DeviceClass alloc] init];
        myBleDevice.bleDevice = ecgApi;
        myBleDevice.deviceId = @"";
        myBleDevice.isAvailable = NO;
        myBleDevice.connectStatus = DeviceBleClosed;
        [m_deviceList addObject:myBleDevice];
    }
    
    m_ECGArray = [[NSMutableArray alloc] init];
    m_cmdArray = [[NSMutableArray alloc] initWithObjects:
                  @"Device battery",
                  @"Device firmware version",
                  @"Device hardware version",
                  @"Device software version",
                  @"Device System data",
                  @"Device Model String",
                  @"Device Serial Number",
                  @"Device Manufacturer Name",
                  @"P_Mac Address",
                  @"P_Total Version",
                  @"P_Enter OTA Mode",
                  @"Set Device Color",
                  @"Share ECG List",
                  @"Enter ECG Mode",
                  @"Exit ECG Mode",
                  @"Enter HRV Mode",
                  @"Exit HRV Mode",
                  @"Open ECG Data",
                  @"Close ECG Data",
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
    titleLab.text = @"ECG";
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
    m_realTimeLab.text = @"ECG: -- ";
    m_realTimeLab.textColor = [UIColor whiteColor];
    m_realTimeLab.textAlignment = NSTextAlignmentCenter;
    m_realTimeLab.font = [UIFont systemFontOfSize:16];
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
            m_deviceTableView.frame = CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
        return;
    }
    
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        if (myBleDevice.deviceId.length != 0) {
            FBKApiECG *ecgApi = myBleDevice.bleDevice;
            [ecgApi disconnectBleApi];
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
        bindView.scanDeviceType = BleDeviceCadence;
        bindView.delegate = self;
        [self.navigationController pushViewController:bindView animated:YES];
    }
}


- (void)shareEcgData {
    NSMutableString *ecgString = [[NSMutableString alloc] init];
    for (int i = 0; i < m_ECGArray.count; i++) {
        if (i == m_ECGArray.count-1) {
            [ecgString appendString:[m_ECGArray objectAtIndex:i]];
        }
        else {
            [ecgString appendString:[m_ECGArray objectAtIndex:i]];
            [ecgString appendString:@"\n"];
        }
    }
    
    CFileOperate *myFile = [[CFileOperate alloc] init];
    [myFile saveStringToFile:ecgString withName:@"ECGLog.txt"];
    
    NSString *fileString = [myFile dataFilePath:@"ECGLog.txt"];
    NSURL *filePath = [NSURL fileURLWithPath:fileString];
    m_documentController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
    m_documentController.UTI = @"public.text";
    [m_documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
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
            FBKApiECG *ecgApi = myBleDevice.bleDevice;
            [ecgApi startConnectBleApi:myBleDevice.deviceId andIdType:DeviceIdUUID];
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
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        FBKApiECG *listApi = myBleDevice.bleDevice;
        if (ecgApi == listApi) {
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
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_alertLab.text = [ShowTools showDeviceStatus:status];
        if (!ecgApi.isConnected) {
            m_realTimeLab.text = @"ECG: --";
        }
    }
}


/********************************************************************************
 * 方法名称：bleConnectError
 * 功能描述：蓝牙连接错误信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)error andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nError: %@",ecgApi.deviceId,error];
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
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        NSString *bai = @"%";
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nPower: %@%@",ecgApi.deviceId,power,bai];
    }
}


/********************************************************************************
 * 方法名称：deviceFirmware
 * 功能描述：固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nFirmware version: %@",ecgApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceHardware
 * 功能描述：硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nHardware version: %@",ecgApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceSoftware
 * 功能描述：软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSoftware version: %@",ecgApi.deviceId,version];
    }
}


- (void)deviceSystemData:(NSData *)systemData andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSystem Data: %@",ecgApi.deviceId,systemData];
    }
}

- (void)deviceModelString:(NSString *)modelString andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nModel String: %@",ecgApi.deviceId,modelString];
    }
}

- (void)deviceSerialNumber:(NSString *)serialNumber andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSerial Number: %@",ecgApi.deviceId,serialNumber];
    }
}

- (void)deviceManufacturerName:(NSString *)manufacturerName andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nManufacturer Name: %@",ecgApi.deviceId,manufacturerName];
    }
}


/********************************************************************************
 * 方法名称：privateVersion
 * 功能描述：获取私有版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateVersion:(NSDictionary *)versionMap andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"%@",versionMap];
    }
}


/********************************************************************************
 * 方法名称：privateMacAddress
 * 功能描述：获取私有MAC地址
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateMacAddress:(NSDictionary *)macMap andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"%@",macMap];
    }
}


/********************************************************************************
 * 方法名称：realTimeECG
 * 功能描述：realTimeECG
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)realTimeECG:(NSArray *)ECGArray withSort:(int)sortNo andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        [m_ECGArray addObjectsFromArray:ECGArray];
        NSMutableString *ecgString = [[NSMutableString alloc] initWithFormat:@"%i ECG:",sortNo];
        for (int i = 0; i < ECGArray.count; i++) {
            [ecgString appendString:[ECGArray objectAtIndex:i]];
            if (i != ECGArray.count-1) {
                [ecgString appendString:@","];
            }
        }
        m_realTimeLab.text = ecgString;
    }
}


/********************************************************************************
 * 方法名称：realTimeHeartRate
 * 功能描述：realTimeHeartRate
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)realTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_content.text = [NSString stringWithFormat:@"heart rate: %@",HRInfo];
    }
}


/********************************************************************************
 * 方法名称：setColorResult
 * 功能描述：setColorResult
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setColorResult:(BOOL)status andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_realTimeLab.text = [NSString stringWithFormat:@"setColorResult:%i",status];
    }
}


- (void)ecgSwitchResult:(BOOL)status andDevice:(id)bleDevice {
    FBKApiECG *ecgApi = (FBKApiECG *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiECG *chooseApi = (FBKApiECG *)myBleDevice.bleDevice;
    if (chooseApi == ecgApi) {
        m_realTimeLab.text = [NSString stringWithFormat:@"ecgSwitchResult:%i",status];
    }
}


- (void)ECGHRVData:(BOOL)status withData:(NSDictionary *)hrvMap andDevice:(id)bleDevice {
    NSLog(@"ECGHRVData --- %i --- %@",status,hrvMap);
}


- (void)ECGListData:(BOOL)status withData:(NSArray *)ecgArray andDevice:(id)bleDevice {
    NSLog(@"ECGListData --- %i --- %@",status,ecgArray);
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
            self->m_deviceTableView.frame = CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
    }
    else {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
        FBKApiECG *ecgApi = (FBKApiECG *)myBleDevice.bleDevice;
        if (ecgApi.isConnected) {
            if (myRow == 0) {
                [ecgApi readDevicePower];
            }
            else if (myRow == 1) {
                [ecgApi readFirmwareVersion];
            }
            else if (myRow == 2) {
                [ecgApi readHardwareVersion];
            }
            else if (myRow == 3) {
                [ecgApi readSoftwareVersion];
            }
            else if (myRow == 4) {
                [ecgApi readSystemId];
            }
            else if (myRow == 5) {
                [ecgApi readModelString];
            }
            else if (myRow == 6) {
                [ecgApi readSerialNumber];
            }
            else if (myRow == 7) {
                [ecgApi readManufacturerName];
            }
            else if (myRow == 8) {
                [ecgApi getPrivateMacAddress];
            }
            else if (myRow == 9) {
                [ecgApi getPrivateVersion];
            }
            else if (myRow == 10) {
//                [ecgApi enterOTAMode];
            }
            else if (myRow == 11) {
                if (m_showColor == ShowGreenColor) {
                    m_showColor = ShowBlueColor;
                }
                else if (m_showColor == ShowBlueColor) {
                    m_showColor = ShowRedColor;
                }
                else if (m_showColor == ShowRedColor) {
                    m_showColor = ShowGreenColor;
                }
                
                [ecgApi setDeviceColor:m_showColor];
            }
            else if (myRow == 12) {
                [self shareEcgData];
            }
            else if (myRow == 13) {
                [ecgApi enterECGMode:true];
            }
            else if (myRow == 14) {
                [ecgApi enterECGMode:false];
            }
            else if (myRow == 15) {
                [ecgApi enterHRVMode:true];
            }
            else if (myRow == 16) {
                [ecgApi enterHRVMode:false];
            }
            else if (myRow == 17) {
                [ecgApi ecgDataSwitch:true];
            }
            else if (myRow == 18) {
                [ecgApi ecgDataSwitch:false];
            }
        }
    }
}


@end
