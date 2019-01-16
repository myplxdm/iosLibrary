//
//  WebWindowPlugin.m
//  iosLibrary
//
//  Created by liu on 2018/1/18.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebWindowPlugin.h"
#import "LTitleView.h"
#import "WebShellVCBase.h"
#import "NSString+NSStringHelper.h"
#import "UIWebViewEx.h"
#import <YYModel.h>
#import "toolMacro.h"

@implementation WebWindowPlugin

-(BOOL)execWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    BOOL isProc = NO;
    if ([name isEqualToString:WND_TO_URL])
    {
        BOOL isShowReturn = SAFE_DICT_BOOL(param, WS_SHOW_RETURN, YES);
        NSString * url = SAFESTR(param[WS_URL]);
        NSString * title = SAFESTR(param[WS_TITLE]);
        NSInteger tvl = SAFE_DICT_INT(param, WS_TITLE_LOCATION, TVL_MIDDLE);
        NSInteger cl = SAFE_DICT_INT(param, WS_CLOSE_PARENT_CLOSE_LEVEL, 0);
        BOOL bReload = SAFE_DICT_BOOL(param, WS_CLOSE_RELOAD, NO);
        NSString * js = SAFESTR(param[WS_CLOSE_EXEC_JS]);

        [self.shell openUrl:url title:title bShowReturn:isShowReturn titleLocation:tvl closeLevel:cl bCloseReload:bReload closeExecJs:js];
        isProc = YES;
    }else if ([name isEqualToString:WND_EXIT_TO] || [name isEqualToString:WND_CLOSE_WINDOW])
    {
        NSInteger cl = SAFE_DICT_INT(param, P_EXIT_NUM, 1);
        BOOL bReload = SAFE_DICT_BOOL(param, P_CLOSE_RELOAD, NO);
        NSString * js = SAFESTR(param[P_CLOSE_EXEC_JS]);
        [self.shell closeWindowWithLevel:cl bCloseReload:bReload closeExecJs:js];
        isProc = YES;
    }
    isProc = isProc || !([self execOtherWithFunName:name param:param callback:cb] == EXEC_OTHER_NO_PROC);
    return [self procCallback:cb isProc:isProc alias:param[P_ALIAS]];
}

-(BOOL)vcResultData:(NSDictionary *)data
{
    if ([data[WS_CLOSE_RELOAD] boolValue])
    {
        [[self.shell getWebView] reload];
    }
    NSString * js = data[WS_CLOSE_EXEC_JS];
    if (js.length > 0)
    {
        [self.shell execJScript:js];
    }
    return NO;
}

@end