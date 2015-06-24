//
//  BorrowViewController.m
//  fmapp
//
//  Created by apple on 15/3/17.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "BorrowViewController.h"
#import "CommonSelectController.h"
#import "HTTPClient+ExploreModules.h"

#define KDateBtn       10001
#define KFinancingBtn  10002
#define KRepaymentBtn  10003

@interface BorrowViewController ()<UITextFieldDelegate,UIScrollViewDelegate,selectCodeDelegate>

@property (nonatomic,weak)UITextField      *titleTextField;
@property (nonatomic,weak)UITextField      *companyTextField;
@property (nonatomic,weak)UITextField      *contactsTextField;
@property (nonatomic,weak)UITextField      *telTextField;
@property (nonatomic,weak)UITextField      *moneyTextField;
@property (nonatomic,weak)UILabel          *dateLabeel;
@property (nonatomic,weak)UITextField      *scaleTextField;
@property (nonatomic,weak)UITextField      *dayTextField;
@property (nonatomic,weak)UILabel          *financLabel;
@property (nonatomic,weak)UILabel          *repayLabeel;
@property (nonatomic,weak)UITextField      *introTextField;

@property (nonatomic,copy)NSString         *dateId;
@property (nonatomic,copy)NSString         *finaId;
@property (nonatomic,copy)NSString         *repayId;

@end


@implementation BorrowViewController
- (id)init{
    self = [super init];
    if (self) {
        self.enableCustomNavbarBackButton=TRUE;
    }
    
    return self;
}
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = KDefaultOrNightScrollViewColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingNavTitle:@"我要借款"];
    [self initWithUserInformationControllerFrame];
}
-(void)initWithUserInformationControllerFrame{
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,KProjectScreenWidth, 416 + (HUIIsIPhone5() ? 88 : 0))];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate=self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    [mainScrollView setContentSize:CGSizeMake(KProjectScreenWidth, 416 + (HUIIsIPhone5() ? 88 : 0) + 250)];
    [self.view addSubview:mainScrollView];

    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, KProjectScreenWidth, 47.5*9+47)];
    backView.backgroundColor=[UIColor whiteColor];
    [mainScrollView addSubview:backView];
    
    for(int i=1;i<=10;i++)
    {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 47.5*i-0.5, KProjectScreenWidth, 0.5f)];
        lineView.backgroundColor=KSepLineColorSetup;
        [backView addSubview:lineView];
    }
    ////借款标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,90, 47)];
    titleLabel.textColor = KSubTitleContentTextColor;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.text=@"借款标题";
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    titleLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:titleLabel];
    
    UITextField *titleText = [[UITextField alloc]initWithFrame:CGRectMake(90.0f,0.0f, KProjectScreenWidth-20-90, 47.0f)];
    [titleText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [titleText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [titleText setKeyboardType:UIKeyboardTypeDefault];
    [titleText setFont:[UIFont systemFontOfSize:15.0f]];
    [titleText setTextAlignment:NSTextAlignmentRight];
    [titleText setReturnKeyType:UIReturnKeySend];
    [titleText setPlaceholder:@"请输入借款标题"];
    [titleText setDelegate:self];
    [titleText setTextColor:KContentTextColor];
    self.titleTextField=titleText;
    [backView addSubview:titleText];

    ///企业名称
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47.5,90, 47)];
    companyLabel.textColor = KSubTitleContentTextColor;
    companyLabel.font = [UIFont systemFontOfSize:16.0f];
    companyLabel.text=@"企业名称";
    [companyLabel setTextAlignment:NSTextAlignmentLeft];
    companyLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:companyLabel];
    
    UITextField *companyText = [[UITextField alloc]initWithFrame:CGRectMake(90.0f,47.5f, KProjectScreenWidth-20-90, 47.0f)];
    [companyText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [companyText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [companyText setKeyboardType:UIKeyboardTypeDefault];
    [companyText setFont:[UIFont systemFontOfSize:15.0f]];
    [companyText setTextAlignment:NSTextAlignmentRight];
    [companyText setReturnKeyType:UIReturnKeySend];
    [companyText setPlaceholder:@"企业名称"];
    [companyText setDelegate:self];
    [companyText setTextColor:KContentTextColor];
    self.companyTextField=companyText;
    [backView addSubview:companyText];
    
    ///联系人
    UILabel *connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47.5*2,90, 47)];
    connectLabel.textColor = KSubTitleContentTextColor;
    connectLabel.font = [UIFont systemFontOfSize:16.0f];
    connectLabel.text=@"联系人";
    [connectLabel setTextAlignment:NSTextAlignmentLeft];
    connectLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:connectLabel];
    
    UITextField *connectText = [[UITextField alloc]initWithFrame:CGRectMake(90.0f,47.5f*2, KProjectScreenWidth-20-90, 47.0f)];
    [connectText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [connectText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [connectText setKeyboardType:UIKeyboardTypeDefault];
    [connectText setFont:[UIFont systemFontOfSize:15.0f]];
    [connectText setTextAlignment:NSTextAlignmentRight];
    [connectText setReturnKeyType:UIReturnKeySend];
    [connectText setPlaceholder:@"联系人姓名"];
    [connectText setDelegate:self];
    [connectText setTextColor:KContentTextColor];
    self.contactsTextField=connectText;
    [backView addSubview:connectText];
    
    ///手机号
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47.5*3,90, 47)];
    telLabel.textColor = KSubTitleContentTextColor;
    telLabel.font = [UIFont systemFontOfSize:16.0f];
    telLabel.text=@"手机号";
    [telLabel setTextAlignment:NSTextAlignmentLeft];
    telLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:telLabel];
    
    UITextField *telText = [[UITextField alloc]initWithFrame:CGRectMake(90.0f,47.5f*3, KProjectScreenWidth-20-90, 47.0f)];
    [telText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [telText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [telText setKeyboardType:UIKeyboardTypePhonePad];
    [telText setFont:[UIFont systemFontOfSize:15.0f]];
    [telText setTextAlignment:NSTextAlignmentRight];
    [telText setReturnKeyType:UIReturnKeySend];
    [telText setDelegate:self];
    [telText setPlaceholder:@"联系人手机号"];
    [telText setTextColor:KContentTextColor];
    self.telTextField=telText;
    [backView addSubview:telText];
    
    UILabel *monetLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47.5*4,100, 47)];
    monetLabel.textColor = KSubTitleContentTextColor;
    monetLabel.font = [UIFont systemFontOfSize:16.0f];
    monetLabel.text=@"意向融资金额";
    [monetLabel setTextAlignment:NSTextAlignmentLeft];
    monetLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:monetLabel];
    
    UITextField *moneyText = [[UITextField alloc]initWithFrame:CGRectMake(120.0f,47.5f*4, KProjectScreenWidth-20-120-30, 47.0f)];
    [moneyText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [moneyText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [moneyText setKeyboardType:UIKeyboardTypePhonePad];
    [moneyText setFont:[UIFont systemFontOfSize:15.0f]];
    [moneyText setTextAlignment:NSTextAlignmentRight];
    [moneyText setReturnKeyType:UIReturnKeySend];
    [moneyText setDelegate:self];
    [moneyText setPlaceholder:@"融资金额"];
    [moneyText setTextColor:KContentTextColor];
    self.moneyTextField=moneyText;
    [backView addSubview:moneyText];

    UILabel *monetUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(KProjectScreenWidth-5-40, 47.5*4,40, 47)];
    monetUnitLabel.textColor = KSubTitleContentTextColor;
    monetUnitLabel.font = [UIFont systemFontOfSize:16.0f];
    monetUnitLabel.text=@"万元";
    [monetUnitLabel setTextAlignment:NSTextAlignmentLeft];
    monetUnitLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:monetUnitLabel];
    
    UIButton *dateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.backgroundColor=[UIColor clearColor];
    [dateBtn setFrame:CGRectMake(0, 47.5f*5, KProjectScreenWidth, 47)];
    [dateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    dateBtn.tag=KDateBtn;
    [backView addSubview:dateBtn];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,100, 47)];
    dateLabel.textColor = KSubTitleContentTextColor;
    dateLabel.font = [UIFont systemFontOfSize:16.0f];
    dateLabel.text=@"意向融资期限";
    [dateLabel setTextAlignment:NSTextAlignmentLeft];
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateBtn addSubview:dateLabel];
    
    UILabel *dateContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0,KProjectScreenWidth-120-30, 47)];
    dateContentLabel.textColor = KSubNumbeiTextColor;
    dateContentLabel.font = [UIFont systemFontOfSize:16.0f];
    dateContentLabel.text=@"请选择";
    [dateContentLabel setTextAlignment:NSTextAlignmentRight];
    dateContentLabel.backgroundColor = [UIColor clearColor];
    self.dateLabeel=dateContentLabel;
    [dateBtn addSubview:dateContentLabel];
    
    UIImageView *arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-25, 16.5, 10, 14)];
    arrowImage.image=[UIImage imageNamed:@"More_CellArrow.png"];
    [dateBtn addSubview:arrowImage];
    
    UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47.5*6,100, 47)];
    scaleLabel.textColor = KSubTitleContentTextColor;
    scaleLabel.font = [UIFont systemFontOfSize:16.0f];
    scaleLabel.text=@"融资利率";
    [scaleLabel setTextAlignment:NSTextAlignmentLeft];
    scaleLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:scaleLabel];
    
    UITextField *scaleText = [[UITextField alloc]initWithFrame:CGRectMake(90.0f,47.5f*6, KProjectScreenWidth-90-30, 47.0f)];
    [scaleText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scaleText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [scaleText setKeyboardType:UIKeyboardTypePhonePad];
    [scaleText setFont:[UIFont systemFontOfSize:15.0f]];
    [scaleText setTextAlignment:NSTextAlignmentRight];
    [scaleText setReturnKeyType:UIReturnKeySend];
    [scaleText setDelegate:self];
    [scaleText setPlaceholder:@"请输入利率"];
    [scaleText setTextColor:KContentTextColor];
    self.scaleTextField=scaleText;
    [backView addSubview:scaleText];
    
    UILabel *scaleUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(KProjectScreenWidth-5-20, 47.5*6,20, 47)];
    scaleUnitLabel.textColor = KSubTitleContentTextColor;
    scaleUnitLabel.font = [UIFont systemFontOfSize:16.0f];
    scaleUnitLabel.text=@"%";
    [scaleUnitLabel setTextAlignment:NSTextAlignmentLeft];
    scaleUnitLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:scaleUnitLabel];
    
//    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47.5*7,100, 47)];
//    dayLabel.textColor = KSubTitleContentTextColor;
//    dayLabel.font = [UIFont systemFontOfSize:16.0f];
//    dayLabel.text=@"融资天数";
//    [dayLabel setTextAlignment:NSTextAlignmentLeft];
//    dayLabel.backgroundColor = [UIColor clearColor];
//    [backView addSubview:dayLabel];
//    
//    UITextField *dayText = [[UITextField alloc]initWithFrame:CGRectMake(90.0f,47.5f*7, KProjectScreenWidth-90-30, 47.0f)];
//    [dayText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    [dayText setClearButtonMode:UITextFieldViewModeWhileEditing];
//    [dayText setKeyboardType:UIKeyboardTypePhonePad];
//    [dayText setFont:[UIFont systemFontOfSize:15.0f]];
//    [dayText setTextAlignment:NSTextAlignmentRight];
//    [dayText setReturnKeyType:UIReturnKeySend];
//    [dayText setDelegate:self];
//    [dayText setPlaceholder:@"请输入借款时长"];
//    [dayText setTextColor:KContentTextColor];
//    self.dayTextField=dayText;
//    [backView addSubview:dayText];
//    
//    UILabel *dayUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(KProjectScreenWidth-5-20, 47.5*7,20, 47)];
//    dayUnitLabel.textColor = KSubTitleContentTextColor;
//    dayUnitLabel.font = [UIFont systemFontOfSize:16.0f];
//    dayUnitLabel.text=@"天";
//    [dayUnitLabel setTextAlignment:NSTextAlignmentLeft];
//    dayUnitLabel.backgroundColor = [UIColor clearColor];
//    [backView addSubview:dayUnitLabel];
    
    UIButton *financBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    financBtn.backgroundColor=[UIColor clearColor];
    [financBtn setFrame:CGRectMake(0, 47.5f*7, KProjectScreenWidth, 47)];
    [financBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    financBtn.tag=KFinancingBtn;
    [backView addSubview:financBtn];
    
    UILabel *financLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,100, 47)];
    financLabel.textColor = KSubTitleContentTextColor;
    financLabel.font = [UIFont systemFontOfSize:16.0f];
    financLabel.text=@"融资方式";
    [financLabel setTextAlignment:NSTextAlignmentLeft];
    financLabel.backgroundColor = [UIColor clearColor];
    [financBtn addSubview:financLabel];
    
    UILabel *financContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0,KProjectScreenWidth-120-30, 47)];
    financContentLabel.textColor = KSubNumbeiTextColor;
    financContentLabel.font = [UIFont systemFontOfSize:16.0f];
    financContentLabel.text=@"请选择";
    [financContentLabel setTextAlignment:NSTextAlignmentRight];
    financContentLabel.backgroundColor = [UIColor clearColor];
    self.financLabel=financContentLabel;
    [financBtn addSubview:financContentLabel];
    
    UIImageView *arrowImage1=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-25, 16.5, 10, 14)];
    arrowImage1.image=[UIImage imageNamed:@"More_CellArrow.png"];
    [financBtn addSubview:arrowImage1];

    UIButton *repayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    repayBtn.backgroundColor=[UIColor clearColor];
    [repayBtn setFrame:CGRectMake(0, 47.5f*8, KProjectScreenWidth, 47)];
    [repayBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    repayBtn.tag=KRepaymentBtn;
    [backView addSubview:repayBtn];
    
    UILabel *repayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,100, 47)];
    repayLabel.textColor = KSubTitleContentTextColor;
    repayLabel.font = [UIFont systemFontOfSize:16.0f];
    repayLabel.text=@"还款方式";
    [repayLabel setTextAlignment:NSTextAlignmentLeft];
    repayLabel.backgroundColor = [UIColor clearColor];
    [repayBtn addSubview:repayLabel];
    
    UILabel *repayContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0,KProjectScreenWidth-120-30, 47)];
    repayContentLabel.textColor = KSubNumbeiTextColor;
    repayContentLabel.font = [UIFont systemFontOfSize:16.0f];
    repayContentLabel.text=@"请选择";
    [repayContentLabel setTextAlignment:NSTextAlignmentRight];
    repayContentLabel.backgroundColor = [UIColor clearColor];
    self.repayLabeel=repayContentLabel;
    [repayBtn addSubview:repayContentLabel];
    
    UIImageView *arrowImage2=[[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-25, 16.5, 10, 14)];
    arrowImage2.image=[UIImage imageNamed:@"More_CellArrow.png"];
    [repayBtn addSubview:arrowImage2];
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 47.5f*9,90, 47)];
    introLabel.textColor = KSubTitleContentTextColor;
    introLabel.font = [UIFont systemFontOfSize:16.0f];
    introLabel.text=@"备注说明";
    [introLabel setTextAlignment:NSTextAlignmentLeft];
    introLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:introLabel];
    
    UITextField *introText = [[UITextField alloc]initWithFrame:CGRectMake(90.0f,47.5f*9, KProjectScreenWidth-20-90, 47.0f)];
    [introText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [introText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [introText setKeyboardType:UIKeyboardTypeDefault];
    [introText setFont:[UIFont systemFontOfSize:15.0f]];
    [introText setTextAlignment:NSTextAlignmentRight];
    [introText setReturnKeyType:UIReturnKeySend];
    [introText setPlaceholder:@"备注说明"];
    [introText setDelegate:self];
    [introText setTextColor:KContentTextColor];
    self.introTextField=introText;
    [backView addSubview:introText];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateNormal];
    [finishButton setBackgroundImage:createImageWithColor([UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1])
                            forState:UIControlStateHighlighted];
    [finishButton setTitle:@"完成"
                  forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [finishButton setFrame:CGRectMake(20.0f,47.5*11+40, KProjectScreenWidth-40, 43.0f)];
    [finishButton.layer setBorderWidth:0.5f];
    [finishButton.layer setCornerRadius:5.0f];
    [finishButton.layer setMasksToBounds:YES];
    [finishButton setBackgroundColor:KDefaultOrNightBackGroundColor];
    [finishButton.layer setBorderColor:[KDefaultOrNightSepratorColor CGColor]];
    [finishButton addTarget:self action:@selector(bottombtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:finishButton];
    
    
}
- (void)codeSelectedSucceedWithselectDic:(NSDictionary *)selectDic andTitle:(NSString *)titleStr
{
    if ([titleStr isEqualToString:@"意向融资期限"]) {
     
        self.dateLabeel.text=StringForKeyInUnserializedJSONDic(selectDic, @"title");
        self.dateId=StringForKeyInUnserializedJSONDic(selectDic, @"qixian_id");
    }
    else if ([titleStr isEqualToString:@"融资方式"])
    {
        self.financLabel.text=StringForKeyInUnserializedJSONDic(selectDic, @"title");
        self.finaId=StringForKeyInUnserializedJSONDic(selectDic, @"id");
    }
    else
    {
        self.repayLabeel.text=StringForKeyInUnserializedJSONDic(selectDic, @"title");
        self.repayId=StringForKeyInUnserializedJSONDic(selectDic, @"id");
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)bottombtnClick
{
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    if (IsStringEmptyOrNull(self.titleTextField.text)) {
        ShowImportErrorAlertView(@"请输入借款标题");
        return;
    }
    AddObjectForKeyIntoDictionary(self.titleTextField.text, @"title", parameters);
    
    if (!IsStringEmptyOrNull(self.companyTextField.text)) {
        AddObjectForKeyIntoDictionary(self.companyTextField.text, @"company", parameters);
    }
    if (IsStringEmptyOrNull(self.contactsTextField.text)) {
        ShowImportErrorAlertView(@"请输入联系人");
        return;
    }
    AddObjectForKeyIntoDictionary(self.contactsTextField.text, @"contact", parameters);
    if (IsStringEmptyOrNull(self.telTextField.text)) {
        ShowImportErrorAlertView(@"请输入手机号");
    }
    AddObjectForKeyIntoDictionary(self.telTextField.text, @"mobile", parameters);

    if (IsStringEmptyOrNull(self.moneyTextField.text)) {
        ShowImportErrorAlertView(@"请输入融资金额");
        return;
    }
    AddObjectForKeyIntoDictionary(self.moneyTextField.text, @"jiner", parameters);
    if (!IsStringEmptyOrNull(self.dateId)) {
        AddObjectForKeyIntoDictionary(self.dateId, @"qixian", parameters);
    }
    if (!IsStringEmptyOrNull(self.scaleTextField.text)) {
        AddObjectForKeyIntoDictionary(self.scaleTextField.text, @"lilv", parameters);
    }
//    if (!IsStringEmptyOrNull(self.dayTextField.text)) {
//        AddObjectForKeyIntoDictionary(self.dayTextField.text, @"rongzitianshu", parameters);
//    }
    if (!IsStringEmptyOrNull(self.repayId)) {
        AddObjectForKeyIntoDictionary(self.repayId, @"huankuanfangshi", parameters);
    }
    if (!IsStringEmptyOrNull(self.finaId)) {
        AddObjectForKeyIntoDictionary(self.finaId, @"rongzifangshi", parameters);
    }
    if (!IsStringEmptyOrNull(self.introTextField.text)) {
        AddObjectForKeyIntoDictionary(self.introTextField.text, @"miaoshu", parameters);
    }
    
    WaittingMBProgressHUD(HUIKeyWindow, @"保存中...");
    [FMHTTPClient borrowWithUserId:parameters completion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (response.code==WebAPIResponseCodeSuccess) {
                
                SuccessMBProgressHUD(HUIKeyWindow, @"保存成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                FailedMBProgressHUD(HUIKeyWindow, @"保存失败");
            }
            
        });
    }];


}
- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag==KDateBtn) {
        
        [FMHTTPClient getRongZiQiXianWithcompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                Log(@"%@",response.responseObject);
                if (response.code==WebAPIResponseCodeSuccess) {
                   
                    CommonSelectController *viewController=[[CommonSelectController alloc]initWithDataArr:ObjForKeyInUnserializedJSONDic(response.responseObject, kDataKeyData) WithTltle:@"意向融资期限"];
                    viewController.delegate=self;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            });
        }];
    }
    else if (btn.tag==KFinancingBtn)
    {
        [FMHTTPClient getRongZiFangShiWithcompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                Log(@"%@",response.responseObject);
                if (response.code==WebAPIResponseCodeSuccess) {
                    
                    CommonSelectController *viewController=[[CommonSelectController alloc]initWithDataArr:ObjForKeyInUnserializedJSONDic(response.responseObject, kDataKeyData) WithTltle:@"融资方式"];
                    viewController.delegate=self;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            });
        }];
 
    }else if (btn.tag==KRepaymentBtn)
    {
        NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
        AddObjectForKeyIntoDictionary(@"等额本息", @"title", dic1);
        AddObjectForKeyIntoDictionary(@"1", @"id", dic1);
        
        NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
        AddObjectForKeyIntoDictionary(@"每月还息到期还本息", @"title", dic2);
        AddObjectForKeyIntoDictionary(@"2", @"id", dic2);
        
        NSArray *arr=[NSArray arrayWithObjects:dic1,dic2, nil];
        CommonSelectController *viewController=[[CommonSelectController alloc]initWithDataArr:arr WithTltle:@"还款方式"];
        viewController.delegate=self;
        [self.navigationController pushViewController:viewController animated:YES];

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
