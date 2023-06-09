/*-****************************************************************************************
* Copyright: Technology Co., Ltd
* File Name: PPGFileViewController.h
* Function : PPG DFU File
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.07.12
 ******************************************************************************************/

#import "PPGFileViewController.h"

@interface PPGFileViewController () <UITableViewDataSource,UITableViewDelegate> {
    UITableView      *m_fileTableView;
    NSMutableArray   *m_fileArray;
    int m_chooseRow;
}

@end

@implementation PPGFileViewController

/*-****************************************************************************************
* Method: viewDidLoad
* Description: viewDidLoad
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_chooseRow = -1;
    m_fileArray = [[NSMutableArray alloc] init];
    [self loadHeadView];
    [self loadContentView];
    [self loadBaseData];
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


#pragma mark - ****************************** Base Data ***********************************
/*-****************************************************************************************
* Method: loadBaseData
* Description: loadBaseData
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)loadBaseData {
    [m_fileArray removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    for (int i = 0; i < files.count; i++) {
        NSString *myName = [files objectAtIndex:i];
        myName = myName.uppercaseString;
        if ([myName hasSuffix:@".BIN"]) {
            [m_fileArray addObject:[files objectAtIndex:i]];
        }
    }
    
    [m_fileTableView reloadData];
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
    titleLab.text = @"PPG File";
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerBackView addSubview:lineView];
}


/*-****************************************************************************************
* Method: loadContentView
* Description: loadContentView
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)loadContentView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    footerView.backgroundColor = [UIColor clearColor];
    
    m_fileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_fileTableView.delegate = self;
    m_fileTableView.dataSource = self;
    m_fileTableView.backgroundColor = [UIColor clearColor];
    [m_fileTableView setTableFooterView:footerView];
    m_fileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_fileTableView];
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


#pragma mark - ****************************** Delegate ************************************
/*-****************************************************************************************
* Method: numberOfSectionsInTableView
* Description: numberOfSectionsInTableView
* Parameter:
* Return Data:
 ******************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/*-****************************************************************************************
* Method: numberOfRowsInSection
* Description: numberOfRowsInSection
* Parameter:
* Return Data:
 ******************************************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_fileArray.count;
}


/*-****************************************************************************************
* Method: heightForRowAtIndexPath
* Description: heightForRowAtIndexPath
* Parameter:
* Return Data:
 ******************************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


/*-****************************************************************************************
* Method: heightForHeaderInSection
* Description: heightForHeaderInSection
* Parameter:
* Return Data:
 ******************************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


/*-****************************************************************************************
* Method: viewForHeaderInSection
* Description: viewForHeaderInSection
* Parameter:
* Return Data:
 ******************************************************************************************/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *lineB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    lineB.backgroundColor = [UIColor clearColor];
    [headView addSubview:lineB];
    
    return headView;
}


/*-****************************************************************************************
* Method: cellForRowAtIndexPath
* Description: cellForRowAtIndexPath
* Parameter:
* Return Data:
 ******************************************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellString = @"MainListCell";
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
    
    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-20, 60)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:16];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"%@",[m_fileArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:info1Lab];
    
    if (m_chooseRow == indexPath.row) {
        UIImageView *chooseImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 20, 20, 20)];
        chooseImg.backgroundColor = [UIColor clearColor];
        chooseImg.image = [UIImage imageNamed:@"img_choose.png"];
        [cell.contentView addSubview:chooseImg];
    }
    
    UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
    myLine.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:myLine];
    
    return cell;
}


/*-****************************************************************************************
* Method: didSelectRowAtIndexPath
* Description: didSelectRowAtIndexPath
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (m_chooseRow == -1) {
        m_chooseRow = (int)indexPath.row;
        [tableView reloadData];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.delegate postFile:[m_fileArray objectAtIndex:indexPath.row]];
            [self backAction];
        });
    }
}


@end
