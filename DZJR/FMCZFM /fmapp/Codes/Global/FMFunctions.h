//
//  FMFunctions.h
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//


#ifndef FMFunctions_h
#define FMFunctions_h

#if defined __cplusplus
extern "C" {
#endif
    
#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
    
//
#define SafeNumToBool(x) ((x == nil) ? NO : (([x intValue] == 1) ? YES: NO))
#define SafeNumToFloat(x) ((x == nil) ? 0.0 : [x floatValue])
#define SafeNumToInt(x) ((x == nil) ? 0 : [x intValue])
#define     BYTE            uint8_t
#define     U2              uint16_t
#define     U4              uint32_t
    
//变长数据定义
#pragma  pack(1)    
typedef struct
{
    U2      len;
    void*   data;
}LV,*PLV;
#pragma  pack()
#define LV_DATA(plv) ((char* )&plv->data)
#define NEXT_LV(plv) ((PLV)((char* )plv + 2 + ntohs(plv->len)))
    
    
#pragma mark - JSON
    //将键-值对加入字典。会剔除object或key或dic为nil的情况
    extern void AddObjectForKeyIntoDictionary(id object, id key, NSMutableDictionary *dic);
    
    //从反JSON序列化后的字典里面读取Key对应的对象。 如果对象为NSString对象并且是@"", 会返回nil
    extern id ObjForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的String,不是String的数据则进行转换
    extern NSString* StringForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的CGFloat,不是CGFloat的数据则进行转换
    extern CGFloat FloatForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的double,不是double的数据则进行转换
    extern double DoubleForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的NSInteger,不是NSInteger的数据则进行转换
    extern int IntForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的Boolean,不是Boolean的数据则进行转换
    extern Boolean BoolForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
#pragma mark -MD5加密
    extern NSString* EncryptPassword(NSString *str);
    
#pragma mark -判断是否为空
    extern Boolean IsStringEmptyOrNull(NSString * str);
    
#pragma mark -时间函数
    extern NSString *timeShortDesc(double localAddTime);
    
#pragma mark -GPS转火星坐标
    extern CLLocationCoordinate2D WGS84toGCJ(CLLocationCoordinate2D coord);
#pragma mark -是否为手机号
    extern Boolean IsNormalMobileNum(NSString  *userMobileNum);
#pragma mark -是否身份证号
    extern Boolean IsNormalIdCard(NSString  *userIdCard);
#pragma mark -是否用户名
    extern Boolean IsNormalUserName(NSString *UserName);
#pragma mark - 进行数据录入错误提示
    
    /** 输入错误提示
     
     *@param NSString *errorString 错误提示信息
     *@See 返回一个对话框，且无标题，仅有错误提示内容和一个确定操作按键
     **/
    extern void ShowImportErrorAlertView(NSString *errorString);
#pragma mark -MBProgressHUD
    extern void ShowAutoHideMBProgressHUD(UIView *onView, NSString *labelText);
    extern void ShowIMAutoHideMBProgressHUD(UIView *onView, NSString *labelText);
    extern void WaittingMBProgressHUD(UIView *onView, NSString *labelText);
    extern void SuccessMBProgressHUD(UIView *onView, NSString *labelText);
    extern void FailedMBProgressHUD(UIView *onView, NSString *labelText);
    extern void FinishMBProgressHUD(UIView *onView);
#pragma mark -PullToRefreshView
    extern void UpdateLastRefreshDataForPullToRefreshViewOnView(UIScrollView *view);
    extern void ConfiguratePullToRefreshViewAppearanceForScrollView(UIScrollView *view);
    
#pragma mark -Image TOOL
    extern UIImage* createImageWithColor(UIColor *color);
    extern UIColor* colorAddAlpha(UIColor* color,CGFloat alpha);
#pragma mark -LoadMoreCell
    extern HUILoadMoreCell* CreateLoadMoreCell();
    
#pragma mark -LV
    extern NSString* StringFromLV(PLV plv);

    
    
#if defined __cplusplus
};
#endif


#endif
