/*-****************************************************************************************
* Copyright: Technology Co., Ltd
* File Name: PPGDFUViewController.m
* Function : PPG View
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.07.12
 ******************************************************************************************/

#import "PPGDFUViewController.h"
#import "BindDeviceViewController.h"
#import "PPGFileViewController.h"

@interface PPGDFUViewController () <DeviceIdDelegate, FBKApiPPGDFUDelegate, FileViewDelegate> {
    UILabel        *m_alertLab;         // 连接状态
    UILabel        *m_content;          // 获取到的数据展示
    UIButton       *m_fileBtn;
    UIButton       *m_startBtn;
    NSString       *m_uuidString;
    NSString       *m_pathString;
    FBKApiPPGDFU   *m_ppgDfuApi;
}

@end

@implementation PPGDFUViewController

#pragma mark - ****************************** Syetems *************************************
/*-****************************************************************************************
* Method: viewDidLoad
* Description: start here
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_pathString = [[NSString alloc] init];
    m_uuidString = [[NSString alloc] init];
    m_ppgDfuApi = [[FBKApiPPGDFU alloc] init];
    m_ppgDfuApi.delegate = self;
    
    [self loadHeadView];
    [self loadContentView];
}


/*-****************************************************************************************
* Method: didReceiveMemoryWarning
* Description: didReceiveMemoryWarning
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - ****************************** Load View ***********************************
/*-****************************************************************************************
* Method: loadHeadView
* Description: loadHeadView
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)loadHeadView {
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerBackView];
    
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    powerView.backgroundColor = [UIColor clearColor];
    [headerBackView addSubview:powerView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = @"PPG DFU";
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
}


/*-****************************************************************************************
* Method: loadContentView
* Description: loadContentView
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)loadContentView {
    m_alertLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 30)];
    m_alertLab.backgroundColor = [UIColor clearColor];
    m_alertLab.text = @"No device";
    m_alertLab.textColor = [UIColor redColor];
    m_alertLab.textAlignment = NSTextAlignmentCenter;
    m_alertLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:m_alertLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [m_alertLab addSubview:lineView];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-32, 100+17, 16, 16)];
    nextImg.backgroundColor = [UIColor clearColor];
    nextImg.image = [UIImage imageNamed:@"img_app_next.png"];
    [self.view addSubview:nextImg];
    
    m_fileBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    m_fileBtn.backgroundColor = [UIColor clearColor];
    [m_fileBtn setTitle:@"Choose DFU File" forState:UIControlStateNormal];
    m_fileBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [m_fileBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_fileBtn addTarget:self action:@selector(chooseOTAFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_fileBtn];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [m_fileBtn addSubview:lineView1];
    
    m_content = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, self.view.frame.size.width-20.0, 300.0)];
    m_content.backgroundColor = [ShowTools hexColor:@"FFEEEEEE"];
    m_content.textAlignment = NSTextAlignmentCenter;
    m_content.font = [UIFont systemFontOfSize:40];
    m_content.text = @"";
    m_content.textColor = [UIColor blackColor];
    m_content.numberOfLines = 2;
    [self.view addSubview:m_content];
    
    m_startBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-120)/2, self.view.frame.size.height-150.0, 120, 120)];
    m_startBtn.backgroundColor = [UIColor lightGrayColor];
    [m_startBtn setTitle:@"Start" forState:UIControlStateNormal];
    m_startBtn.titleLabel.font = [UIFont systemFontOfSize:28];
    m_startBtn.layer.masksToBounds = YES;
    m_startBtn.layer.cornerRadius = 60;
    [m_startBtn addTarget:self action:@selector(startDFU) forControlEvents:UIControlEventTouchUpInside];
    m_startBtn.enabled = false;
    [self.view addSubview:m_startBtn];
}


#pragma mark - ****************************** Action **************************************
/*-****************************************************************************************
* Method: backAction
* Description: backAction
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


/*-****************************************************************************************
* Method: chooseDevice
* Description: chooseDevice
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)chooseDevice {
    BindDeviceViewController *bindView = [[BindDeviceViewController alloc] init];
    bindView.scanDeviceType = BleDeviceRunning;
    bindView.delegate = self;
    [self.navigationController pushViewController:bindView animated:YES];
}


/*-****************************************************************************************
* Method: chooseDevice
* Description: chooseDevice
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)chooseOTAFile {
    PPGFileViewController *fileView = [[PPGFileViewController alloc] init];
    fileView.delegate = self;
    [self.navigationController pushViewController:fileView animated:YES];
}


/*-****************************************************************************************
* Method: startDFU
* Description: startDFU
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)startDFU {
    if (m_pathString.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please choose DFU file" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:true completion:nil];
        return;
    }
    
    [m_ppgDfuApi startPPGOTAForPath:m_pathString];
    m_content.text = @"升级中...";
    
    m_startBtn.backgroundColor = [UIColor lightGrayColor];
    m_startBtn.enabled = false;
}


#pragma mark - ****************************** Delegate ************************************
/*-****************************************************************************************
* Method: getDeviceId
* Description: getDeviceId
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)getDeviceId:(NSArray *)deviceIdArray {
    if (deviceIdArray.count == 1) {
        m_uuidString = [[deviceIdArray objectAtIndex:0] objectForKey:@"deviceId"];
        [m_ppgDfuApi startConnectBleApi:m_uuidString andIdType:DeviceIdUUID];
    }
}


/*-****************************************************************************************
* Method: postFile
* Description: postFile
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)postFile:(NSString *)fileName {
    m_pathString = [self fileInDocuments:fileName];
    [m_fileBtn setTitle:fileName forState:UIControlStateNormal];
}


/*-****************************************************************************************
* Method: postFile
* Description: postFile
* Parameter:
* Return Data:
 ******************************************************************************************/
- (NSString *)fileInDocuments:(NSString *)fileName {
    if (![fileName isMemberOfClass:[NSNull class]] && fileName != nil ) {
        if (fileName.length != 0) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            return [documentsDirectory stringByAppendingPathComponent:fileName];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}


/*-****************************************************************************************
* Method: bleConnectStatus
* Description: bleConnectStatus
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    m_alertLab.text = [ShowTools showDeviceStatus:status];
    
    if (status == DeviceBleClosed) {
        m_startBtn.backgroundColor = [UIColor lightGrayColor];
        m_startBtn.enabled = false;
    }
    else if (status == DeviceBleIsOpen) {
        if (m_uuidString.length > 0) {
            [m_ppgDfuApi startConnectBleApi:m_uuidString andIdType:DeviceIdUUID];
        }
    }
    else if (status == DeviceBleConnected) {
        m_startBtn.backgroundColor = [UIColor blackColor];
        m_startBtn.enabled = true;
    }
}


/*-****************************************************************************************
* Method: bleConnectError
* Description: bleConnectError
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)bleConnectError:(id)error andDevice:(id)bleDevice {
    
}


/*-****************************************************************************************
* Method: ppgDfuProgress
* Description: ppgDfuProgress
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)ppgDfuProgress:(int)progress andDevice:(id)bleDevice {
    NSString *unitString = @"%";
    m_content.text = [NSString stringWithFormat:@"%i%@",progress,unitString];
}


/*-****************************************************************************************
* Method: ppgDfuResult
* Description: ppgDfuResult
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)ppgDfuResult:(BOOL)status andDevice:(id)bleDevice {
    if (status) {
        m_content.text = @"升级成功";
    }
    else {
        m_content.text = @"升级失败";
    }
}


@end
