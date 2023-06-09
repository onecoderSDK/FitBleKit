/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FileEditViewController.m
* Function : File Edit
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.03.11
******************************************************************************************/

#import "FileEditViewController.h"
#import "ChooseTabView.h"
#import "PYToolUIAdapt.h"

@interface FileEditViewController () <UITextFieldDelegate, ChooseTabViewDelegate> {
    UIScrollView  *m_fileScroll;
    UITextField   *m_lowAxisField;
    UITextField   *m_hiAxisField;
    ChooseTabView *m_axisTypeTab;
    ChooseTabView *m_saveTab;
    FBKBoxingSet  *m_boxSet;
}

@end

@implementation FileEditViewController

#pragma mark - ******************************* System *************************************
/*-****************************************************************************************
 * Method: viewDidLoad
 * Description: View start here
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];

    m_boxSet = [[FBKBoxingSet alloc] init];
    [self loadHeaderView];
    [self loadContentView];
}


#pragma mark - ******************************* Load View **********************************
/*-****************************************************************************************
 * Method: loadHeaderView
 * Description: load Header View
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)loadHeaderView {
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerBackView];
    
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    powerView.backgroundColor = [UIColor clearColor];
    [headerBackView addSubview:powerView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = @"Boxing";
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
}


/*-****************************************************************************************
* Method: loadContentView
* Description: load Content View
* Parameter:
* Return Data:
******************************************************************************************/
- (void)loadContentView {
    m_fileScroll = [[UIScrollView alloc] init];
    m_fileScroll.frame = CGRectMake(0.0, 80.0, self.view.frame.size.width, self.view.frame.size.height-80.0);
    m_fileScroll.backgroundColor = [UIColor clearColor];
    m_fileScroll.contentSize = CGSizeMake(0.0, 0.0);
    [self.view addSubview:m_fileScroll];
    
    UIButton *keyButton = [[UIButton alloc] init];
    keyButton.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-80.0);
    keyButton.backgroundColor = [UIColor clearColor];
    [keyButton addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [m_fileScroll addSubview:keyButton];
    
    float scrollHi = 10.0;
    UILabel *lowAxisLab = [[UILabel alloc] init];
    lowAxisLab.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20.0, scrollHi, PY_BASE_WEIGHT-40, 20.0)];
    lowAxisLab.backgroundColor = [UIColor clearColor];
    lowAxisLab.text = @"low Axis";
    lowAxisLab.font = [UIFont systemFontOfSize:12];
    lowAxisLab.textColor = [UIColor blackColor];
    lowAxisLab.textAlignment = NSTextAlignmentLeft;
    [m_fileScroll addSubview:lowAxisLab];
    
    UIView *lowAxisView = [[UIView alloc] init];
    lowAxisView.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20.0, scrollHi+20.0, PY_BASE_WEIGHT-40, 40.0)];
    lowAxisView.backgroundColor = [UIColor clearColor];
    [[PYToolUIAdapt selfAlloc] setViewBorderWith:lowAxisView cornerRadius:0 borderColor:[UIColor blackColor] borderWidth:1];
    [m_fileScroll addSubview:lowAxisView];
    
    m_lowAxisField = [[UITextField alloc] init];
    m_lowAxisField.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(28.0, scrollHi+20.0, PY_BASE_WEIGHT-56, 40.0)];
    m_lowAxisField.backgroundColor = [UIColor clearColor];
    m_lowAxisField.returnKeyType = UIReturnKeyDefault;
    m_lowAxisField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_lowAxisField.textAlignment = NSTextAlignmentLeft;
    m_lowAxisField.tintColor = [UIColor blackColor];
    m_lowAxisField.font = [UIFont systemFontOfSize:16];
    m_lowAxisField.textColor = [UIColor blackColor];
    m_lowAxisField.text = @"-1";
    m_lowAxisField.delegate = self;
    [m_fileScroll addSubview:m_lowAxisField];
    
    UILabel *hiAxisLab = [[UILabel alloc] init];
    hiAxisLab.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20.0, scrollHi+75.0, PY_BASE_WEIGHT-40, 20.0)];
    hiAxisLab.backgroundColor = [UIColor clearColor];
    hiAxisLab.text = @"hight Axis";
    hiAxisLab.font = [UIFont systemFontOfSize:12];
    hiAxisLab.textColor = [UIColor blackColor];
    hiAxisLab.textAlignment = NSTextAlignmentLeft;
    [m_fileScroll addSubview:hiAxisLab];
    
    UIView *hiAxisView = [[UIView alloc] init];
    hiAxisView.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20.0, scrollHi+100.0, PY_BASE_WEIGHT-40, 40.0)];
    hiAxisView.backgroundColor = [UIColor clearColor];
    [[PYToolUIAdapt selfAlloc] setViewBorderWith:hiAxisView cornerRadius:0 borderColor:[UIColor blackColor] borderWidth:1];
    [m_fileScroll addSubview:hiAxisView];
    
    m_hiAxisField = [[UITextField alloc] init];
    m_hiAxisField.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(28.0, scrollHi+100.0, PY_BASE_WEIGHT-40, 40.0)];
    m_hiAxisField.backgroundColor = [UIColor clearColor];
    m_hiAxisField.returnKeyType = UIReturnKeyDefault;
    m_hiAxisField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_hiAxisField.textAlignment = NSTextAlignmentLeft;
    m_hiAxisField.tintColor = [UIColor blackColor];
    m_hiAxisField.font = [UIFont systemFontOfSize:16];
    m_hiAxisField.textColor = [UIColor blackColor];
    m_hiAxisField.text = @"1";
    m_hiAxisField.delegate = self;
    [m_fileScroll addSubview:m_hiAxisField];

    UILabel *axisTypeLab = [[UILabel alloc] init];
    axisTypeLab.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20, scrollHi+155.0, PY_BASE_WEIGHT-40, 20.0)];
    axisTypeLab.backgroundColor = [UIColor clearColor];
    axisTypeLab.text = @"Axis Type";
    axisTypeLab.font = [UIFont systemFontOfSize:12];
    axisTypeLab.textColor = [UIColor blackColor];
    axisTypeLab.textAlignment = NSTextAlignmentLeft;
    [m_fileScroll addSubview:axisTypeLab];
    
    NSArray *axisTypeArray = [[NSArray alloc] initWithObjects:@"AX", @"AY", @"AZ", @"GX", @"GY", @"GZ", nil];
    m_axisTypeTab = [[ChooseTabView alloc] init];
    m_axisTypeTab.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20.0, scrollHi+180.0, PY_BASE_WEIGHT-40, 40.0)];
    m_axisTypeTab.dataArray = axisTypeArray;
    m_axisTypeTab.chooseNo = 0;
    m_axisTypeTab.delegate = self;
    [m_fileScroll addSubview:m_axisTypeTab];
    
    UILabel *saveLab = [[UILabel alloc] init];
    saveLab.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20, scrollHi+235.0, PY_BASE_WEIGHT-40, 20.0)];
    saveLab.backgroundColor = [UIColor clearColor];
    saveLab.text = @"区间是否保留";
    saveLab.font = [UIFont systemFontOfSize:12];
    saveLab.textColor = [UIColor blackColor];
    saveLab.textAlignment = NSTextAlignmentLeft;
    [m_fileScroll addSubview:saveLab];
    
    NSArray *saveArray = [[NSArray alloc] initWithObjects:@"过滤", @"保留", nil];
    m_saveTab = [[ChooseTabView alloc] init];
    m_saveTab.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20.0, scrollHi+260.0, PY_BASE_WEIGHT-40, 40.0)];
    m_saveTab.dataArray = saveArray;
    m_saveTab.chooseNo = 1;
    m_saveTab.delegate = self;
    [m_fileScroll addSubview:m_saveTab];

    UIButton *saveButton = [[UIButton alloc] initWithFrame:[[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(20.0, scrollHi+330.0, PY_BASE_WEIGHT-40, 50)]];
    [[PYToolUIAdapt selfAlloc] setViewBorderWith:saveButton cornerRadius:8 borderColor:[UIColor clearColor] borderWidth:0];
    saveButton.backgroundColor = [UIColor blackColor];
    [saveButton setTitle:@"Send" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton addTarget:self action:@selector(saveByte) forControlEvents:UIControlEventTouchUpInside];
    [m_fileScroll addSubview:saveButton];
    
    m_boxSet.axisType = 0;
    m_boxSet.isReserve = true;
    m_boxSet.lowZone = -1;
    m_boxSet.hightZone = 1;
}


#pragma mark - ******************************* Action *************************************
#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


/*-****************************************************************************************
 * Method: rightAction
 * Description: Right Button Action
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)saveByte {
    if (m_lowAxisField.text.length > 0) {
        m_boxSet.lowZone = [m_lowAxisField.text intValue];
    }
    
    if (m_hiAxisField.text.length > 0) {
        m_boxSet.hightZone = [m_hiAxisField.text intValue];
    }
    
    [self.delegate postAxisData:m_boxSet];
    [self backAction];
}


/*-****************************************************************************************
 * Method: hiddenKeyboard
 * Description: hidden Key board
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)hiddenKeyboard {
    [m_lowAxisField resignFirstResponder];
    [m_hiAxisField resignFirstResponder];
}


#pragma mark - ******************************* Delegate ***********************************
/*-****************************************************************************************
 * Method: textFieldShouldReturn
 * Description: text Field Should Return
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


/*-****************************************************************************************
 * Method: chooseTabIndex
 * Description: chooseTabIndex
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)chooseTabIndex:(int)index withView:(id)view {
    [self hiddenKeyboard];
    if (view == m_axisTypeTab) {
        m_boxSet.axisType = index;
    }
    else if (view == m_saveTab) {
        if (index == 0) {
            m_boxSet.isReserve = false;
        }
        else {
            m_boxSet.isReserve = true;
        }
    }
}


@end
