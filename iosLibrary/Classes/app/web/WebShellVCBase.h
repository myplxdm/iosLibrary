//
//  WebShellBaseVC.h
//  iosLibrary
//
//  Created by liu on 2018/1/3.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAppVC.h"
#import "WebViewDelegate.h"

#pragma ------------------- 宏定义 -------------------
#define WS_CLOSE_RELOAD                 @"bCloseRelad"//当前关闭后，父窗体的web刷新
#define WS_CLOSE_PARENT_CLOSE_LEVEL     @"closeParentCloseLevel"//当前窗体关闭后父窗体多级一并关闭
#define WS_CLOSE_EXEC_JS                @"execJs"//当前关闭后，父窗体执行js
#define WS_TITLE                        @"wct"
#define WS_URL                          @"wcurl"
#define WS_TITLE_LOCATION               @"titleLoc"
#define WS_SHOW_RETURN                  @"bShowReturn"

#pragma ------------------- 前置声明 -------------------
@protocol IWebPlugin;
@protocol ITitleView;
@class UIWebViewEx;
@class LTitleView;
@class WebPluginBase;

#pragma ------------------- web外壳接口声明 ----------------
@protocol IWebShell<NSObject>

-(void)openUrl:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn titleLocation:(NSUInteger)tl bNextSelfClose:(BOOL)bNextSelfClose;
-(void)closeWindowWithLevel:(NSInteger)level bCloseReload:(BOOL)bCloseReload closeExecJs:(NSString *)js;
-(BaseAppVC *)getVC;
-(Class)getVCClass;
-(id<IWebPlugin>)getWebPluginWithName:(NSString *)name;
-(void)runJScript:(NSString *)js;
-(void)execPluginWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb;
-(id<IWebView>)getWebView;
-(id<ITitleView>)getTitleView;
-(void)jsCallWithFunName:(NSString *)name param:(NSObject *)param;
-(void)pluginCallbackWithFunName:(NSString *)name param:(NSObject *)param;
-(NSString *)getTitleViewReturnBtn;

@end

#pragma ------------------- web外壳基础类 -----------------------
@interface WebShellVCBase : BaseAppVC<IWebShell>

@property(readonly, nonatomic) LTitleView                     * titleView;
@property(readonly, nonatomic) id<IWebView>                   webView;
@property(readonly, nonatomic) NSMutableArray<WebPluginBase *>* plugins;

+(void)openClass:(Class)cls url:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn titleLocation:(NSUInteger)tl isDirect:(BOOL)isDirect;
+(void)openClass:(Class)cls url:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn isDirect:(BOOL)isDirect;
+(void)openClass:(Class)cls url:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn;
-(NSString *)getTitleViewReturnBtn;
-(void)loadWebPlugin;
-(BOOL)isUseWKWebView;
-(BOOL)isCloseByReturnBtn;

@end
