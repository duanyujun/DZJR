//
//  PlaceHolderTextView.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.placeHolder = @"";
        self.placeHolderColor = [UIColor lightGrayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.placeHolder = @"";
    self.placeHolderColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([[self placeHolder] length] > 0) {
        if (self.placeHolderLabel == nil) {
            self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
            self.placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.font = self.font;
            self.placeHolderLabel.backgroundColor = [UIColor clearColor];
            self.placeHolderLabel.alpha = 0;
            [self addSubview:self.placeHolderLabel];
        }
        
        self.placeHolderLabel.text = self.placeHolder;
        self.placeHolderLabel.textColor = self.placeHolderColor;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
        
        if (self.placeHodlerBackgroundImage != nil) {
            UIImageView *placeHodlerBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            [self addSubview:placeHodlerBackgroundImageView];
            
            placeHodlerBackgroundImageView.image = self.placeHodlerBackgroundImage;
            [self sendSubviewToBack:placeHodlerBackgroundImageView];
        }
    }
    
    if ([[self text] length] == 0 && [[self placeHolder] length] > 0) {
        [self.placeHolderLabel setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

- (void)textChanged:(NSNotification *)notification
{
    if ([[self placeHolder] length] == 0) {
        return;
    }
    if ([[self text] length] == 0) {
        [self.placeHolderLabel setAlpha:1];
    }
    else {
        [self.placeHolderLabel setAlpha:0];
    }
}

@end
