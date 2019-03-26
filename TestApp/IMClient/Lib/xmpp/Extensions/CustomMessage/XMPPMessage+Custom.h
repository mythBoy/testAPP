//
//  XMPPMessage+Custom.h
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import "XMPPMessage.h"
#import "IMMsg.h"
#import "IMCoreMacros.h"

static NSString *const XMPPMessageTypeNormal = @"normal";
static NSString *const XMPPMessageTypeVoiceFileLink = @"vflink";
static NSString *const XMPPMessageTypePicFileLink = @"pflink";
static NSString *const XMPPMessageTypeAction = @"action";
static NSString *const XMPPMessageTypeFileLink = @"filelink";
static NSString *const XMPPMessageTypeVideoLink = @"videolink";
static NSString *const XMPPMessageTypeLocationLink = @"locationlink";
static NSString *const XMPPMessageTypeGiftLink = @"giftlink";
static NSString *const XMPPMessageTypeDisCountLink = @"discountlink";
static NSString *const XMPPMessageTypeImageTextLink = @"imagetextlink";
static NSString *const XMPPMessageTypeImageTextShareLink = @"imagetextsharelink";
static NSString *const XMPPMessageTypeCard = @"card";
static NSString *const XMPPMessageTypeGolden = @"golden";
static NSString *const XMPPMessageTypeBastard = @"bastard";
static NSString *const XMPPMessageTypeWebFileLink = @"cloudShare";
static NSString *const XMPPMessageTypeProductLink = @"ProductShare";

// 是否需要加入 类型 IMMsgTypeGifImage
static NSString *const XMPPMessageTypeGifImageName = @"gifImageName";


@interface XMPPMessage (Custom)
+ (IMMsgType)getImMsgType:(NSString *)xmppMsgType;
+ (NSString *)getXMPPMsgTypeStr:(IMMsgType)msgType;
@end
