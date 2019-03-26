//
//  XMPPXBReconnect.h
//  IMClient
//
//  Created by pengjay on 13-10-24.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "XMPPReconnect.h"
#import "Reachability.h"
@interface XMPPXBReconnect : XMPPReconnect
{
	Reachability *_xbReach;
}
@property (nonatomic) BOOL bReconnectWhenLogin;
@end
