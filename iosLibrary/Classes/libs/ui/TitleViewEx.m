//
//  TitleViewEx.m
//  cjcr
//
//  Created by liu on 2017/1/19.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import "TitleViewEx.h"
#import "toolMacro.h"
#import <UIKit/UIKit.h>
#import <UIButton+WebCache.h>
#import <UIView+WZLBadge.h>
#import "UIView+UIViewHelper.h"
#import "UIButton+WGBCustom.h"

@interface BtnInfo : NSObject

@property(assign,nonatomic) int execType;
@property(strong,nonatomic) NSDictionary * param;

@end

@implementation BtnInfo
@end

#define HOR_SPACE   PTTO6SH(10)

@interface TitleViewEx()
{
    UIButton                            * btnExit;
    MyLinearLayout                      * llTitleLayout;
    UILabel                             * labTitle;
    UIImageView                         * ivTitleIco;
    UIView                              * line;
    //
    MyLinearLayout                      * llLeft;
    MyLinearLayout                      * llRight;
    //
    NSMutableArray                      * btnParamArray;
    NSMutableArray                      * btnArray;
    int                                 btnCounter;
}
@end

@implementation TitleViewEx

-(void)initExitBtn
{
    btnExit = ONEW(UIButton);
    btnExit.hidden = YES;
    btnExit.leftPos.equalTo(@0);
    btnExit.centerYPos.equalTo(llTitleLayout);
    [self addSubview:btnExit];
    [btnExit addTarget:self action:@selector(exit_click:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initTitleBtn
{
    llTitleLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    llTitleLayout.backgroundColor = [UIColor clearColor];
    llTitleLayout.heightSize.equalTo(self);
    llTitleLayout.wrapContentWidth = YES;
    [llTitleLayout addTapGestureSelector:@selector(titleLayoutClick:) target:self];
    [self addSubview:llTitleLayout];
    //
    labTitle = ONEW(UILabel);
    labTitle.widthSize.equalTo(labTitle.widthSize).max(SCREEN_WIDTH * 0.5);
    labTitle.heightSize.equalTo(llTitleLayout);
    labTitle.numberOfLines = 1;
    [llTitleLayout addSubview:labTitle];
    //
    ivTitleIco = ONEW(UIImageView);
    ivTitleIco.wrapContentSize = YES;
    ivTitleIco.myCenterY = 0;
    [llTitleLayout addSubview:ivTitleIco];
}

-(void)initView
{
    self.insetsPaddingFromSafeArea = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    [self initTitleBtn];
    [self initExitBtn];
    //
    llLeft = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    [llLeft makeLayout:^(MyMaker *make) {
        make.left.equalTo(btnExit.rightPos);
        make.centerY.equalTo(llTitleLayout);
        make.height.equalTo(llTitleLayout);
    }];
    llLeft.wrapContentWidth = YES;
    [self addSubview:llLeft];
    //
    llRight = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    llRight.wrapContentWidth = YES;
    
    [llRight makeLayout:^(MyMaker *make) {
        make.right.equalTo(self.rightPos);
        make.centerY.equalTo(llTitleLayout);
        make.height.equalTo(llLeft);
    }];
    [self addSubview:llRight];
    //
    btnParamArray = [[NSMutableArray alloc] init];
    btnArray = [[NSMutableArray alloc] init];
    //
    line = [[UIView alloc] init];
    line.bottomPos.equalTo(self.bottomPos);
    line.leftPos.equalTo(self.leftPos);
    line.rightPos.equalTo(self.rightPos);
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initView];
    }
    return self;
}

+(instancetype)createTitleView
{
    return ONEW(TitleViewEx);
}

-(void)setTitleRightImage:(UIImage *)img space:(CGFloat)space
{
    ivTitleIco.image = img;
    ivTitleIco.myLeft = space;
}

-(void)setTitle:(NSString *)title
{
    labTitle.text = title;
}

-(void)setTitleColor:(UIColor *)tc
{
    labTitle.textColor = tc;
}

-(void)setTitle:(NSString *)title titleFont:(UIFont *)tf titleColor:(UIColor *)tc
{
    [self setTitle:title titleFont:tf titleColor:tc titleAlignment:TITLE_ALIG_MIDDLE];
}

-(void)setTitle:(NSString *)title titleFont:(UIFont *)tf titleColor:(UIColor *)tc titleAlignment:(int)ta
{
    labTitle.text = title;
    labTitle.textColor = tc;
    labTitle.font = tf;
    //
    if (ta == TITLE_ALIG_LEFT)
    {
        llTitleLayout.leftPos.equalTo(llLeft.rightPos).offset(HOR_SPACE);
    }else
    {
        llTitleLayout.centerXPos.equalTo(self.centerXPos);
    }
    llTitleLayout.centerYPos.equalTo(self.centerYPos).offset(SYSTEM_STATUS_HEIGHT / 2);
}

-(void)setExitImgStr:(NSString *)eis
{
    btnExit.hidden = eis == nil;
    if (eis == nil) return;
    BOOL isHttp = [eis hasPrefix:@"http"];
    if (isHttp)
    {
        [btnExit sd_setImageWithURL:[NSURL URLWithString:eis] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)
            {
                btnExit.mySize = PTTO6SIZE(image.size);
            }
        }];
    }else
    {
        UIImage * image = [UIImage imageNamed:eis];
        [btnExit setBackgroundImage:image forState:UIControlStateNormal];
        btnExit.mySize = PTTO6SIZE(image.size);
    }
}

/*****************************************************************/
-(void)addButton:(UIButton *)btn btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et
{
    btn.myCenterY = 0;
    if (bl == TITLE_BTN_LEF)
    {
        [llLeft addSubview:btn];
        [btn addTarget:self action:@selector(btn_left_click:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [llRight addSubview:btn];
        [btn addTarget:self action:@selector(btn_right_click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    btn.tag = btnCounter++;
    BtnInfo * bi = [[BtnInfo alloc] init];
    bi.param = param;
    bi.execType = et;
    [btnParamArray addObject:bi];
    [btnArray addObject:btn];
}

-(void)addButtonWithImage:(NSString *)imgUrl btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et
{
    UIButton * btn = [[UIButton alloc] init];
    [self loadBtnImageUrl:imgUrl btn:btn];
    [self addButton:btn btnLoc:bl param:param execType:et];
}

-(void)addButtonWithText:(NSString *)text btnTextColor:(UIColor *)tc font:(UIFont *)font btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et
{
    UIButton * btn = [[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:tc forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn sizeToFit];
    if (bl == TITLE_BTN_RIGHT)
    {
        btn.myRight = PTTO6SW(HOR_SPACE);
    }else
    {
        btn.myLeft = PTTO6SW(HOR_SPACE);
    }
    [self addButton:btn btnLoc:bl param:param execType:et];
}

-(void)loadBtnImageUrl:(NSString *)imgUrl btn:(UIButton *)btn
{
    if ([imgUrl hasPrefix:@"http"])
    {
        __weak UIButton * tmp = btn;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if (image)
            {
                CGSize size = image.size;
                size.width = size.width / 3.0f;
                size.height = size.height / 3.0f;
                tmp.mySize = PTTO6SIZE(size);
            }
        }];
        
    }else
    {
        UIImage * img = [UIImage imageNamed:imgUrl];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        btn.mySize = PTTO6SIZE(img.size);
    }
}

//
-(void)mdBtnImgUrl:(NSString *)imgUrl btnIndex:(int)index
{
    if (index < btnArray.count)
    {
        [self loadBtnImageUrl:imgUrl btn:btnArray[index]];
    }
}

-(void)mdBtnText:(NSString *)text btnIndex:(int)index
{
    if (index < btnArray.count)
    {
        UIButton * btn = btnArray[index];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn sizeToFit];
    }
}

-(void)showBadgeBtnIndex:(int)index
{
    if (index < btnArray.count)
    {
        UIButton * btn = btnArray[index];
        [btn showBadge];
    }
}

-(void)hiddenBadgeBtnIndex:(int)index
{
    if (index < btnArray.count)
    {
        UIButton * btn = btnArray[index];
        [btn clearBadge];
    }
}
//
-(void)setTitleViewBottomLineColor:(UIColor *)color lineHeight:(int)height
{
    [line removeFromSuperview];
    line.backgroundColor = color;
    line.myHeight = height;
    [self addSubview:line];
}

-(void)btn_left_click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleBtnClick:sender:param:execType:)])
    {
        BtnInfo * bi = btnParamArray[sender.tag];
        [self.delegate onTitleBtnClick:self sender:sender param:bi.param execType:bi.execType];
    }
}

-(void)btn_right_click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleBtnClick:sender:param:execType:)])
    {
        BtnInfo * bi = btnParamArray[sender.tag];
        [self.delegate onTitleBtnClick:self sender:sender param:bi.param execType:bi.execType];
    }
}

-(void)exit_click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleExitClick)])
    {
        [self.delegate onTitleExitClick];
    }
}

-(void)titleLayoutClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleClick)])
    {
        [self.delegate onTitleClick];
    }
}

-(void)clearTitleBtn:(int)btnLoc
{
    if (btnLoc == TITLE_BTN_ALL)
    {
        [btnParamArray removeAllObjects];
        for (UIButton * btn in btnArray)
        {
            [btn removeFromSuperview];
        }
        btnCounter = 0;
    }else
    {
        UIView * content = (btnLoc == TITLE_BTN_LEF ? llLeft : llRight);
        for (NSInteger i = content.subviews.count - 1; i > -1; i--)
        {
            [btnParamArray removeObjectAtIndex:[btnArray indexOfObject:content.subviews[i]]];
            [content.subviews[i] removeFromSuperview];
        }
    }
}

@end
