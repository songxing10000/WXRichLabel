# WXRichLabel
Weex 富文本 Weex协议 Weex链接 WXRichLabel Weex Label点击事件



使用方法
iOS端
```objc
// AppDelegate+Weex里注册组件
[WXSDKEngine registerComponent:@"richLabel" withClass:[WXRichLabel class]];
```
weex端
```js
// 画出你想要的UI
<richLabel class="richLabel" @richClick="richClick" richData="[{'start':'0','end':'5','color':'#f45762'},{'start':'6','end':'10','color':'#f45762'}]" ></richLabel>


// richLabel的点击事件
richClick: function(e) {
    modal.toast({
        message: "" + e.start, e.end, e.color, e.text,
        duration: 1
    });
}
```
```css
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

```

# https://www.jianshu.com/p/cef69801b28a
