//
//  LeoPayManager.m
//  Leo.Chen
//
//  Created by 陈仕军 on 16/12/19.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import "LeoPayManager.h"

@implementation LeoPayManager

+ (LeoPayManager *)getInstance
{
    static LeoPayManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[LeoPayManager alloc] init];
        
    });
    
    return instance;
}

//微信
+ (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId universalLink:(NSString *)universalLink;
{
    return [WXApi registerApp:appId universalLink:universalLink];
}
+ (BOOL)wechatHandleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[LeoPayManager getInstance]];
}
- (void)wechatPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign respBlock:(LeoPayManagerRespBlock)block
{
    self.wechatRespBlock = block;
    
    if([WXApi isWXAppInstalled])
    {
        PayReq *req = [[PayReq alloc] init];
        req.openID = appId;
        req.partnerId = partnerId;
        req.prepayId = prepayId;
        req.package = package;
        req.nonceStr = nonceStr;
        req.timeStamp = (UInt32)timeStamp.integerValue;
        req.sign = sign;
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
    }
    else
    {
        if(self.wechatRespBlock)
        {
            self.wechatRespBlock(-3, @"未安装微信");
        }
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case 0:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(0, @"支付成功");
                }
                
                NSLog(@"支付成功");
                break;
            }
            case -1:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-1, @"支付失败");
                }
                
                NSLog(@"支付失败");
                break;
            }
            case -2:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-2, @"支付取消");
                }
                
                NSLog(@"支付取消");
                break;
            }
                
            default:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-99, @"未知错误");
                }
            }
                break;
        }
    }
}
//微信






//支付宝
+ (BOOL)alipayHandleOpenURL:(NSURL *)url
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        LeoPayManager *manager = [LeoPayManager getInstance];
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-99, @"未知错误");
            }
        }
        
    }];
    
    return YES;
}
- (void)aliPayOrder:(NSString *)order scheme:(NSString *)scheme respBlock:(LeoPayManagerRespBlock)block
{
    self.alipayRespBlock = block;
    
    __weak __typeof(&*self)ws = self;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-99, @"未知错误");
            }
        }
        
    }];
}
//支付宝

@end
