//
//  FlatGroupedStyleCell.m
//
//  fmapp
//
//  Created by lyh on 14-5-5.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "FlatGroupedStyleCell.h"

#define MIN_PADDING 10.0f
#define MAXIMUM_ACCESSORYVIEW_WIDTH 100.0f
#define ACCESSORY_ICON_SIZE 20.0f

#define MAXIMUM_HEAD_WIDTH  100.0f

@implementation FlatGroupedStyleCell {
    BOOL _lastCell;
    BOOL _firstCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.textLabel setFont:kFontWithDefaultSize];
        if (HUISystemVersionBelow(kHUISystemVersion_7_0)) {
            [self setBackgroundColor:[FMThemeManager.skin backgroundColor]];
        }else{
            [self setBackgroundColor:[UIColor clearColor]];
        }
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        self.sepLineLeft = 50.0;
    }
    return self;
}

-(void)awakeFromNib {
    
    [self.textLabel setFont:kFontWithDefaultSize];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    
}
-(void)layoutSubviews {
    [super layoutSubviews];

    CGFloat _accesoryWidth = _cellAccessoryView ? CGRectGetWidth(_cellAccessoryView.frame) < MAXIMUM_ACCESSORYVIEW_WIDTH ? CGRectGetWidth(_cellAccessoryView.frame) : MAXIMUM_ACCESSORYVIEW_WIDTH : 0.0f;
    CGFloat _headSize = _headView ? CGRectGetWidth(_headView.frame) < MAXIMUM_HEAD_WIDTH ? CGRectGetWidth(_headView.frame) : MAXIMUM_HEAD_WIDTH : 0.0f;

    CGFloat _textLeft = MIN_PADDING;
    CGFloat _textWidth = CGRectGetWidth(self.bounds) - 2 *MIN_PADDING;
    if (_headView) {
        _textLeft += MIN_PADDING + _headSize;
        _textWidth -= MIN_PADDING + _headSize;
    }
    if (_cellAccessoryView) {
        _textWidth -= MIN_PADDING + _accesoryWidth;
    }
    CGRect _textLabelRect = CGRectMake(_textLeft, 0, _textWidth, CGRectGetHeight(self.bounds));
    [self.textLabel setFrame:_textLabelRect];
    
    if (_headView) {
        CGRect _headRect = CGRectMake(MIN_PADDING,
                                      (self.bounds.size.height - _headView.frame.size.height)/2,
                                      _headView.frame.size.width,
                                      _headView.frame.size.height);
        [_headView setFrame:_headRect];
    }
    
    CGSize _accessorySize = CGSizeMake(_accesoryWidth, CGRectGetHeight(self.bounds));
    CGRect _accessoryRect = CGRectMake(CGRectGetWidth(self.bounds) - MIN_PADDING - _accesoryWidth, 0, _accessorySize.width, _accessorySize.height);
    [_cellAccessoryView setFrame:_accessoryRect];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    
    [[FMThemeManager.skin backgroundColor] setFill];
    [path fill];
    
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:CGPointMake(self.sepLineLeft, CGRectGetMaxY(rect))];
    [line addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [[FMThemeManager.skin sepratorColor] setStroke];
    [line stroke];
    
    if (_lastCell) {
        UIBezierPath *bottomline = [UIBezierPath bezierPath];
        [bottomline moveToPoint:CGPointMake(0.0f, CGRectGetMaxY(rect))];
        [bottomline addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [[FMThemeManager.skin sepratorColor] setStroke];
        [bottomline stroke];
    }
    if (_firstCell) {
        UIBezierPath *bottomline = [UIBezierPath bezierPath];
        [bottomline moveToPoint:CGPointMake(0.0f, 0.0f)];
        [bottomline addLineToPoint:CGPointMake(CGRectGetMaxX(rect), 0.0f)];
        [[FMThemeManager.skin sepratorColor] setStroke];
        [bottomline stroke];
    }
    
}

- (void)setHeadView:(UIView *)view{
    if(_headView) {
        [_headView removeFromSuperview];
    }
    _headView = view;
    [self addSubview:_headView];
    [self setNeedsDisplay];
}
- (void)setCellAccessoryView:(UIView *)view {
    if(_cellAccessoryView) {
        [_cellAccessoryView removeFromSuperview];
    }
    _cellAccessoryView = view;
    [self addSubview:_cellAccessoryView];
    [self setNeedsDisplay];
}

- (void)setLastCell:(BOOL)boolValue {
    _lastCell = boolValue;
    [self setNeedsDisplay];
}
- (void)setFirstCell:(BOOL)boolValue {
    _firstCell = boolValue;
    [self setNeedsDisplay];
}


@end
