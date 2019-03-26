//
//  QMChatRoomTextCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomTextCell.h"
#import "QMChatRoomRobotReplyView.h"
#import <QMChatSDK/QMChatSDK.h>

/**
    文本消息
 */
@interface QMChatRoomTextCell() <MLEmojiLabelDelegate>

@end

@implementation QMChatRoomTextCell
{
    MLEmojiLabel *_textLabel;
    
    NSString *_messageId;
    
    QMChatRoomRobotReplyView *_replyView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {    
    _textLabel = [MLEmojiLabel new];
    _textLabel.numberOfLines = 0;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _textLabel.delegate = self;
    _textLabel.disableEmoji = NO;
    _textLabel.disableThreeCommon = NO;
    _textLabel.isNeedAtAndPoundSign = YES;
    _textLabel.customEmojiRegex = @"\\:[^\\:]+\\:";
    _textLabel.customEmojiPlistName = @"expressionImage.plist";
    _textLabel.customEmojiBundleName = @"QMEmoticon.bundle";
    [self.chatBackgroudImage addSubview:_textLabel];
    
    _replyView = [[QMChatRoomRobotReplyView alloc] init];
    _replyView.backgroundColor = [UIColor clearColor];
    [_replyView.helpBtn addTarget:self action:@selector(helpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_replyView.noHelpBtn addTarget:self action:@selector(noHelpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatBackgroudImage addSubview:_replyView];
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTapGesture:)];
    [_textLabel addGestureRecognizer:longPressGesture];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    _messageId = message._id;
    [super setData:message avater:avater];
            
    if ([message.fromType isEqualToString:@"0"]) {
        [_replyView setHidden:YES];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.text = message.message;
        CGSize size = [_textLabel preferredSizeWithMaxWidth: [UIScreen mainScreen].bounds.size.width - 160];
        _textLabel.frame = CGRectMake(15, 10, size.width, size.height+5);
        
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMinX(self.iconImage.frame)-5-_textLabel.frame.size.width-30, CGRectGetMaxY(self.timeLabel.frame)+10, _textLabel.frame.size.width+30, _textLabel.frame.size.height+20);
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(self.chatBackgroudImage.frame)-25, CGRectGetMinY(self.chatBackgroudImage.frame)+10, 20, 20);
    }else {
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.text = message.message;
        CGSize size = [_textLabel preferredSizeWithMaxWidth: [UIScreen mainScreen].bounds.size.width - 160];
        
        _textLabel.frame = CGRectMake(15, 10, size.width, size.height+5);
        if ([message.isRobot isEqualToString:@"1"] && ![message.questionId isEqualToString:@""]) {
            // 判断是否评价过
            [_replyView setHidden:NO];
            if (message.isUseful) {
                _replyView.status = message.isUseful;
                if ([message.isUseful isEqualToString:@"none"]) {
                    _replyView.frame = CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 150, 25);
                    self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, _textLabel.frame.size.height+20 + 30);
                }else {
                    _replyView.frame = CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 150, 55);
                    self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, _textLabel.frame.size.height+20 + 60);
                }
            }else {
                _replyView.status = @"none";
                _replyView.frame = CGRectMake(10, CGRectGetMaxY(_textLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 150, 25);
                self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, _textLabel.frame.size.height+20 + 30);
            }
        }else {
            [_replyView setHidden:YES];
            _replyView.frame = CGRectZero;
            self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, _textLabel.frame.size.width+30, _textLabel.frame.size.height+20);
        }
    }
}

- (void)longPressTapGesture:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *copyMenu = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenu:)];
        UIMenuItem *removeMenu = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(removeMenu:)];
        [menu setMenuItems:[NSArray arrayWithObjects:copyMenu,removeMenu, nil]];
        [menu setTargetRect:self.chatBackgroudImage.frame inView:self];
        [menu setMenuVisible:true animated:true];
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if ([window isKeyWindow] == NO) {
            [window becomeKeyWindow];
            [window makeKeyAndVisible];
        }
    }
}

- (void)helpBtnAction: (UIButton *)sender {
    NSLog(@"帮助点击");
    self.didBtnAction(YES);

}

- (void)noHelpBtnAction: (UIButton *)sender {
    NSLog(@"没有帮助点击");
    self.didBtnAction(NO);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyMenu:) || action == @selector(removeMenu:)) {
        return YES;
    }else {
        return  NO;
    }
}

- (void)copyMenu:(id)sender {
    // 复制文本消息
    UIPasteboard *pasteBoard =  [UIPasteboard generalPasteboard];
    pasteBoard.string = _textLabel.text;
}

- (void)removeMenu:(id)sender {
    // 删除文本消息
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"进行此操作将删除此消息且不能恢复，是否执行删除" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [QMConnect removeDataFromDataBase:_messageId];
        [[NSNotificationCenter defaultCenter] postNotificationName:CHATMSG_RELOAD object:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type {
    NSString *newLink = [link stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray *array = [newLink componentsSeparatedByString:@"："];
    if (array.count > 1) {
        self.tapSendMessage(array[0]);
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
