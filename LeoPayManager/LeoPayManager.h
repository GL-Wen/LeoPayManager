//
//  LeoPayManager.h
//  Leo.Chen
//
//  Created by 陈仕军 on 16/12/19.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
#import "WechatAuthSDK.h"

#import <AlipaySDK/AlipaySDK.h>

/*
 respCode:
 0    -    支付成功
 -1   -    支付失败
 -2   -    支付取消
 -3   -    未安装App(适用于微信)
 -4   -    设备或系统不支持，或者用户未绑卡(适用于ApplePay)
 -99  -    未知错误
 */
typedef void (^LeoPayManagerRespBlock)(NSInteger respCode, NSString *respMsg);


/*
 ApplePay设备和系统支持状态
 */
typedef NS_ENUM(NSInteger, LeoApplePaySupportStatus)
{
    kLeoApplePaySupport,                    //完全支持
    kLeoApplePayDeviceOrVersionNotSupport,  //设备或系统不支持
    kLeoApplePaySupportNotBindCard,         //设备和系统支持，用户未绑卡
    kLeoApplePayUnknown                     //未知状态
};



@interface LeoPayManager : NSObject <WXApiDelegate>

+ (LeoPayManager *)getInstance;






//***************Apple Pay*****************//

/*
 Apple Pay支付结果回调
 */
@property (nonatomic, strong)LeoPayManagerRespBlock applePayRespBlock;

//***************微信*****************//

/*
 微信支付结果回调
 */
@property (nonatomic, strong)LeoPayManagerRespBlock wechatRespBlock;

/*
 检查是否安装微信
 */
+ (BOOL)isWXAppInstalled;

/*
 注册微信appId
 */
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId
                     universalLink:(NSString *)universalLink;


/*
 处理微信通过URL启动App时传递回来的数据
 */
+ (BOOL)wechatHandleOpenURL:(NSURL *)url;

/*
 发起微信支付
 */
- (void)wechatPayWithAppId:(NSString *)appId
                 partnerId:(NSString *)partnerId
                  prepayId:(NSString *)prepayId
                   package:(NSString *)package
                  nonceStr:(NSString *)nonceStr
                 timeStamp:(NSString *)timeStamp
                      sign:(NSString *)sign
                 respBlock:(LeoPayManagerRespBlock)block;








//***************支付宝*****************//

/*
 支付宝支付结果回调
 */
@property (nonatomic, strong)LeoPayManagerRespBlock alipayRespBlock;

/*
 处理支付宝通过URL启动App时传递回来的数据
 */
+ (BOOL)alipayHandleOpenURL:(NSURL *)url;

/*
  发起支付宝支付
 */
- (void)aliPayOrder:(NSString *)order
             scheme:(NSString *)scheme
          respBlock:(LeoPayManagerRespBlock)block;


@end
