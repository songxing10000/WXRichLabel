//
//  WXRichLabel.h
// dfpo
//
//  Created by mac on 2017/8/29.
//  Copyright © 2017年 dfpo. All rights reserved.
//

#import "WeexSDK.h"
/*
 AppDelegate+Weex里注册组件
 [WXSDKEngine registerComponent:@"richLabel" withClass:[WXRichLabel class]];
 
 <richLabel class="richLabel" @richClick="richClick" richData="[{'start':'0','end':'5','color':'#f45762'},{'start':'6','end':'10','color':'#f45762'}]" ></richLabel>
 
 
 .richLabel {
 margin-top: 30;
 margin-bottom: 30;
 border-width: 2px;
 border-style: solid;
 border-color: #41b883;
 width: auto;
 height: 100px;
 margin: 20px;
 padding: 10px;
 
 font-size: 28px;
 normalcolor: #2a2a2a;
 text: "我已阅读并同意《借款协议》《债权转让协议》《网络借贷风险和禁止性行为提示书》";
 linespacing: 16px;
 width: 690px;
 }
 
 richClick: function(e) {
 modal.toast({
 message: "" + e.start,
 duration: 1
 });
 }
 
 */
@interface WXRichLabel : WXComponent

@end
