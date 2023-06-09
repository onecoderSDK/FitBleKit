/********************************************************************************
 * 文件名称：HubConfigViewController.m
 * 内容摘要：HUB 900配置
 * 版本编号：1.0.1
 * 创建日期：2018年07月05日
 ********************************************************************************/

#import "Hub900ViewController.h"
#import "BindDeviceViewController.h"
#import "WiFiListViewController.h"
#import "HubParamViewController.h"

@interface Hub900ViewController ()<UITableViewDataSource, UITableViewDelegate, DeviceIdDelegate, FBKApiBsaeDataSource, FBKApiHubConfigDelegate,WiFiListDelegate,UITextFieldDelegate,HubParamDelegate> {
    UITableView    *m_cmdTableView;      // 命令列表
    NSMutableArray *m_cmdArray;          // 命令列表数据
    UILabel        *m_alertLab;          // 连接状态
    UITextView     *m_content;           // 获取到的数据展示
    UITableView    *m_deviceTableView;   // 设备列表
    NSMutableArray *m_deviceList;        // 设备列表数据
    int            m_maxNumber;          // 选择的设备数（不超过7个）
    int            m_chooseNumber;       // 选择设备展示的数据
    UITextField    *m_loginField;        // 登录UI
    UITextField    *m_setPwField;        // 密码UI
    BOOL           m_isSocketA;          // 选择的配置Socket
    NSString       *m_loginPwString;     // 登录密码
    NSString       *m_setPwString;       // 设置登录密码
    int            m_staNumber;          // 状态
    BOOL           m_setUsePw;           // 是否设置了密码
    NSMutableDictionary *m_staInfoDic;   // sta信息
    NSMutableDictionary *m_socketGetDic; // 得到的socket信息
    NSMutableDictionary *m_socketSetDic; // 设置的socket信息
}

@end

@implementation Hub900ViewController

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
        FBKApiHubConfig *hubConfigApi = [[FBKApiHubConfig alloc] init];
        hubConfigApi.delegate = self;
        hubConfigApi.dataSource = self;
        
        DeviceClass *myBleDevice = [[DeviceClass alloc] init];
        myBleDevice.bleDevice = hubConfigApi;
        myBleDevice.deviceId = @"";
        myBleDevice.isAvailable = NO;
        myBleDevice.connectStatus = DeviceBleClosed;
        [m_deviceList addObject:myBleDevice];
    }
    
    m_setUsePw = YES;
    m_isSocketA = YES;
    m_staNumber = 1;
    
    m_socketGetDic = [[NSMutableDictionary alloc] init];
    [m_socketGetDic setObject:@"0" forKey:@"hubSocketNo"];
    
    m_socketSetDic = [[NSMutableDictionary alloc] init];
    [m_socketSetDic setObject:@"0" forKey:@"hubSocketNo"];
    [m_socketSetDic setObject:@"2" forKey:@"hubSocketProtocol"];
    [m_socketSetDic setObject:@"2" forKey:@"hubSocketCs"];
    [m_socketSetDic setObject:@"service.spotech.cn" forKey:@"hubSocketIp"];
    [m_socketSetDic setObject:@"9124" forKey:@"hubSocketPort"];
    m_staInfoDic   = [[NSMutableDictionary alloc] init];
    
    m_loginPwString  = [[NSString alloc] init];
    m_loginPwString = @"123456";
    m_setPwString  = [[NSString alloc] init];
    m_setPwString = @"123456";
    
    m_cmdArray = [[NSMutableArray alloc] initWithObjects:
                        @"Hub Login",
                        @"Get Login Password",
                        @"Set Login Password",
                        @"Scan WiFi",
                        @"Get STA Information",
                        @"Set STA Information",
                        @"Get Socket Information",
                        @"Set Socket Information",
                        @"Get WiFi Work Type",
                        @"Set WiFi Work Type",
                        @"Get Hub IP",
                        @"Restart Hub",
                        @"Reset Hub",
                        @"Get WiFi Status",
                        @"Get Power",
                        @"Device firmware version",
                        @"Device hardware version",
                        @"Device software version",
                        @"Get 4G APN",
                        @"Set 4G APN",
                        @"Set Data Type",
                        @"Set Scan Switch",
                        @"Set Scan Info",
                        @"Get Systen Status",
                        @"Get Net mode",
                        @"P_Mac Address",
                        @"P_Total Version",
                        @"P_Enter OTA Mode",
                        @"Get IPV4 info",
                        @"Set IPV4 info",
                        @"Set Lora channel",
                        @"Diagnosis Lora channel",
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
    titleLab.text = @"RC900";
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
    
    m_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 130+cmdTableHi, self.view.frame.size.width, self.view.frame.size.height-130-cmdTableHi)];
    m_content.backgroundColor = [UIColor blackColor];
    m_content.font = [UIFont systemFontOfSize:18];
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
            FBKApiHubConfig *hubConfigApi = myBleDevice.bleDevice;
            [hubConfigApi disconnectBleApi];
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
    [self hiddenKeyboard];
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    if (myBleDevice.deviceId.length > 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self->m_deviceTableView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
    }
    else {
        BindDeviceViewController *bindView = [[BindDeviceViewController alloc] init];
        bindView.scanDeviceType = BleDeviceHubConfig;
        bindView.delegate = self;
        [self.navigationController pushViewController:bindView animated:YES];
    }
}


/********************************************************************************
 * 方法名称：chooseWiFiStaInfo
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)chooseWiFiStaInfo:(NSDictionary *)staInfo {
    m_staInfoDic = [[NSMutableDictionary alloc] initWithDictionary:staInfo];
    [m_cmdTableView reloadData];
}


/********************************************************************************
 * 方法名称：hiddenKeyboard
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hiddenKeyboard {
    [m_loginField resignFirstResponder];
    [m_setPwField resignFirstResponder];
}


/********************************************************************************
 * 方法名称：setParam
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setParam:(UIButton *)sender {
    if (sender.tag == 306) {
        HubParamViewController *pramView = [[HubParamViewController alloc] init];
        pramView.delegate = self;
        pramView.hubInfo = m_socketGetDic;
        pramView.isSetParam = NO;
        [self.navigationController pushViewController:pramView animated:YES];
    }
    else {
        HubParamViewController *pramView = [[HubParamViewController alloc] init];
        pramView.delegate = self;
        pramView.hubInfo = m_socketSetDic;
        pramView.isSetParam = YES;
        [self.navigationController pushViewController:pramView animated:YES];
    }
}


/********************************************************************************
 * 方法名称：setStaNumber
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setStaNumber {
    if (m_staNumber == 1) {
        m_staNumber = 2;
    }
    else if (m_staNumber == 2) {
        m_staNumber = 0;
    }
    else if (m_staNumber == 0) {
        m_staNumber = 1;
    }
    
    [m_cmdTableView reloadData];
}


/********************************************************************************
 * 方法名称：loginSetSwitch
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loginSetSwitch:(UISwitch *)sender {
    if (sender.on) {
        m_setUsePw = YES;
    }
    else {
        m_setUsePw = NO;
    }
    [m_cmdTableView reloadData];
}


/********************************************************************************
 * 方法名称：hubEncryption
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSString *)hubEncryption:(NSString *)hubEncryptionNum {
    if ([hubEncryptionNum containsString:@"4"]) {
        return @"WPA2PSK";
    }
    else if ([hubEncryptionNum containsString:@"3"]) {
        return @"WPAPSK";
    }
    else if ([hubEncryptionNum containsString:@"2"]) {
        return @"SHARED";
    }
    else if ([hubEncryptionNum containsString:@"1"]) {
        return @"OPEN";
    }
    else {
        return @"NULL";
    }
}


/********************************************************************************
 * 方法名称：hubAlgorithm
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSString *)hubAlgorithm:(NSString *)hubAlgorithmNum {
    if ([hubAlgorithmNum containsString:@"5"]) {
        return @"AES";
    }
    else if ([hubAlgorithmNum containsString:@"4"]) {
        return @"TKIP";
    }
    else if ([hubAlgorithmNum containsString:@"3"]) {
        return @"WEP_A";
    }
    else if ([hubAlgorithmNum containsString:@"2"]) {
        return @"WEP_H";
    }
    else if ([hubAlgorithmNum containsString:@"1"]) {
        return @"NONE";
    }
    else {
        return @"NULL";
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
            FBKApiHubConfig *hubConfigApi = myBleDevice.bleDevice;
            [hubConfigApi startConnectBleApi:myBleDevice.deviceId andIdType:DeviceIdUUID];
            NSLog(@"myBleDevice.deviceId %@",myBleDevice.deviceId);
        }
    }
    [m_deviceTableView reloadData];
}


/********************************************************************************
 * 方法名称：hubParamResult
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubParamResult:(NSDictionary *)setInfo isSet:(BOOL)isSetMark {
    if (isSetMark) {
        [m_socketSetDic addEntriesFromDictionary:setInfo];
    }
    else {
        [m_socketGetDic addEntriesFromDictionary:setInfo];
    }
    [m_cmdTableView reloadData];
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        FBKApiHubConfig *listApi = myBleDevice.bleDevice;
        if (hubConfigApi == listApi) {
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
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
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
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nError: %@",hubConfigApi.deviceId,error];
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
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice
{
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        NSString *bai = @"%";
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nPower: %@%@",hubConfigApi.deviceId,power,bai];
    }
}


/********************************************************************************
 * 方法名称：deviceFirmware
 * 功能描述：固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nFirmware version: %@",hubConfigApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceHardware
 * 功能描述：硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nHardware version: %@",hubConfigApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceSoftware
 * 功能描述：软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSoftware version: %@",hubConfigApi.deviceId,version];
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
 * 方法名称：hubVersion
 * 功能描述：协议版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubVersion:(NSString *)version andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nProtocol version: %@",hubConfigApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：hubLoginStatus
 * 功能描述：hub登录状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubLoginStatus:(BOOL)status andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        if (status) {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nLogin succeed",hubConfigApi.deviceId];
        }
        else {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nlogin failed",hubConfigApi.deviceId];
        }
    }
}


/********************************************************************************
 * 方法名称：hubLoginPassword
 * 功能描述：hub登录密码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubLoginPassword:(NSDictionary *)passwordInfo andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        NSString *hubIsHavePw = [passwordInfo objectForKey:@"passwordInfo"];
        if ([hubIsHavePw isEqualToString:@"0"]) {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nPassword is nil",hubConfigApi.deviceId];
            m_content.text = @"密码为空";
        }
        else {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nPassword is %@",hubConfigApi.deviceId,[passwordInfo objectForKey:@"hubPassword"]];
        }
    }
}


/********************************************************************************
 * 方法名称：hubWifiList
 * 功能描述：hub wifi列表
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubWifiList:(NSArray *)wifiList andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        NSMutableArray *myListArray = [[NSMutableArray alloc] initWithArray:wifiList];
        if (myListArray.count > 0) {
            WiFiListViewController *wifiListView = [[WiFiListViewController alloc] init];
            wifiListView.scanWifiList = myListArray;
            wifiListView.delegate = self;
            [self.navigationController pushViewController:wifiListView animated:YES];
        }
    }
}


/********************************************************************************
 * 方法名称：hubWifiWorkMode
 * 功能描述：hub wifi工作模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubWifiWorkMode:(NSString *)workMode andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        if ([workMode isEqualToString:@"0"]) {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nMode: AP",hubConfigApi.deviceId];
        }
        else if ([workMode isEqualToString:@"1"]) {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nMode: STA",hubConfigApi.deviceId];
        }
        else {
            m_content.text = [NSString stringWithFormat:@"Device ID: %@\nMode: AP+STA",hubConfigApi.deviceId];
        }
    }
}


/********************************************************************************
 * 方法名称：hubWifiSTAInfo
 * 功能描述：hub wifi STA信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubWifiSTAInfo:(NSDictionary *)staInfo andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        NSMutableString *myString = [[NSMutableString alloc] init];
        [myString appendFormat:@"hubSsid: %@\n",[staInfo objectForKey:@"hubSsid"]];
        [myString appendFormat:@"hubPassword: %@\n",[staInfo objectForKey:@"hubPassword"]];
        [myString appendFormat:@"hubEncryption: %@\n",[self hubEncryption:[staInfo objectForKey:@"hubEncryption"]]];
        [myString appendFormat:@"hubAlgorithm: %@\n",[self hubAlgorithm:[staInfo objectForKey:@"hubAlgorithm"]]];
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSTAInfo: %@",hubConfigApi.deviceId,myString];
    }
}


- (void)hubNetWorkMode:(NSString *)netWorkMode andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID:%@\n hubNetWorkMode: %@",hubConfigApi.deviceId,netWorkMode];
    }
}


/********************************************************************************
 * 方法名称：hubWifiSocketInfo
 * 功能描述：hub wifi Socket信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubWifiSocketInfo:(NSDictionary *)socketInfo andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        NSMutableString *myString = [[NSMutableString alloc] init];
        if ([[socketInfo objectForKey:@"hubSocketNo"] isEqualToString:@"0"]) {
            [myString appendFormat:@"Socket No: %@\n",@"A"];
        }
        else {
            [myString appendFormat:@"Socket No: %@\n",@"B"];
        }
        
        [myString appendFormat:@"SocketIp: %@\n",[socketInfo objectForKey:@"hubSocketIp"]];
        [myString appendFormat:@"SocketPort: %@\n",[socketInfo objectForKey:@"hubSocketPort"]];
        
        if ([[socketInfo objectForKey:@"hubSocketProtocol"] isEqualToString:@"2"]) {
            [myString appendFormat:@"SocketProtocol: %@\n",@"UDP"];
        }
        else {
            [myString appendFormat:@"Socket No: %@\n",@"TCP"];
        }
        
        if ([[socketInfo objectForKey:@"hubSocketCs"] isEqualToString:@"2"]) {
            [myString appendFormat:@"SocketCs: %@\n",@"Client"];
        }
        else {
            [myString appendFormat:@"SocketCs: %@\n",@"Server"];
        }
        
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSocketInfo: %@",hubConfigApi.deviceId,myString];
    }
}


/********************************************************************************
 * 方法名称：hubIpKeyInfo
 * 功能描述：hub IP信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubIpKeyInfo:(NSDictionary *)ipKeyInfo andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        NSMutableString *myString = [[NSMutableString alloc] init];
        [myString appendFormat:@"IP: %@\n",[ipKeyInfo objectForKey:@"hubIp"]];
        [myString appendFormat:@"Hub Mask: %@\n",[ipKeyInfo objectForKey:@"hubMask"]];
        [myString appendFormat:@"Hub Gat eWay: %@\n",[ipKeyInfo objectForKey:@"hubGateWay"]];
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID: %@\nIpKeyInfo: %@",hubConfigApi.deviceId,myString];
    }
}

/********************************************************************************
 * 方法名称：hubWifiStatus
 * 功能描述：hub wifi状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hubWifiStatus:(NSDictionary *)statusInfo andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        int hubWifiCfgStatus = [[statusInfo objectForKey:@"hubWifiCfgStatus"] intValue];
        int hubWifiConnectStatus = [[statusInfo objectForKey:@"hubWifiConnectStatus"] intValue];
        
        NSString *statusString = @"";
        if (hubWifiCfgStatus == 0) {
            statusString = @"Idle";
        }
        else if (hubWifiCfgStatus == 1) {
            statusString = @"Busy";
        }
        else if (hubWifiCfgStatus == 2) {
            statusString = @"Set Failed";
        }
        else if (hubWifiCfgStatus == 3) {
            statusString = @"Set Succeed";
        }
        
        if (hubWifiConnectStatus == 0) {
            statusString = [NSString stringWithFormat:@"%@&Disconnect",statusString];
        }
        else if (hubWifiConnectStatus == 1) {
            statusString = [NSString stringWithFormat:@"%@&Connected",statusString];
        }
        
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nStatus: %@",hubConfigApi.deviceId,statusString];
        [m_cmdTableView reloadData];
    }
}


// hub 4G APN
- (void)hub4GAPN:(NSDictionary *)statusInfo andDevice:(id)bleDevice{
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID:%@\n hub4GAPN: %@",hubConfigApi.deviceId,statusInfo];
    }
}

// hub System Status
- (void)hubSystemStatus:(NSDictionary *)statusInfo andDevice:(id)bleDevice{
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID:%@\n hubSystemStatus: %@",hubConfigApi.deviceId,statusInfo];
    }
}


// hub IPV4 信息
- (void)hubIPV4Info:(NSDictionary *)valueMap andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID:%@\n hubIPV4Info: %@",hubConfigApi.deviceId,valueMap];
    }
}

// 设置Lora通道结果
- (void)hubSetLoraResult:(NSDictionary *)valueMap andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID:%@\n hubSetLoraResult: %@",hubConfigApi.deviceId,valueMap];
    }
}

// 诊断Lora通道结果
- (void)hubDiagnosisLoraResult:(NSDictionary *)valueMap andDevice:(id)bleDevice {
    FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiHubConfig *chooseApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
    if (hubConfigApi == chooseApi) {
        m_content.text = m_content.text = [NSString stringWithFormat:@"Device ID:%@\n hubDiagnosisLoraResult: %@",hubConfigApi.deviceId,valueMap];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellString = @"Hub900Cell";
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
    
    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 50)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:15];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"%i、%@",(int)indexPath.row+1,[m_cmdArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:info1Lab];
    
    UILabel *info2Lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 0, 100, 50)];
    info2Lab.textAlignment = NSTextAlignmentRight;
    info2Lab.font = [UIFont systemFontOfSize:15];
    info2Lab.textColor = [UIColor blackColor];
    info2Lab.text = @"";
    [cell.contentView addSubview:info2Lab];
    
    if (indexPath.row == 0) {
        m_loginField = [[UITextField alloc] init];
        m_loginField.frame = CGRectMake(self.view.frame.size.width-120, 0, 120, 50);
        m_loginField.backgroundColor = [UIColor blackColor];
        m_loginField.returnKeyType = UIReturnKeyDefault;
        [m_loginField setTintColor:[UIColor whiteColor]];
        m_loginField.font = [UIFont systemFontOfSize:15];
        m_loginField.textColor = [UIColor whiteColor];
        m_loginField.text = m_loginPwString;
        m_loginField.delegate = self;
        [cell.contentView addSubview:m_loginField];
    }
    else if (indexPath.row == 2) {
        UISwitch *markSwitch = [[UISwitch alloc] init];
        markSwitch.frame = CGRectMake(self.view.frame.size.width-170, 10, 50, 30);
        markSwitch.backgroundColor = [UIColor clearColor];
        markSwitch.on = NO;
        [markSwitch addTarget:self action:@selector(loginSetSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:markSwitch];
        
        if (m_setUsePw) {
            markSwitch.on = YES;
        }
        
        m_setPwField = [[UITextField alloc] init];
        m_setPwField.frame = CGRectMake(self.view.frame.size.width-120, 0, 120, 50);
        m_setPwField.backgroundColor = [UIColor blackColor];
        m_setPwField.returnKeyType = UIReturnKeyDefault;
        [m_setPwField setTintColor:[UIColor whiteColor]];
        m_setPwField.font = [UIFont systemFontOfSize:15];
        m_setPwField.textColor = [UIColor whiteColor];
        m_setPwField.text = m_setPwString;
        m_setPwField.delegate = self;
        [cell.contentView addSubview:m_setPwField];
    }
    else if (indexPath.row == 5) {
        if (m_staInfoDic.allKeys.count > 0) {
            info2Lab.frame = CGRectMake(self.view.frame.size.width-180, 0, 170, 50);
            info2Lab.adjustsFontSizeToFitWidth = YES;
            info2Lab.text = [NSString stringWithFormat:@"%@(%@/%@)",[m_staInfoDic objectForKey:@"ssidName"],[m_staInfoDic objectForKey:@"encryptionName"],[m_staInfoDic objectForKey:@"algorithmName"]];
        }
    }
    else if (indexPath.row == 6 || indexPath.row == 7) {
        UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 0, 80, 50)];
        setButton.tag = 300+indexPath.row;
        setButton.backgroundColor = [UIColor blackColor];
        [setButton setTitle:@"Set A" forState:UIControlStateNormal];
        [setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        setButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [setButton addTarget:self action:@selector(setParam:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:setButton];
        
        if (indexPath.row == 6) {
            NSString *hubSocketNo = [NSString stringWithFormat:@"%@",[m_socketGetDic objectForKey:@"hubSocketNo"]];
            if ([hubSocketNo isEqualToString:@"1"]) {
                [setButton setTitle:@"Set B" forState:UIControlStateNormal];
            }
        }
        else {
            NSString *hubSocketNo = [NSString stringWithFormat:@"%@",[m_socketSetDic objectForKey:@"hubSocketNo"]];
            if ([hubSocketNo isEqualToString:@"1"]) {
                [setButton setTitle:@"Set B" forState:UIControlStateNormal];
            }
        }
    }
    else if (indexPath.row == 9) {
        UIButton *staButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 0, 80, 50)];
        staButton.backgroundColor = [UIColor blackColor];
        [staButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        staButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [staButton addTarget:self action:@selector(setStaNumber) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:staButton];
        
        if (m_staNumber == 1) {
            [staButton setTitle:@"STA" forState:UIControlStateNormal];
        }
        else if (m_staNumber == 2) {
            [staButton setTitle:@"AP+STA" forState:UIControlStateNormal];
        }
        else if (m_staNumber == 0) {
            [staButton setTitle:@"AP" forState:UIControlStateNormal];
        }
    }
    
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
    [self hiddenKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int myRow = (int)indexPath.row;
    
    if (tableView == m_deviceTableView) {
        if (m_chooseNumber != myRow) {
            m_chooseNumber = myRow;
            [m_staInfoDic removeAllObjects];
            [tableView reloadData];
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            m_deviceTableView.frame = CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height-80);
        }];
    }
    else {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
        FBKApiHubConfig *hubConfigApi = (FBKApiHubConfig *)myBleDevice.bleDevice;
        if (hubConfigApi.isConnected) {
            if (myRow == 0) {
                [hubConfigApi hubLogin:m_loginPwString];
            }
            else if (myRow == 1) {
                [hubConfigApi getHubPassword];
            }
            else if (myRow == 2) {
                NSMutableDictionary *pwDic = [[NSMutableDictionary alloc] init];
                [pwDic setObject:@"1" forKey:@"hubPwMark"];
                [pwDic setObject:m_setPwString forKey:@"hubPassword"];
                
                if (!m_setUsePw) {
                    [pwDic setObject:@"0" forKey:@"hubPwMark"];
                }
                
                [hubConfigApi setHubPassword:pwDic];
            }
            else if (myRow == 3) {
                [hubConfigApi scanHubWifi];
            }
            else if (myRow == 4) {
                [hubConfigApi getHubWifiSTA];
            }
            else if (myRow == 5) {
                if (m_staInfoDic.allKeys.count > 0) {
                    [hubConfigApi setHubWifiSTA:m_staInfoDic];
                }
            }
            else if (myRow == 6) {
                [hubConfigApi getHubSocketInfo:m_socketGetDic];
            }
            else if (myRow == 7) {
                [hubConfigApi setHubSocketInfo:m_socketSetDic];
            }
            else if (myRow == 8) {
                [hubConfigApi getHubWifiMode];
            }
            else if (myRow == 9) {
                [hubConfigApi setHubWifiMode:m_staNumber];
            }
            else if (myRow == 10) {
                [hubConfigApi getHubIpKey];
            }
            else if (myRow == 11) {
                [hubConfigApi restartHub];
            }
            else if (myRow == 12) {
                [hubConfigApi resetHub];
            }
            else if (myRow == 13) {
                [hubConfigApi getHubWifiStatus];
            }
            else if (myRow == 14) {
                [hubConfigApi readDevicePower];
            }
            else if (myRow == 15) {
                [hubConfigApi readFirmwareVersion];
            }
            else if (myRow == 16) {
                [hubConfigApi readHardwareVersion];
            }
            else if (myRow == 17) {
                [hubConfigApi readSoftwareVersion];
            }
            else if (myRow == 18) {
                [hubConfigApi getHub4GAPN];
            }
            else if (myRow == 19) {
                [hubConfigApi setHub4GAPN:@"HELLO"];
            }
            else if (myRow == 20) {
                [hubConfigApi setHubDataType:0];
            }
            else if (myRow == 21) {
                [hubConfigApi setHubScanSwitch:1];
            }
            else if (myRow == 22) {
                NSMutableDictionary *scanDic = [[NSMutableDictionary alloc] init];
                [scanDic setObject:@"HW" forKey:@"scanName"];
                [scanDic setObject:@"FD0A" forKey:@"scanUuid"];
                [scanDic setObject:@"-90" forKey:@"scanRssi"];
                [hubConfigApi hubScanInfo:scanDic];
            }
            else if (myRow == 23) {
                [hubConfigApi hubSystenStatus];
            }
            else if (myRow == 24) {
                [hubConfigApi getHubNetWorkMode];
            }
            else if (myRow == 25) {
                [hubConfigApi getPrivateMacAddress];
            }
            else if (myRow == 26) {
                [hubConfigApi getPrivateVersion];
            }
            else if (myRow == 27) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter OTA Mode" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *downAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [hubConfigApi enterOTAMode];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:downAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if (myRow == 28) {
                [hubConfigApi getIPV4Info];
            }
            else if (myRow == 29) {
                NSMutableDictionary *infoMap = [[NSMutableDictionary alloc] init];
                [infoMap setObject:@"0" forKey:@"ipType"];
                [infoMap setObject:@"1" forKey:@"dnsType"];
                [infoMap setObject:@"192.168.0.1" forKey:@"ip"];
                [infoMap setObject:@"255.255.255.0" forKey:@"mask"];
                [infoMap setObject:@"192.168.0.1" forKey:@"gateway"];
                [infoMap setObject:@"192.168.0.6" forKey:@"dns"];
                [infoMap setObject:@"114.114.114.114" forKey:@"spareDns"];
                [hubConfigApi setIPV4Info:infoMap];
            }
            else if (myRow == 30) {
                NSMutableDictionary *infoMap = [[NSMutableDictionary alloc] init];
                [infoMap setObject:@"20" forKey:@"totalChannel"];
                [infoMap setObject:@"1" forKey:@"nowChannel"];
                [hubConfigApi setLoraChannel:infoMap];
            }
            else if (myRow == 31) {
                NSMutableDictionary *infoMap = [[NSMutableDictionary alloc] init];
                [infoMap setObject:@"1" forKey:@"channel"];
                [infoMap setObject:@"30" forKey:@"seconds"];
                [hubConfigApi diagnosisLoraChannel:infoMap];
            }
        }
    }
}


/********************************************************************************
 * 方法名称：textFieldShouldReturn
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == m_loginField) {
        m_loginPwString = textField.text;
    }
    else if (textField == m_setPwField) {
        m_setPwString = textField.text;
    }
    [m_cmdTableView reloadData];
    
    return YES;
}


/********************************************************************************
 * 方法名称：textFieldShouldReturn
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
