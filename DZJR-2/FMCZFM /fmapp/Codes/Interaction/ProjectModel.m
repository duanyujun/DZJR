//
//  ProjectModel.m
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ProjectModel.h"

@implementation ProjectModel

+(id)initProjectInforWithUnserializedJSONDic:(NSDictionary *)dicInfor
{
    ProjectModel *model=[[ProjectModel alloc]init];
    model.addtime=StringForKeyInUnserializedJSONDic(dicInfor, @"addtime");
    model.biaoti=StringForKeyInUnserializedJSONDic(dicInfor, @"biaoti");
    model.chenggong=StringForKeyInUnserializedJSONDic(dicInfor, @"chenggong");
    model.end_time=StringForKeyInUnserializedJSONDic(dicInfor, @"end_time");
    model.fanhuanfou=StringForKeyInUnserializedJSONDic(dicInfor, @"fanhuanfou");
    model.fincal_id=StringForKeyInUnserializedJSONDic(dicInfor, @"fincal_id");
    model.intro=StringForKeyInUnserializedJSONDic(dicInfor, @"intro");
    model.jginfo=StringForKeyInUnserializedJSONDic(dicInfor, @"jginfo");
    model.jiexi_time=StringForKeyInUnserializedJSONDic(dicInfor, @"jiexi_time");
    model.jindu=StringForKeyInUnserializedJSONDic(dicInfor, @"jindu");
    model.ketou=StringForKeyInUnserializedJSONDic(dicInfor, @"ketou");
    model.leixing=StringForKeyInUnserializedJSONDic(dicInfor, @"leixing");
    model.licai_id=StringForKeyInUnserializedJSONDic(dicInfor, @"licai_id");
    model.lilv=StringForKeyInUnserializedJSONDic(dicInfor, @"lilv");
    model.qitou=StringForKeyInUnserializedJSONDic(dicInfor, @"qitou");
    model.qixi_time=StringForKeyInUnserializedJSONDic(dicInfor, @"qixi_time");
    model.qixian=StringForKeyInUnserializedJSONDic(dicInfor, @"qixian");
    model.start_time=StringForKeyInUnserializedJSONDic(dicInfor, @"start_time");
    model.status=StringForKeyInUnserializedJSONDic(dicInfor, @"status");
    model.tuijian=StringForKeyInUnserializedJSONDic(dicInfor, @"tuijian");
    model.tupian=StringForKeyInUnserializedJSONDic(dicInfor, @"tupian");
    model.ygjine=StringForKeyInUnserializedJSONDic(dicInfor, @"ygjine");
    model.zjine=StringForKeyInUnserializedJSONDic(dicInfor, @"zjine");
    
    return model;
}

@end
