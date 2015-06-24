//
//  HUILoadMoreCell.m
//  HUIKit
//
//  Created by lyh on 14-5-7.
//  Copyright (c) 2014年 com. All rights reserved.
//
//

#import "HUILoadMoreCell.h"

const CGFloat kHUILoadMoreCellDefaultHeight = 30.00;
NSString* const kHUILoadMoreCellIdentifier  = @"HUILoadMoreCell";

@interface HUILoadMoreCell ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation HUILoadMoreCell

- (void)dealloc
{
    if ([self.loadingView isAnimating])
        [self.loadingView stopAnimating];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingView.center = CGPointMake(50.00 + self.loadingView.bounds.size.width * 0.5,
                                          self.bounds.size.height * 0.5);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
                                    | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:self.loadingView];
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithReuseIdentifier:reuseIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    if ([self _isLoading])
        [self stopLoadMore];
}

- (BOOL)_isLoading
{
    return [self.loadingView isAnimating];
}

- (void)startLoadingAnimation
{
    [self.loadingView startAnimating];
}

- (void)stopLoadingAnimation
{
    [self.loadingView stopAnimating];
}

- (void)startLoadMore
{
    [self startLoadingAnimation];
    if (self.loadMoreOperationDidStartedBlock)
        self.loadMoreOperationDidStartedBlock();
}

- (void)stopLoadMore
{
    [self stopLoadingAnimation];
    if (self.loadMoreOperationDidStoppedBlock)
        self.loadMoreOperationDidStoppedBlock();
}

@end
