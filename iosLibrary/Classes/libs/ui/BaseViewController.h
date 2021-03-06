//
//  BaseExViewController.h
//  test
//
//  Created by liu on 16/10/19.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VC_SHOW_PUSH            0
#define VC_SHOW_PRESENT         1
#define VC_SHOW_DIRECT          2
//
#define INIT_TIME_DID_LOAD      0x10
#define INIT_TIME_WILL_APPEAR   0x11
#define INIT_TIME_DID_APPEAR    0x12
#define INIT_TIME_LOAD_VIEW     0x13

@interface ShowInfo : NSObject

@property(strong,nonatomic) NSDictionary    * data;
@property(assign,nonatomic) BOOL            isReturnData;//是否有返回数据,因为返回与打开都是用同一个data带数据，所以要标识一下
@property(assign,nonatomic) NSUInteger      showType;
@property(assign,nonatomic) BOOL            isShowAnimated;
@property(assign,nonatomic) BOOL            isNextCloseSelfColse;//当下次窗体关闭时，本窗体一同关闭

@end

@protocol ViewControllerDelegate <NSObject>

-(void)setReturnData:(NSDictionary *)data;

@end

@interface BaseViewController : UIViewController<ViewControllerDelegate>

@property(weak,nonatomic) id<ViewControllerDelegate>    lasVCDelegate;
@property(strong,nonatomic) ShowInfo                    * showInfo;
//
-(void)lightStatusBar;
-(void)darkStatusBar;
//
-(BOOL)onInitViewTime:(NSUInteger)time;
-(void)onInitData:(NSDictionary *)data;
-(void)onUnInitView;
-(void)onVCResult:(NSDictionary *)data;
-(void)onWillEnter;
//
-(void)closeWindowVC;
-(void)closeWindowVCDelay:(int)sec;
-(void)closeWindowVCWithData:(NSDictionary *)data delay:(int)sec;
-(void)closeAnimated;
#pragma --------------------
-(void)showProgress:(float)progess title:(NSString *)title;
-(void)showDlgTitle:(NSString *)title;
-(void)dismissHUD;
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actNames:(NSArray<NSString *> *)actNames redActIndex:(NSInteger)rai clickAction:(void(^)(NSInteger index))clickAction;
-(void)showSheetTitle:(NSString *)title msg:(NSString *)msg sheets:(NSArray<NSString *> *)sheets redActIndex:(NSInteger)rai clickAction:(void(^)(NSInteger index))clickAction;
-(void)showInputTitle:(NSString *)title msg:(NSString *)msg placeholder:(NSString *)ph clickAction:(void(^)(NSString* text))clickAction;
-(NSString *)getTFTextWithViewTag:(NSInteger)tag;
-(void)setTFTextWithViewTag:(NSInteger)tag text:(NSString *)text;
-(NSString *)getLabTextWithViewTag:(NSInteger)tag ;
-(void)setLabTextWithViewTag:(NSInteger)tag text:(NSString *)text;
#pragma -------------------- 键盘
-(void)attemptKeyBoard;
-(void)attemptKeyBoardWithView:(UIView *)view;
-(void)retract;
-(CGFloat)onGetScorllHeightWithKBH:(CGFloat)kbh;
#pragma -------------------- 静态方法
+(BaseViewController *)getViewControllerByIndex:(NSInteger)index;
+(void)showPushClass:(Class)cls withVC:(BaseViewController *)vc data:(NSDictionary *)data;
+(void)showPushVC:(BaseViewController *)bvc withVC:(BaseViewController *)vc data:(NSDictionary *)data;
//present
+(void)showPresentClass:(Class)cls withVC:(BaseViewController *)vc data:(NSDictionary *)data;
+(void)showPresentVC:(BaseViewController *)bvc withVC:(BaseViewController *)vc data:(NSDictionary *)data;
//
+(void)showDirectClass:(Class)cls withVC:(BaseViewController *)vc data:(NSDictionary *)data;
+(void)showDirectVC:(BaseViewController *)bvc withVC:(BaseViewController *)vc data:(NSDictionary *)data;
//
+(void)showVCClass:(Class)cls showType:(NSUInteger)st isAnimated:(BOOL)anim withVC:(BaseViewController *)vc data:(NSDictionary *)data;
+(void)showVC:(BaseViewController *)bvc showType:(NSUInteger)st isAnimated:(BOOL)anim withVC:(BaseViewController *)vc data:(NSDictionary *)data;
+(void)exitToIndex:(NSUInteger)index data:(NSDictionary *)data;
+(void)popCount:(NSUInteger)count data:(NSDictionary *)data;
+(void)directPopVC:(BaseViewController *)vcPop;
//
+(BaseViewController *)getCurrVC;

@end
