//
//  WXRichLabel.m
// dfpo
//
//  Created by mac on 2017/8/29.
//  Copyright © 2017年 dfpo. All rights reserved.
//

#import "WXRichLabel.h"
#import "TTTAttributedLabel.h"
@interface WXRichLabel()<TTTAttributedLabelDelegate>

@property (weak, nonatomic)  TTTAttributedLabel *attributedLabel;

@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) UIColor *normalColor;
@property(nonatomic, assign) CGFloat lineSpacing;
@property(nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *richDatas;
@property(nonatomic, strong) UIFont *font;
@end
@implementation WXRichLabel
- (CGFloat)getValue:(id)DictValue {
    
    return [WXConvert WXPixelType:DictValue scaleFactor:self.weexInstance.pixelScaleFactor];
}
-(instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    if(self= [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]){
        
        
        if (styles[@"lineSpacing"]) {
            _lineSpacing = [self  getValue:styles[@"lineSpacing"]];
        }
        if (styles[@"linespacing"]) {
            _lineSpacing = [self  getValue:styles[@"linespacing"]];
        }
        if (styles[@"normalColor"]) {
            _normalColor = [WXConvert UIColor:styles[@"normalColor"]];
        }
        if (styles[@"normalcolor"]) {
            _normalColor = [WXConvert UIColor:styles[@"normalcolor"]];
        }
        if (styles[@"fontSize"]) {
            
            _font = [UIFont systemFontOfSize:[self  getValue:styles[@"fontSize"]]];
        }
        if (styles[@"fontsize"]) {
            
            _font = [UIFont systemFontOfSize:[self  getValue:styles[@"fontsize"]]];
        }
        if (styles[@"font-size"]) {
            
            _font = [UIFont systemFontOfSize:[self getValue:styles[@"font-size"]]];
        }
        if (styles[@"text"]) {
            _text = [WXConvert NSString:styles[@"text"]];
        }
        if (attributes[@"richData"]) {
            @autoreleasepool {
                
                
                //     richData = "[{'start':0,'end':5,'color':'#f45762'},{'start':6,'end':10,'color':'#f45762'}]";
                NSString *json = attributes[@"richData"];
                // 将没有双引号的替换成有双引号的
                NSString *validString = [json stringByReplacingOccurrencesOfString:@"(\\w+)\\s*:([^A-Za-z0-9_])"
                                                                        withString:@"\"$1\":$2"
                                                                           options:NSRegularExpressionSearch
                                                                             range:NSMakeRange(0, [json length])];
                //把'单引号改为双引号"
                validString = [validString stringByReplacingOccurrencesOfString:@"([:\\[,\\{])'"
                                                                     withString:@"$1\""
                                                                        options:NSRegularExpressionSearch
                                                                          range:NSMakeRange(0, [validString length])];
                validString = [validString stringByReplacingOccurrencesOfString:@"'([:\\],\\}])"
                                                                     withString:@"\"$1"
                                                                        options:NSRegularExpressionSearch
                                                                          range:NSMakeRange(0, [validString length])];
                
                //再重复一次 将没有双引号的替换成有双引号的
                validString = [validString stringByReplacingOccurrencesOfString:@"([:\\[,\\{])(\\w+)\\s*:"
                                                                     withString:@"$1\"$2\":"
                                                                        options:NSRegularExpressionSearch
                                                                          range:NSMakeRange(0, [validString length])];
                if (validString && [validString isKindOfClass:[NSString class]] && validString.length) {
                    NSData* data = [validString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error = nil;
                    NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    
                    
                    if (error || !values || values.count < 1) {
                        WXLogError(@"attributes[@\"richData\"]里的值：%@  不能转换成数组!!",json);
                    } else {
                        _richDatas = values;
                    }
                }
            }
        }
        
    }
    return self;
}

- (UIView *)loadView {
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.attributedLabel = label;
    
    return label;
}
-(void)viewDidLoad {
    
    self.attributedLabel.delegate = self;
    CGFloat defaultTextFont = 14;
    NSString *defaultText = @"WXRichLable";
    
    NSString *text = _text && _text.length && ![self isEmpty:_text]?_text:defaultText;
    TTTAttributedLabel *label = self.attributedLabel;
    label.textColor = _normalColor?:[UIColor colorWithHexString:@"0x888888"];
    label.numberOfLines   = 0;
    label.font            = _font?:[UIFont systemFontOfSize:defaultTextFont];
    if (_lineSpacing > 0) {
        
        label.lineSpacing = _lineSpacing;
    }
    label.lineBreakMode   = NSLineBreakByWordWrapping;
    label.text = text;
    
    
    [self.attributedLabel setText:_text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        
        
        NSRange normalGrayRang1= NSMakeRange(0, _text.length);
        UIFont *defaultFont = _font;
        CTFontRef defaultFontRef = CTFontCreateWithName((__bridge CFStringRef)defaultFont.fontName, defaultFont.pointSize, NULL);
        
        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)defaultFontRef range:normalGrayRang1];
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[_normalColor CGColor] range:normalGrayRang1];
        
        CFRelease(defaultFontRef);
        
        if (_lineSpacing > 0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:_lineSpacing];
            [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_text length])];
        }
        
        return mutableAttributedString;
    }];
    /*
     [
     {
     "start": "0",
     "end": "5",
     "color": "#f45762"
     },
     {
     "start": "6",
     "end": "10",
     "color": "#f45762"
     }
     ]
     */
    if (self.richDatas &&
        self.richDatas.count > 0 &&
        self.richDatas[0][@"color"] &&
        [WXConvert UIColor:self.richDatas[0][@"color"]] &&
        [[WXConvert UIColor:self.richDatas[0][@"color"]] isKindOfClass:[UIColor class]]) {
        
        UIColor *linkColor = [WXConvert UIColor: self.richDatas[0][@"color"]];
        NSDictionary *dict = @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleNone],
                               (NSString *)kCTForegroundColorAttributeName : (__bridge id)[linkColor CGColor]};
        self.attributedLabel.linkAttributes = dict;
        self.attributedLabel.activeLinkAttributes = dict;
    }
    
    
    [self.richDatas enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull richDic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (richDic[@"start"] && richDic[@"end"] && richDic[@"color"]) {
            
            NSUInteger start = [WXConvert NSUInteger:richDic[@"start"]];
            NSUInteger end = [WXConvert NSUInteger:richDic[@"end"]];
            UIColor *specialColor = [WXConvert UIColor:richDic[@"color"]];
            if (end - start > 0 && specialColor) {
                NSRange specialRang = NSMakeRange(start, end - start);
                if (specialRang.location != NSNotFound) {
                    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:richDic];
                    NSString *specialText = [_text substringWithRange:specialRang];
                    if (specialText && specialText.length) {
                        infoDict[@"text"] = specialText;
                    }
                    [self.attributedLabel addLinkToTransitInformation:infoDict
                                                            withRange:specialRang];
                }
                
            }
        }
    }];
    
    
    
    [self.attributedLabel sizeToFit];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    
    [self fireEvent:@"richClick" params:components];
}
/// 是否为空或者是空格
- (BOOL)isEmpty:(NSString *)string ///< 是否为空或者是空格
{
    
    NSString * newSelf = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(nil == string
       || string.length ==0
       || [string isEqualToString:@""]
       || [string isEqualToString:@"<null>"]
       || [string isEqualToString:@"(null)"]
       || [string isEqualToString:@"null"]
       || newSelf.length ==0
       || [newSelf isEqualToString:@""]
       || [newSelf isEqualToString:@"<null>"]
       || [newSelf isEqualToString:@"(null)"]
       || [newSelf isEqualToString:@"null"]
       || [string isKindOfClass:[NSNull class]] ){
        
        return YES;
        
    }else{
        // <object returned empty description> 会来这里
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        
        return [trimedString isEqualToString: @""];
    }
    
    return NO;
}

@end


