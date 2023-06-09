/********************************************************************************
 * 文件名称：ArmBandViewController.m
 * 内容摘要：臂带
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "ArmBandViewController.h"
#import "BindDeviceViewController.h"
#import "NewBandListViewController.h"
#import "HeartZoneView.h"

@interface ArmBandViewController ()<UITableViewDataSource, UITableViewDelegate, DeviceIdDelegate, FBKApiBsaeDataSource, FBKApiArmBandDelegate, HeartZoneDelegate> {
    UITableView    *m_cmdTableView;    // 命令列表
    NSMutableArray *m_cmdArray;        // 命令列表数据
    UILabel        *m_alertLab;        // 连接状态
    UILabel        *m_maxOxygen;       // 最大耗氧量
    UILabel        *m_heartRateLab;    // 实时心率展示
    UILabel        *m_frequencyLab;    // 实时步频展示
    UILabel        *m_spo2Lab;         // 实时血氧展示
    UILabel        *m_ecgLab;          // ECG
    UITextView     *m_content;         // 获取到的数据展示
    UITableView    *m_deviceTableView; // 设备列表
    NSMutableArray *m_deviceList;      // 设备列表数据
    int            m_maxNumber;        // 选择的设备数（不超过7个）
    int            m_chooseNumber;     // 选择设备展示的数据
    BOOL           m_isSwitchOn;
    NSMutableArray *m_colorArray;      // 颜色数据
    NSMutableArray *m_heartZoneArray;  // 区间
    HeartZoneView  *m_heartZoneView;
}

@end

@implementation ArmBandViewController

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_isSwitchOn = NO;
    m_maxNumber = 0;
    m_chooseNumber = 0;
    m_deviceList = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        FBKApiArmBand *armBandApi = [[FBKApiArmBand alloc] init];
        armBandApi.delegate = self;
        armBandApi.dataSource = self;
        
        DeviceClass *myBleDevice = [[DeviceClass alloc] init];
        myBleDevice.bleDevice = armBandApi;
        myBleDevice.deviceId = @"";
        myBleDevice.isAvailable = NO;
        myBleDevice.connectStatus = DeviceBleClosed;
        [m_deviceList addObject:myBleDevice];
    }
    
    m_cmdArray = [[NSMutableArray alloc] initWithObjects:
                  @"Synchronised time",
                  @"Get historical data",
                  @"Set Max Heart Rate",
                  @"Heart Rate Color",
                  @"Device power",
                  @"Device firmware version",
                  @"Device hardware version",
                  @"Device software version",
                  @"Get Age",
                  @"Set Age",
                  @"Set Shock",
                  @"Get Shock",
                  @"Close Clock",
                  @"Set Max HR interval",
                  @"Get Max HR interval",
                  @"Set light switch (on)",
                  @"Set light switch (off)",
                  @"Get light switch",
                  @"Get Device Setting",
                  @"Set color shock (on)",
                  @"Set color shock (off)",
                  @"Set color interval",
                  @"Clear Record",
                  @"Enter SPO2 Mode",
                  @"Exit SPO2 Mode",
                  @"Enter Temperature Mode",
                  @"Exit Temperature Mode",
                  @"Get Mac Address",
                  @"Get Total Version",
                  @"Get Device name",
                  @"Set HRV Time",
                  @"Enter HRV Mode",
                  @"Exit HRV Mode",
                  @"Set Data Frequency",
                  @"P_Mac Address",
                  @"P_Total Version",
                  @"Get Base Information",
                  @"P_Enter OTA Mode",
                  @"Set Private Ui Zone",
                  @"Open Setting Show",
                  @"Close Setting Show",
                  nil];
    
    m_heartZoneArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        FBKArmBandPrivate *myPara = [[FBKArmBandPrivate alloc] init];
        myPara.heartZone1 = 70;
        myPara.heartZone2 = 120;
        myPara.showTime = 10;
        [m_heartZoneArray addObject:myPara];
    }
    
    m_colorArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    
    [self loadHeadView];
    [self loadContentView];
    
    NSTimer *reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(getMaxOxygen)
                                                  userInfo:nil
                                                   repeats:YES];
    [reloadTimer fire];
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
    titleLab.text = @"ArmBand";
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

    float cmdTableHi = self.view.frame.size.height/2;
    if (cmdTableHi > 50 * m_cmdArray.count) {
        cmdTableHi = 50 * m_cmdArray.count;
    }
    
    m_cmdTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, cmdTableHi)];
    m_cmdTableView.delegate = self;
    m_cmdTableView.dataSource = self;
    m_cmdTableView.backgroundColor = [UIColor clearColor];
    m_cmdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_cmdTableView];
    
    m_frequencyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 130+cmdTableHi, self.view.frame.size.width, 40)];
    m_frequencyLab.backgroundColor = [UIColor blackColor];
    m_frequencyLab.text = @"steps: --   stepKcal: --";
    m_frequencyLab.textColor = [UIColor whiteColor];
    m_frequencyLab.textAlignment = NSTextAlignmentCenter;
    m_frequencyLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:m_frequencyLab];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [m_frequencyLab addSubview:lineView1];
    
    m_heartRateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 170+cmdTableHi, self.view.frame.size.width/2, 40)];
    m_heartRateLab.backgroundColor = [UIColor blackColor];
    m_heartRateLab.text = @"heart rate: --";
    m_heartRateLab.textColor = [UIColor whiteColor];
    m_heartRateLab.textAlignment = NSTextAlignmentCenter;
    m_heartRateLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:m_heartRateLab];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width/2, 1)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [m_heartRateLab addSubview:lineView2];
    
    m_maxOxygen = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 170+cmdTableHi, self.view.frame.size.width/2, 40)];
    m_maxOxygen.backgroundColor = [UIColor blackColor];
    m_maxOxygen.text = @"VO2MAX: --";
    m_maxOxygen.textColor = [UIColor whiteColor];
    m_maxOxygen.textAlignment = NSTextAlignmentCenter;
    m_maxOxygen.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:m_maxOxygen];
    
    UIView *lineView21 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width/2, 1)];
    lineView21.backgroundColor = [UIColor lightGrayColor];
    [m_maxOxygen addSubview:lineView21];
    
    m_spo2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 210+cmdTableHi, self.view.frame.size.width, 40)];
    m_spo2Lab.backgroundColor = [UIColor blackColor];
    m_spo2Lab.text = @"spo2: --";
    m_spo2Lab.textColor = [UIColor whiteColor];
    m_spo2Lab.textAlignment = NSTextAlignmentCenter;
    m_spo2Lab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:m_spo2Lab];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [m_spo2Lab addSubview:lineView3];
    
    m_ecgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 250+cmdTableHi, self.view.frame.size.width, 30)];
    m_ecgLab.backgroundColor = [UIColor blackColor];
    m_ecgLab.text = @"ECG: --";
    m_ecgLab.textColor = [UIColor whiteColor];
    m_ecgLab.textAlignment = NSTextAlignmentCenter;
    m_ecgLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:m_ecgLab];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, self.view.frame.size.width, 1)];
    lineView4.backgroundColor = [UIColor lightGrayColor];
    [m_ecgLab addSubview:lineView4];
    
    m_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 280+cmdTableHi, self.view.frame.size.width, self.view.frame.size.height-280-cmdTableHi)];
    m_content.backgroundColor = [UIColor blackColor];
    m_content.font = [UIFont systemFontOfSize:16];
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
    
    m_heartZoneView = [[HeartZoneView alloc] init];
    m_heartZoneView.frame = self.view.frame;
    m_heartZoneView.backgroundColor = [UIColor clearColor];
    m_heartZoneView.zoneArray = m_heartZoneArray;
    m_heartZoneView.alpha = 0;
    m_heartZoneView.delegate = self;
    [self.view addSubview:m_heartZoneView];
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
            FBKApiArmBand *armBandApi = myBleDevice.bleDevice;
            [armBandApi disconnectBleApi];
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
        bindView.scanDeviceType = BleDeviceArmBand;
        bindView.delegate = self;
        [self.navigationController pushViewController:bindView animated:YES];
    }
}


/********************************************************************************
* 方法名称：getMaxHeartUi
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)getMaxHeartUi:(BOOL)isSimple {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Max Heart Rate" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField = alertController.textFields.firstObject;
        NSString *maxString = inputField.text;
        [self setMaxHeart:maxString withStatus:isSimple];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


/********************************************************************************
 * 方法名称：setMaxHeart
 * 功能描述：设置最大心率
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setMaxHeart:(NSString *)maxHeart withStatus:(BOOL)isSimple {
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
    if (m_armBandApi.isConnected) {
        if (isSimple) {
            [m_armBandApi setMaxInterval:[maxHeart intValue]];
        }
        else {
            if (maxHeart.length == 0) {
                maxHeart = @"180";
            }
            [m_armBandApi setHeartRateMax:maxHeart];
        }
    }
}


/********************************************************************************
* 方法名称：setColorInterval
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setColorIntervalUI {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Color Interval" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField = alertController.textFields.firstObject;
        NSString *maxString = inputField.text;
        [self setColorInterval:maxString];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


/********************************************************************************
* 方法名称：setShockUI
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setShockUI:(int)tag {
    NSString *alertString = @"Set Shock Number";
    if (tag == 0) {
        alertString = @"Set Age";
    }
    else if (tag == 1) {
        alertString = @"Set Shock Number";
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField = alertController.textFields.firstObject;
        NSString *maxString = inputField.text;
        
        if (tag == 0) {
            DeviceClass *myBleDevice = [self->m_deviceList objectAtIndex:self->m_chooseNumber];
            FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
            if (m_armBandApi.isConnected) {
                [m_armBandApi setDeviceAge:[maxString intValue]];
            }
        }
        else if (tag == 1) {
            [self setShockNumber:maxString];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


/********************************************************************************
 * 方法名称：setMaxHeart
 * 功能描述：设置最大心率
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setShockNumber:(NSString *)shockNo {
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
    if (m_armBandApi.isConnected) {
        [m_armBandApi setShock:[shockNo intValue]];
    }
}


/********************************************************************************
 * 方法名称：setColorInterval
 * 功能描述：设置最大心率
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setColorInterval:(NSString *)colorInterval {
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
    if (m_armBandApi.isConnected) {
        [m_armBandApi setColorInterval:[colorInterval intValue]];
    }
}


/********************************************************************************
 * 方法名称：enterHRV
 * 功能描述：进入HRV模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterHRV {
    m_isSwitchOn = !m_isSwitchOn;
    [m_cmdTableView reloadData];
    
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
    if (m_armBandApi.isConnected) {
        [m_armBandApi enterHRVMode:m_isSwitchOn isSendCmd:true];
    }
}


/********************************************************************************
* 方法名称：setHrColor
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setHrColor:(UIButton *)sender {
    int row = (int)sender.tag - 200;
    int number = [[m_colorArray objectAtIndex:row] intValue];
    number = number + 1;
    if (number == 6) {
        number = 0;
    }
    
    NSString *numString = [NSString stringWithFormat:@"%i",number];
    [m_colorArray replaceObjectAtIndex:row withObject:numString];
    [m_cmdTableView reloadData];
}


/********************************************************************************
* 方法名称：setFrequencyUI
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setFrequencyUI {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Data Frequency" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *inputField = alertController.textFields.firstObject;
        NSString *maxString = inputField.text;
        [self setAccNumber:maxString];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


/********************************************************************************
 * 方法名称：setAccNumber
 * 功能描述：setAccNumber
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setAccNumber:(NSString *)shockNo {
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
    if (m_armBandApi.isConnected) {
        [m_armBandApi setDataFrequency:[shockNo intValue]];
    }
}


/********************************************************************************
 * 方法名称：setZoneInfo
 * 功能描述：setZoneInfo
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setZoneInfo {
    m_heartZoneView.zoneArray = m_heartZoneArray;
    [m_heartZoneView setNeedsDisplay];
    [UIView animateWithDuration:0.5 animations:^{
        self->m_heartZoneView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}


/********************************************************************************
 * 方法名称：getMaxOxygen
 * 功能描述：getMaxOxygen
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getMaxOxygen {
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
    if (m_armBandApi.isConnected && m_armBandApi.isHaveMaxOxygen) {
        [m_armBandApi readMaxOxygen];
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
            FBKApiArmBand *armBandApi = myBleDevice.bleDevice;
            [armBandApi startConnectBleApi:myBleDevice.deviceId andIdType:DeviceIdUUID];
            NSLog(@"myBleDevice.deviceId %@",myBleDevice.deviceId);
        }
    }
    [m_deviceTableView reloadData];
}



/********************************************************************************
 * 方法名称：heartZoneData
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)heartZoneData:(NSMutableArray *)paraArray {
    [m_heartZoneArray removeAllObjects];
    [m_heartZoneArray addObjectsFromArray:paraArray];
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice
{
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    for (int i = 0; i < m_deviceList.count; i++) {
        DeviceClass *myBleDevice = [m_deviceList objectAtIndex:i];
        FBKApiArmBand *listApi = myBleDevice.bleDevice;
        if (armBandApi == listApi) {
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
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (chooseApi == armBandApi) {
        m_alertLab.text = [ShowTools showDeviceStatus:status];
        if (!armBandApi.isConnected) {
            m_frequencyLab.text = @"steps: --   stepKcal: --";
            m_heartRateLab.text = @"heart rate: --";
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
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nError: %@",armBandApi.deviceId,error];
    }
}


/********************************************************************************
 * 方法名称：bleConnectLog
 * 功能描述：蓝牙连接LOG
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectLog:(NSString *)logString andDevice:(id)bleDevice {
    NSLog(@"logString --- %@",logString);
}


/********************************************************************************
 * 方法名称：devicePower
 * 功能描述：电量
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        NSString *bai = @"%";
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nPower: %@%@",armBandApi.deviceId,power,bai];
    }
}


/********************************************************************************
 * 方法名称：deviceFirmware
 * 功能描述：固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nFirmware version: %@",armBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceHardware
 * 功能描述：硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nHardware version: %@",armBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：deviceSoftware
 * 功能描述：软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nSoftware version: %@",armBandApi.deviceId,version];
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


// 获取SystemID
- (void)deviceSystemData:(NSData *)systemData andDevice:(id)bleDevice {
}

// 获取Model String
- (void)deviceModelString:(NSString *)modelString andDevice:(id)bleDevice {
}

// 获取序列号
- (void)deviceSerialNumber:(NSString *)serialNumber andDevice:(id)bleDevice{
}

// 获取制造商信息
- (void)deviceManufacturerName:(NSString *)manufacturerName andDevice:(id)bleDevice{
}

- (void)maxOxyResult:(int)maxOxygen andDevice:(id)bleDevice {
    m_maxOxygen.text = [NSString stringWithFormat:@"VO2MAX: %i",maxOxygen];
}

- (void)deviceBaseInfo:(FBKApiBaseInfo *)baseInfo andDevice:(id)bleDevice{
    NSMutableString *showString = [[NSMutableString alloc] initWithString:@"deviceBaseInfo\n"];
    [showString appendFormat:@"battery: %i\n",baseInfo.battery];
    [showString appendFormat:@"firmVersion: %@\n",baseInfo.firmVersion];
    [showString appendFormat:@"hardVersion: %@\n",baseInfo.hardVersion];
    [showString appendFormat:@"softVersion: %@\n",baseInfo.softVersion];
    [showString appendFormat:@"systemId: %@\n",baseInfo.systemId];
    [showString appendFormat:@"modelString: %@\n",baseInfo.modelString];
    [showString appendFormat:@"serialNumber: %@\n",baseInfo.serialNumber];
    [showString appendFormat:@"manufacturerName: %@\n",baseInfo.manufacturerName];
    [showString appendFormat:@"customerName: %@\n",baseInfo.customerName];
    [showString appendFormat:@"macAddress: %@\n",baseInfo.deviceMac];
    [showString appendFormat:@"OTAMac: %@\n",baseInfo.dfuMac];
    m_content.text = showString;
}

/********************************************************************************
 * 方法名称：armBandVersion
 * 功能描述：协议版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)armBandVersion:(NSString *)version andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Device ID: %@\nProtocol version: %@",armBandApi.deviceId,version];
    }
}


/********************************************************************************
 * 方法名称：armBandRealTimeHeartRate
 * 功能描述：实时心率
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)armBandRealTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_heartRateLab.text = [NSString stringWithFormat:@"heart rate: %@",[HRInfo objectForKey:@"heartRate"]];
    }
}


/********************************************************************************
 * 方法名称：armBandRealTimeECG
 * 功能描述：实时ECG
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)armBandRealTimeECG:(NSArray *)ECGArray andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        NSMutableString *ecgString = [[NSMutableString alloc] initWithString:@"ECG:"];
        for (int i = 0; i < ECGArray.count; i++) {
            [ecgString appendString:[ECGArray objectAtIndex:i]];
            if (i != ECGArray.count-1) {
                [ecgString appendString:@","];
            }
        }
        m_ecgLab.text = ecgString;
    }
}


/********************************************************************************
 * 方法名称：armBandStepFrequency
 * 功能描述：实时步频
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)armBandStepFrequency:(NSDictionary *)frequencyDic andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_frequencyLab.text = [NSString stringWithFormat:@"steps: %@  frequency: %@",[frequencyDic objectForKey:@"stepNum"],[frequencyDic objectForKey:@"stepFrequency"]];
    }
}


/********************************************************************************
 * 方法名称：armBandDetailData
 * 功能描述：大数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)armBandDetailData:(NSDictionary *)dataDic andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithDictionary:dataDic];
        if (dataDic.allKeys.count > 0) {
            FBKHRRecordAnaly *myHrAnaly = [[FBKHRRecordAnaly alloc] init];
            [myHrAnaly analyRecordList:dataDictionary isNew:true];
            NewBandListViewController *listView = [[NewBandListViewController alloc] init];
            listView.dataDic = dataDictionary;
            [self.navigationController pushViewController:listView animated:YES];
        }
    }
}


// 实时温度
- (void)armBandTemperature:(NSDictionary *)temMap andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"armBandTemperature ---------- %@",temMap];
    }
}


// 实时血氧
- (void)armBandSPO2:(NSDictionary *)spo2Map andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_spo2Lab.text = [NSString stringWithFormat:@"spo2:%@ --- move:%@ --- status:%@",[spo2Map objectForKey:@"spo2"],[spo2Map objectForKey:@"isMoving"],[spo2Map objectForKey:@"status"]];
        NSLog(@"%@", m_spo2Lab.text);
    }
}


- (void)getAgeNumber:(int)age andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"getAgeNumber:%i",age];
    }
}


- (void)setAgeStatus:(BOOL)status andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Set Age succeed!"];
    }
}


- (void)setShockStatus:(BOOL)status andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Set Shock succeed!"];
    }
}

- (void)getShockStatus:(NSDictionary *)dataMap andDevice:(id)bleDevice{
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Get Shock:%@-%@",[dataMap objectForKey:@"switchMark"],[dataMap objectForKey:@"shockNumber"]];
    }
}

- (void)closeShockStatus:(BOOL)status andDevice:(id)bleDevice{
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Close Shock succeed!"];
    }
}

- (void)setMaxIntervalStatus:(BOOL)status andDevice:(id)bleDevice{
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Set Max Interval succeed!"];
    }
}

- (void)getMaxInterval:(int)maxHr andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"getMaxInterval:%i",maxHr];
    }
}

- (void)setLightSwitchStatus:(BOOL)status andDevice:(id)bleDevice{
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Set Light Switch succeed!"];
    }
}


- (void)getLightSwitch:(int)lightSwitch andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"getLightSwitch:%i",lightSwitch];
    }
}


- (void)getSettting:(NSDictionary *)dataMap andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"getSettting:%@",dataMap];
    }
}


- (void)invalidCmd:(ArmBandInvalidCmd)cmdId andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"invalid command:%i",cmdId];
    }
}


- (void)setColorShockStatus:(BOOL)status andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Set Color Shock succeed!"];
    }
}

- (void)setColorIntervalStatus:(BOOL)status andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"Set Color Interval succeed!"];
    }
}

- (void)clearRecordStatus:(BOOL)status andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"clear Record succeed!"];
    }
}


- (void)deviceMacAddress:(NSDictionary *)macMap andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"%@",macMap];
    }
}

- (void)totalVersion:(NSDictionary *)versionMap andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"%@",versionMap];
    }
}


- (void)HRVResultData:(NSDictionary *)hrvMap andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[NSString stringWithFormat:@"%@",hrvMap]
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil, nil];
    [myAlert show];
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"%@",hrvMap];
    }
}


- (void)ABHrvResultData:(BOOL)status withData:(NSDictionary *)hrvMap andDevice:(id)bleDevice {
    NSLog(@"ABHrvResultData --- %i --- %@",status,hrvMap);
}


- (void)accelerationData:(NSArray *)accArray andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        FBKParaAcceleration *accelerationData = [accArray objectAtIndex:accArray.count-1];
        m_content.text = [NSString stringWithFormat:@" Time:%i ms\n X:%i\n Y:%i\n Z:%i",accelerationData.timeStamp,accelerationData.xAxis,accelerationData.yAxis,accelerationData.zAxis];
    }
}


- (void)setPrivateFiveZone:(BOOL)status andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"setPrivateFiveZone:%@",status?@"Succeed":@"Failed"];
    }
}

- (void)openSettingShow:(BOOL)status andDevice:(id)bleDevice {
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"openSettingShow:%@",status?@"Succeed":@"Failed"];
    }
}

- (void)closeSettingShow:(BOOL)status andDevice:(id)bleDevice{
    FBKApiArmBand *armBandApi = (FBKApiArmBand *)bleDevice;
    DeviceClass *myBleDevice = [m_deviceList objectAtIndex:m_chooseNumber];
    FBKApiArmBand *chooseApi = (FBKApiArmBand *)myBleDevice.bleDevice;
    if (armBandApi == chooseApi) {
        m_content.text = [NSString stringWithFormat:@"closeSettingShow:%@",status?@"Succeed":@"Failed"];
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
    
    if (indexPath.row == 3) {
        for (int i = 0; i < 5; i++) {
            UIButton *colorButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200+40*i, 0, 40, 50)];
            colorButton.tag = 200+i;
            colorButton.backgroundColor = [UIColor clearColor];
            [colorButton setTitle:[m_colorArray objectAtIndex:i] forState:UIControlStateNormal];
            [colorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [colorButton addTarget:self action:@selector(setHrColor:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:colorButton];
        }
    }
    else if (indexPath.row == 38) {
        UIButton *zoneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100.0, 5, 80, 40)];
        zoneButton.backgroundColor = [UIColor blackColor];
        [zoneButton setTitle:@"设置" forState:UIControlStateNormal];
        [zoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zoneButton addTarget:self action:@selector(setZoneInfo) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:zoneButton];
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
    FBKApiArmBand *m_armBandApi = myBleDevice.bleDevice;
    if (m_armBandApi.isConnected) {
        if (myRow == 0) {
            [m_armBandApi setArmBandTime];
        }
        else if (myRow == 1) {
            [m_armBandApi getArmBandTotalHistory];
        }
        else if (myRow == 2) {
            [self getMaxHeartUi:false];
        }
        else if (myRow == 3) {
            FBKDeviceHRColor *setColor = [[FBKDeviceHRColor alloc] init];
            setColor.ColorOne   = [m_colorArray objectAtIndex:0];
            setColor.ColorTwo   = [m_colorArray objectAtIndex:1];
            setColor.ColorThree = [m_colorArray objectAtIndex:2];
            setColor.ColorFour  = [m_colorArray objectAtIndex:3];
            setColor.ColorFive  = [m_colorArray objectAtIndex:4];
            [m_armBandApi setHeartRateColor:setColor];
        }
        else if (myRow == 4) {
            [m_armBandApi readDevicePower];
        }
        else if (myRow == 5) {
            [m_armBandApi readFirmwareVersion];
        }
        else if (myRow == 6) {
            [m_armBandApi readHardwareVersion];
        }
        else if (myRow == 7) {
            [m_armBandApi readSoftwareVersion];
        }
        else if (myRow == 8) {
            [m_armBandApi getDeviceAge];
        }
        else if (myRow == 9) {
            [self setShockUI:0];
        }
        else if (myRow == 10) {
            [self setShockUI:1];
        }
        else if (myRow == 11) {
            [m_armBandApi getShock];
        }
        else if (myRow == 12) {
            [m_armBandApi closeShock];
        }
        else if (myRow == 13) {
            [self getMaxHeartUi:true];
        }
        else if (myRow == 14) {
            [m_armBandApi getMaxInterval];
        }
        else if (myRow == 15) {
            [m_armBandApi setLightSwitch:YES];
        }
        else if (myRow == 16) {
            [m_armBandApi setLightSwitch:NO];
        }
        else if (myRow == 17) {
            [m_armBandApi getLightSwitch];
        }
        else if (myRow == 18) {
            [m_armBandApi getDeviceSetting];
        }
        else if (myRow == 19) {
            [m_armBandApi setColorShock:YES];
        }
        else if (myRow == 20) {
            [m_armBandApi setColorShock:NO];
        }
        else if (myRow == 21) {
            [self setColorIntervalUI];
        }
        else if (myRow == 22) {
            [m_armBandApi clearRecord];
        }
        else if (myRow == 23) {
            [m_armBandApi enterSPO2Mode:YES];
            m_spo2Lab.text = @"spo2: --";
        }
        else if (myRow == 24) {
            [m_armBandApi enterSPO2Mode:NO];
        }
        else if (myRow == 25) {
            [m_armBandApi enterTemperatureMode:YES];
        }
        else if (myRow == 26) {
            [m_armBandApi enterTemperatureMode:NO];
        }
        else if (myRow == 27) {
            [m_armBandApi getDeviceMacAddress];
        }
        else if (myRow == 28) {
            [m_armBandApi getDeviceVersion];
        }
        else if (myRow == 29) {
            NSString *nameString = [NSString stringWithFormat:@"Get Device name [%@]",m_armBandApi.readDeviceName];
            [m_cmdArray replaceObjectAtIndex:myRow withObject:nameString];
            [m_cmdTableView  reloadData];
        }
        else if (myRow == 30) {
            [m_armBandApi setHrvTime:120];
        }
        else if (myRow == 31) {
            [m_armBandApi enterHRVMode:true isSendCmd:true];
        }
        else if (myRow == 32) {
            [m_armBandApi enterHRVMode:false isSendCmd:true];
        }
        else if (myRow == 33) {
            [self setFrequencyUI];
        }
        else if (myRow == 34) {
            [m_armBandApi getPrivateMacAddress];
        }
        else if (myRow == 35) {
            [m_armBandApi getPrivateVersion];
        }
        else if (myRow == 36) {
            [m_armBandApi getDeviceBaseInfo];
        }
        else if (myRow == 37) {
            [m_armBandApi enterOTAMode];
        }
        else if (myRow == 38) {
            [m_armBandApi setPrivateFiveZone:m_heartZoneArray];
        }
        else if (myRow == 39) {
            [m_armBandApi openSettingShow];
        }
        else if (myRow == 40) {
            [m_armBandApi closeSettingShow];
        }
    }
}


@end
