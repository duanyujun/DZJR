//
//  ProjectModel.h
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic,copy) NSString      *addtime;
@property (nonatomic,copy) NSString      *biaoti;
@property (nonatomic,copy) NSString      *chenggong;
@property (nonatomic,copy) NSString      *end_time;
@property (nonatomic,copy) NSString      *fanhuanfou;
@property (nonatomic,copy) NSString      *fincal_id;
@property (nonatomic,copy) NSString      *intro;
@property (nonatomic,copy) NSString      *jginfo;
@property (nonatomic,copy) NSString      *jiexi_time;
@property (nonatomic,copy) NSString      *jindu;
@property (nonatomic,copy) NSString      *ketou;
@property (nonatomic,copy) NSString      *leixing;
@property (nonatomic,copy) NSString      *licai_id;
@property (nonatomic,copy) NSString      *lilv;
@property (nonatomic,copy) NSString      *qitou;
@property (nonatomic,copy) NSString      *qixi_time;
@property (nonatomic,copy) NSString      *qixian;
@property (nonatomic,copy) NSString      *start_time;
@property (nonatomic,copy) NSString      *status;
@property (nonatomic,copy) NSString      *tuijian;
@property (nonatomic,copy) NSString      *tupian;
@property (nonatomic,copy) NSString      *ygjine;
@property (nonatomic,copy) NSString      *zjine;


+(id)initProjectInforWithUnserializedJSONDic:(NSDictionary *)dicInfor;

@end
