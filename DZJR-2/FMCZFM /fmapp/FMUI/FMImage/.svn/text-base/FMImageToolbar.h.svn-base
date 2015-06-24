//
//  MJPhotoToolbar.h
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMImageToolbarDelegate <NSObject>
- (void)clickImageSave;
@end

@interface FMImageToolbar : UIView
@property (nonatomic, assign) NSInteger photoCount;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, weak) id<FMImageToolbarDelegate> delegate;
@end
