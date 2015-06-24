//
//  HUILoadMoreCell.h
//  HUIKit
//
//  Created by lyh on 14-5-7.
//  Copyright (c) 2014年 com. All rights reserved.
//
//

#import <UIKit/UIKit.h>

#if defined __cplusplus
extern "C" {
#endif
extern const CGFloat kHUILoadMoreCellDefaultHeight;
extern NSString* const kHUILoadMoreCellIdentifier;
#if defined __cplusplus
};
#endif


@interface HUILoadMoreCell : UITableViewCell

@property (nonatomic, copy) void(^loadMoreOperationDidStartedBlock)(void);
@property (nonatomic, copy) void(^loadMoreOperationDidStoppedBlock)(void);

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;


- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;

- (void)startLoadMore;        //will start loading animation and call loadMoreOperationDidStartedBlock
- (void)stopLoadMore;         //will stop loading animation and call loadMoreOperationDidStoppedBlock  



@end
