//
//  FMUIDatePickerView.h
//  fmapp
//
//  Created by 张利广 on 14-9-12.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 时间选择器控制协议**/
@protocol FMUIDatePickerDelegate <NSObject>

///取消选择时间空间内容
- (void)initWithUserCancelSelectedDateOperationResult:(NSString *)resultString withIntegerTag:(NSInteger)IntegerTag;
////选择时间结束后操作内容
- (void)initWithUserDoneSelectedDateOperationResult:(NSString *)resultString withIntegerTag:(NSInteger)IntegerTag;;

@end


@interface FMUIDatePickerView : UIView
@property (nonatomic , assign) id<FMUIDatePickerDelegate>   fmPickerDelegate;
@property (nonatomic , assign)  NSInteger                   UserHiddendIntegerTag;

- (id)initWithFrame:(CGRect)frame WithDatePickerDelegate:(id<FMUIDatePickerDelegate>) delegate;

- (void)initWithWithHiddend:(BOOL)boolHiddend WithUserHiddendIntegerTag:(NSInteger)IntegerTag;
@end
