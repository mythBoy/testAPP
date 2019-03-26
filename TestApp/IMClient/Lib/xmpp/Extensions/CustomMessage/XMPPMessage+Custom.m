//
//  XMPPMessage+Custom.m
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import "XMPPMessage+Custom.h"

IM_FIX_CATEGORY_BUG(XMPPMesssage_Custom)
@implementation XMPPMessage (Custom)

+ (IMMsgType)getImMsgType:(NSString *)xmppMsgType
{
	IMMsgType type = IMMsgTypeText;
	if ([xmppMsgType isEqualToString:XMPPMessageTypeNormal]) {
		type = IMMsgTypeText;
	}
	else if ([xmppMsgType isEqualToString:XMPPMessageTypeVoiceFileLink]) {
		type = IMMsgTypeAudio;
	}
	else if ([xmppMsgType isEqualToString:XMPPMessageTypePicFileLink]) {
		type = IMMsgTypePic;
	}
	else if ([xmppMsgType isEqualToString:XMPPMessageTypeAction]) {
		type = IMMsgTypeText;
	}
	else if ([xmppMsgType isEqualToString:XMPPMessageTypeFileLink]) {
		type = IMMsgTypeFile;
	}
	else if ([xmppMsgType isEqualToString:XMPPMessageTypeVideoLink]) {
		type = IMMsgTypeVideo;
	} else if ([xmppMsgType isEqualToString:XMPPMessageTypeLocationLink]) {
		type = IMMsgTypeLocatioin;
	} else if ([xmppMsgType isEqualToString:XMPPMessageTypeGiftLink]) {
		type = IMMsgTypeGift;
	} else if ([xmppMsgType isEqualToString:XMPPMessageTypeDisCountLink]) {
        type = IMMsgTypeDiscount;
    } else if ([xmppMsgType isEqualToString:XMPPMessageTypeImageTextLink]) {
        type = IMMsgTypeImageText;
    }else if ([xmppMsgType isEqualToString:XMPPMessageTypeCard]) {
        type = IMMsgTypeCard;
    }else if ([xmppMsgType isEqualToString:XMPPMessageTypeGolden]){
        type = IMMsgTypeGolden;
    }else if([xmppMsgType isEqualToString:XMPPMessageTypeBastard]){
        type = IMMsgTypeBastard;
    }else if([xmppMsgType isEqualToString:XMPPMessageTypeImageTextShareLink]){
        type = IMMsgTypeImageText;
    }else if([xmppMsgType isEqualToString:XMPPMessageTypeWebFileLink]){
        type = IMMsgTypeWebFile;
    }else if ([xmppMsgType isEqualToString:XMPPMessageTypeProductLink]){
        type = IMMsgTypeShangQuan;
    }
     // 红涛 增加 gif动态图片 类型
    else if ([xmppMsgType isEqualToString:XMPPMessageTypeGifImageName])
    {
        type = IMMsgTypeGifImage;
    }
    
    return type;
}


+ (NSString *)getXMPPMsgTypeStr:(IMMsgType)msgType
{
	NSString *xmppMsgType = XMPPMessageTypeNormal;
	if (msgType == IMMsgTypeAudio) {
		xmppMsgType = XMPPMessageTypeVoiceFileLink;
	}
	else if (msgType == IMMsgTypePic) {
		xmppMsgType = XMPPMessageTypePicFileLink;
	} else if (msgType == IMMsgTypeFile)
		xmppMsgType = XMPPMessageTypeFileLink;
	else if (msgType == IMMsgTypeVideo)
		xmppMsgType = XMPPMessageTypeVideoLink;
	else if (msgType == IMMsgTypeLocatioin)
		xmppMsgType = XMPPMessageTypeLocationLink;
	else if (msgType == IMMsgTypeGift)
		xmppMsgType = XMPPMessageTypeGiftLink;
    else if (msgType == IMMsgTypeImageText)
        xmppMsgType = XMPPMessageTypeImageTextLink;
    else if (msgType == IMMsgTypeCard)
        xmppMsgType = XMPPMessageTypeCard;
    else if (msgType == IMMsgTypeGolden)
        xmppMsgType = XMPPMessageTypeGolden;
    else if (msgType == IMMsgTypeBastard)
        xmppMsgType = XMPPMessageTypeBastard;
    else if (msgType == IMMsgTypeWebFile)
        xmppMsgType = XMPPMessageTypeWebFileLink;
    // 红涛 增加 gif动态图片 类型
    else if (msgType == IMMsgTypeGifImage)
        xmppMsgType = XMPPMessageTypeGifImageName;
    else if (msgType == IMMsgTypeShangQuan)
        xmppMsgType = XMPPMessageTypeProductLink;
    
	return xmppMsgType;
}
@end
