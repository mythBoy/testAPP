//
//  IMMsgQueue.m
//  IMClient
//
//  Created by pengjay on 13-7-11.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMMsgQueue.h"
#import "DDLog.h"
#import "IMPrvChatAudioPlayLogicHandler.h"
#import "IMRoomAudioPlayLogicHandler.h"
#import "IMUserManager.h"
@interface NSDate (XMPP)
- (BOOL)isSameDayAsDate:(NSDate *)dt;
@end

@implementation NSDate (XMPP)
- (NSDateComponents *)dateComponents {
    NSCalendarUnit calendarUnit =
    NSEraCalendarUnit |
    NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit |
    NSWeekCalendarUnit |
    NSWeekdayCalendarUnit |
    NSWeekdayOrdinalCalendarUnit |
    NSQuarterCalendarUnit |
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    NSWeekOfMonthCalendarUnit |
    NSWeekOfYearCalendarUnit |
    NSYearForWeekOfYearCalendarUnit |
#endif
    NSCalendarCalendarUnit |
    NSTimeZoneCalendarUnit;
    return [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
}


- (BOOL)isSameDayAsDate:(NSDate *)dt {
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [dt dateComponents];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]) &&
            ([components1 day] == [components2 day]));
}
@end

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif


#define HISTROYNUM 20
#define GROUP_SEC 60 * 20


@implementation IMMsgQueue
@synthesize fromUser = _fromUser;
@synthesize audioMgr = _audioMgr;


- (instancetype)initWithUser:(IMUser *)user msgStorage:(IMMsgStorage *)msgStorage queue:(dispatch_queue_t)queue
                   audioMode:(IMMsgQueueAudioMode)mode groupFlag:(BOOL)groupFlag
{
    self = [super init];
    if (self) {
        _fromUser = user;
        //		_audioMgr = audioHandler;
        _audioMode = mode;
        _msgStorage = msgStorage;
        _displayArray = [NSMutableArray array];
        _groupByTime = groupFlag;
        if (queue) {
            _mqueue = queue;
#if !OS_OBJECT_USE_OBJC
            dispatch_retain(_mqueue);
#endif
        }
        else {
            const char *name = [NSStringFromClass([self class]) UTF8String];
            _mqueue = dispatch_queue_create(name, NULL);
        }
        
        _mqueueTag = &_mqueueTag;
        dispatch_queue_set_specific(_mqueue, _mqueueTag, _mqueueTag, NULL);
        
        
        /////////////////////////////////////////
        [self loadRecentHistoryMsgs];
        
    }
    return self;
}


- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_mqueue);
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initAuidoPlayLogicHander
{
    if (_audioMode == IMMsgQueueAudioModeOne) {
        _audioMgr = [[IMBaseAudioPlayLogicHandler alloc]initWithQueue:_mqueue];
    }
    else if (_audioMode == IMMsgQueueAudioModePrvChat) {
        _audioMgr = [[IMPrvChatAudioPlayLogicHandler alloc]initWithQueue:_mqueue];
    }
    else {
        _audioMgr = [[IMRoomAudioPlayLogicHandler alloc]initWithQueue:_mqueue];
    }
    
    _audioMgr.dataSource = self;
    
    //auto play unplayed msg
    if (_audioMode == IMMsgQueueAudioModeRoomChat) {
        IMAudioMsg *msg = [self findUnplayAudioMsgFromIdx:0];
        if (msg) {
            [_audioMgr selectMsg:msg];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addGroupLabel:(IMMsg *)msg
{
    if (_groupTime == nil) {
        _groupTime = msg.msgTime;
        if (_groupTime) {
            [_displayArray addObject:_groupTime];
        }
    }
    else {
        //for xh
        
        //		if (![msg.msgTime isSameDayAsDate:_groupTime]) {
        
        
        if ([msg.msgTime timeIntervalSince1970] - [_groupTime timeIntervalSince1970] > GROUP_SEC) {
            _groupTime = msg.msgTime;
            if (_groupTime) {
                [_displayArray addObject:_groupTime];
            }
        }
        
    }
}

- (void)loadRecentHistoryMsgs
{
    dispatch_block_t block = ^{
        NSMutableArray *hisArray = [_msgStorage getUserLastMsg:_fromUser count:HISTROYNUM];
        if (hisArray.count < HISTROYNUM) {
            _hasMoreHistroy = NO;
        }
        else
            _hasMoreHistroy = YES;
        
        for (IMMsg *msg  in hisArray) {
            if (_groupByTime) {
                [self addGroupLabel:msg];
            }
            
            [_displayArray addObject:msg];
        }
        
        [self initAuidoPlayLogicHander];
        
        DDLogVerbose(@"[load rectnet histroy][%d]", _displayArray.count);
        //		dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(immsgQueue:didChanged:)]) {
            [self.delegate immsgQueue:self didChanged:[NSArray arrayWithArray:_displayArray]];
        }
        //		});
        
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_async(_mqueue, block);
}

#pragma mark   有新消息时候此处会从服务器同步下来最后20条数据插到本地历史记录中
- (void)addToHistoryData:(NSArray *)array
{
    NSMutableArray *hisArray = [_msgStorage getUserLastMsg:_fromUser count:HISTROYNUM];
    
    
    NSMutableArray *delArr = [NSMutableArray array];
    for (int i =0; i<array.count; i++) {
        id obj = array[i];
        
        if ([obj isKindOfClass:[NSDate class]]) {
            continue;
        }
        
        IMMsg *msg = (IMMsg *)obj;
        
        for (IMMsg *localMsg in hisArray) {
            if ([localMsg.msgID isEqualToString:msg.msgID]) {
                [delArr addObject:localMsg];
            }
        }
        
    }
    
    for (IMMsg *localMsg in delArr) {
        [_msgStorage delMsg:localMsg];
    }
    for (int i = 0; i<array.count; i++) {
        IMMsg *msg = (IMMsg *)array[i];
        if (![msg isKindOfClass:[NSDate class]]) {
            [_msgStorage saveMsg:msg];
        }
        
    }
    
    
    
    [_displayArray removeAllObjects];
    [self loadRecentHistoryMsgs];
    
}

-(void)addServiceTip:(IMMsg *)msg
{
    [_displayArray addObject:msg];
}
-(void)delServiceTip:(IMMsg *)msg
{
    [_displayArray removeObject:msg];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)msgArray
{
    __block NSArray *retArray = nil;
    //displayArray 里的原始数据在清除缓存的时候不会发生变化，这里做下判断，数据库没数据后就把_displayArray数据清除 add by sg
    NSMutableArray *hisArray = [_msgStorage getUserLastMsg:_fromUser count:HISTROYNUM];
    if (hisArray.count == 0) {
        [_displayArray removeAllObjects];
    }
    
    if (dispatch_get_specific(_mqueueTag))
        retArray = _displayArray;
    else {
        dispatch_sync(_mqueue, ^{
            retArray = [_displayArray copy];
        });
    }
    return retArray;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)msgPicArray{
    __block NSArray *retArray = nil;
    NSMutableArray *picArray = [_msgStorage getUserPicMsg:_fromUser];
    retArray = [picArray copy];
    return retArray;
}


#pragma mark - Histroy
- (NSString *)getFirstMsgId
{
    __block IMMsg *msg = nil;
    dispatch_block_t block = ^{
        for(id obj in _displayArray)
        {
            if([obj isKindOfClass:[IMMsg class]])
            {
                msg = (IMMsg *)obj;
                break;
            }
        }
    };
    if (dispatch_get_specific(_mqueueTag))
        block();
    else {
        dispatch_sync(_mqueue, block);
    }
    return msg.msgID;
}

- (BOOL)beginLoadHistroy
{
    NSString *msgid = [self getFirstMsgId];
    if (!msgid) {
        [self loadRecentHistoryMsgs];
        if ([self.delegate respondsToSelector:@selector(immsgQueuemsgQueuedidLoadHistoryOver)]) {
            [self.delegate immsgQueuemsgQueuedidLoadHistoryOver];
        }    }
    if(msgid == nil)
        return NO;
    dispatch_block_t block = ^{
        NSMutableArray *tmpArray = [_msgStorage getUserOlderMsg:_fromUser msgid:msgid count:HISTROYNUM];
        if (tmpArray.count < HISTROYNUM)
            _hasMoreHistroy = NO;
        else
            _hasMoreHistroy = YES;
        
        /////////add group label
        NSMutableArray *resultArray = [NSMutableArray array];
        if (_groupByTime) {
            NSDate *gpTime = nil;
            for (IMMsg *msg in tmpArray) {
                if (gpTime == nil) {
                    gpTime = msg.msgTime;
                    if (gpTime) {
                        [resultArray addObject:gpTime];
                    }
                }
                else {
                    if ([msg.msgTime timeIntervalSince1970] - [gpTime timeIntervalSince1970] > GROUP_SEC) {
                        gpTime = msg.msgTime;
                        if (gpTime) {
                            [resultArray addObject:gpTime];
                        }
                    }
                }
                
                [resultArray addObject:msg];
            }
        }
        else {
            [resultArray addObjectsFromArray:tmpArray];
        }
        
        ///////////////////////
        [_displayArray insertObjects:resultArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [resultArray count])]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(immsgQueue:didLoadHistory:)]) {
                [self.delegate immsgQueue:self didLoadHistory:resultArray];
            }
        });
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_async(_mqueue, block);
    
    
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IMAudioMsg *)findUnplayAudioMsgFromIdx:(NSInteger)index
{
    IMAudioMsg *ret = nil;
    for(int i = index; i < [_displayArray count]; i++)
    {
        id tmp = [_displayArray objectAtIndex:i];
        if([tmp isMemberOfClass:[IMAudioMsg class]])
        {
            IMAudioMsg *t = (IMAudioMsg *)tmp;
            if(t.playState == IMMsgPlayStateUnPlay && t.fromType == IMMsgFromOther)
            {
                ret = t;
                break;
            }
        }
    }
    DDLogCVerbose(@"find msg[%@]", ret);
    return ret;
}
#pragma mark - DataSource
- (IMAudioMsg *)imAudioPlayHandlerNextMsgFrom:(IMAudioMsg *)msg included:(BOOL)flag
{
    __block IMAudioMsg *ret = nil;
    dispatch_block_t block = ^{
        NSInteger n = [_displayArray indexOfObject:msg];
        if (n != NSNotFound) {
            if (flag == NO)
                n++;
            ret = [self findUnplayAudioMsgFromIdx:n];
            
        }
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_sync(_mqueue, block);
    
    return ret;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)deleteMsg:(IMMsg *)msg
{
    NSMutableArray *indexsArray = nil;
    NSInteger idx = [_displayArray indexOfObject:msg];
    NSInteger timeidx = NSNotFound;
    NSDate *lastTime;
    if (idx != NSNotFound) {
        indexsArray = [NSMutableArray array];
        [indexsArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
        
        //delete time group label if not more cell
        timeidx = idx - 1;
        NSInteger nextIdx = idx + 1;
        if (timeidx >= 0 && timeidx < [_displayArray count]) {
            id obj = [_displayArray objectAtIndex:timeidx];
            
            BOOL bMoreCell = YES;
            if (nextIdx >= [_displayArray count]) {
                bMoreCell = NO;
            } else {
                id nextObj = [_displayArray objectAtIndex:nextIdx];
                if ([nextObj isKindOfClass:[NSDate class]]) {
                    bMoreCell = NO;
                }
            }
            
            if ([obj isKindOfClass:[NSDate class]] && bMoreCell == NO) {
                lastTime = (NSDate *)obj;
                [indexsArray addObject:[NSIndexPath indexPathForRow:timeidx inSection:0]];
            } else {
                timeidx = NSNotFound;
            }
        }
    }
    
    if (idx != NSNotFound)
        [_displayArray removeObjectAtIndex:idx];
    if (timeidx != NSNotFound)
        [_displayArray removeObject:lastTime];
    
    if ([lastTime isEqual:_groupTime])
        _groupTime = nil;
    if ([msg isKindOfClass:[IMFileMsg class]]) {
        [((IMFileMsg *)msg) cancelProcessing];
    }
    
    if ([msg isMemberOfClass:[IMAudioMsg class]]) {
        [((IMAudioMsg *)msg) stopAudioPlay];
    }
    
    [_msgStorage delMsg:msg];
    
    //xmpp add by 杨扬  删除会话一条信息后更新微聊列表
    
    if (_displayArray.count>0) {
        if ([_displayArray[_displayArray.count-1] isKindOfClass:[IMMsg class]]) {
            IMMsg *upMsg = _displayArray[_displayArray.count-1];
            // [_msgStorage addChatSession:upMsg];
            [_msgStorage updateChatSession:upMsg];//王林 2015.9.22 删除会话时数据不添加
        }
    }else{
        
        if (!_hasMoreHistroy) {
            
            IMUser *imUser = msg.fromUser;
            [_msgStorage delChatSession:imUser];
        }
    }
    
    
    
    return indexsArray;
}

//add by 杨扬   后台删除敏感消息使用

- (NSArray *)deleteWithMsgID:(NSString *)msgID
{
    NSMutableArray *indexsArray = nil;
    
    
    for (IMMsg *msg in _displayArray) {
        if ([msg  isKindOfClass:[NSDate class]]) {
            continue;
        }
        if ([msg.msgID isEqualToString:msgID]) {
            
            NSInteger idx = [_displayArray indexOfObject:msg];
            NSInteger timeidx = NSNotFound;
            NSDate *lastTime;
            if (idx != NSNotFound) {
                indexsArray = [NSMutableArray array];
                [indexsArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                
                //delete time group label if not more cell
                timeidx = idx - 1;
                NSInteger nextIdx = idx + 1;
                if (timeidx >= 0 && timeidx < [_displayArray count]) {
                    id obj = [_displayArray objectAtIndex:timeidx];
                    
                    BOOL bMoreCell = YES;
                    if (nextIdx >= [_displayArray count]) {
                        bMoreCell = NO;
                    } else {
                        id nextObj = [_displayArray objectAtIndex:nextIdx];
                        if ([nextObj isKindOfClass:[NSDate class]]) {
                            bMoreCell = NO;
                        }
                    }
                    
                    if ([obj isKindOfClass:[NSDate class]] && bMoreCell == NO) {
                        lastTime = (NSDate *)obj;
                        [indexsArray addObject:[NSIndexPath indexPathForRow:timeidx inSection:0]];
                    } else {
                        timeidx = NSNotFound;
                    }
                }
            }
            
            if (idx != NSNotFound)
                [_displayArray removeObjectAtIndex:idx];
            if (timeidx != NSNotFound)
                [_displayArray removeObject:lastTime];
            
            if ([lastTime isEqual:_groupTime])
                _groupTime = nil;
            if ([msg isKindOfClass:[IMFileMsg class]]) {
                [((IMFileMsg *)msg) cancelProcessing];
            }
            
            if ([msg isMemberOfClass:[IMAudioMsg class]]) {
                [((IMAudioMsg *)msg) stopAudioPlay];
            }
            
            
            //xmpp add by 杨扬  删除会话一条信息后更新微聊列表
            
            if (_displayArray.count>0) {
                if ([_displayArray[_displayArray.count-1] isKindOfClass:[IMMsg class]]) {
                    IMMsg *upMsg = _displayArray[_displayArray.count-1];
                    // [_msgStorage addChatSession:upMsg];
                    [_msgStorage updateChatSession:upMsg];//王林 2015.9.22 删除会话时数据不添加
                }
            }else{
                IMUser *imUser = msg.fromUser;
                [_msgStorage delChatSession:imUser];
            }
            
            break;
            
        }
    }
    
    return indexsArray;
    
}



- (void)deleteMsgs:(NSArray *)delMsgs
{
    dispatch_block_t block = ^{
        NSMutableArray *array = [NSMutableArray array];
        for (IMMsg *msg in delMsgs) {
            [array addObjectsFromArray:[self deleteMsg:msg]];
        }
        if (array.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(immsgQueue:didRemoveIndexes:)]) {
                    [self.delegate immsgQueue:self didRemoveIndexes:array];
                }
            });
        }
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_async(_mqueue, block);
}

//add by 杨扬   后台删除敏感消息使用

- (void)deleteMsgID:(NSString *)msgID
{
    dispatch_block_t block = ^{
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:[self deleteWithMsgID:msgID]];
        if (array.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(immsgQueue:didRemoveIndexes:)]) {
                    [self.delegate immsgQueue:self didRemoveIndexes:array];
                }
            });
        }
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_async(_mqueue, block);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deliverMsg:(IMMsg *)msg
{
    if (!msg)
        return;
    DDLogVerbose(@"Queue delived:%@", msg.fromUser);
    dispatch_block_t block = ^{
        if (_groupByTime) {
            [self addGroupLabel:msg];
        }
        
        [_displayArray addObject:msg];
        
        if (msg.msgType == IMMsgTypeAudio) {
            [_audioMgr deliverMsg:msg];
        }
        
        //		dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(immsgQueue:didChanged:)]) {
            [self.delegate immsgQueue:self didChanged:nil];
        }
        //		});
        
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_sync(_mqueue, block);
}

- (void)selectMsg:(IMMsg *)msg
{
    [_audioMgr selectMsg:msg];
}

- (void)startAudioPlay
{
    [_audioMgr startAudioPlay];
}

- (void)stopAudioPlay
{
    [_audioMgr stopAudioPlay];
}

- (void)pauseAudioPlay
{
    [_audioMgr pauseAudioPlay];
}

- (void)resumAudioPlay
{
    [_audioMgr resumAudioPlay];
}

#pragma mark -
- (void)localMsgReaded:(NSString *)msgid
{
    dispatch_block_t block = ^{
        BOOL bContain = NO;
        int i = _displayArray.count - 1;
        for(;i >= 0; i--){
            id obj = [_displayArray objectAtIndex:i];
            if([obj isKindOfClass:[IMMsg class]]){
                IMMsg *msg = (IMMsg *)obj;
                
                if (bContain == NO && msg.fromType != IMMsgFromOther && ([msg.msgID isEqualToString:msgid] || msgid == nil)) {
                    bContain = YES;
                }
                
                if (bContain) {
                    if (msg.fromType != IMMsgFromOther) {
                        if (msg.readState == IMMsgReadStateReaded)
                            break;
                        if (msg.procState == IMMsgProcStateSuc) {
                            msg.readState = IMMsgReadStateReaded;
                        }
                    }
                    continue;
                }else{
                    //                    if (msg.fromType != IMMsgFromOther) {
                    //                        msg.procState = IMMsgProcStateFaied;
                    //                        msg.readState = IMMsgReadStateUnRead;
                    //                    }
                }
                
            }
        }
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_async(_mqueue, block);
}
#pragma mark 测试消息是否发送成功  add  by  杨扬
- (void)localMsgSendStatus:(NSString *)msgid blockHandler:(void(^)(id))handler

{
    _handler = handler;
    
    dispatch_block_t block = ^{
        

        
        
        
        int i = _displayArray.count - 1;
        for(;i >= 0; i--){
            id obj = [_displayArray objectAtIndex:i];
            if([obj isKindOfClass:[IMMsg class]]){
                IMMsg *msg = (IMMsg *)obj;
                
                if ([msg.msgID isEqualToString:msgid]) {
                    
                    if (msg.fromType != IMMsgFromOther) {
                        
                        msg.procState = IMMsgProcStateSuc;
                        
                        ((void(^)())_handler)(msg.fromUser);
                        
                        
                        break;
                    }
                    
                }else{
                    if (msgid) {
                        
                        NSDictionary *dic =   [_msgStorage getMsgMgrSessionCache];
                        NSArray *keys = [dic allKeys];
                        [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[NSString class]]) {
                                NSString *objS = obj;
                                if ( [objS containsString:msgid]) {
                                    NSMutableString *mStr = [objS mutableCopy];
                                    NSRange rang = [mStr rangeOfString:msgid];
                                    [mStr deleteCharactersInRange:rang];
                                    
                                    
                                    IMUserManager *mgr = [IMUserManager new];
                                    IMUser *fromU =  [mgr createCacheUserWithID:mStr usertype:IMUserTypeP2P];
                                    
                                    
                                    
                                    ((void(^)())_handler)(fromU);
                                    *stop = YES;
                                }
                                
                            }
                            
                        }];
                    }
                }
                
                
            }
        }
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_async(_mqueue, block);
}

- (void)clearAllMsg
{
    dispatch_block_t block = ^{
        [_audioMgr stopAudioPlay];
        [_displayArray removeAllObjects];
        _groupTime = nil;
        _hasMoreHistroy = NO;
        [_msgStorage clearChatSessionContent:_fromUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(immsgQueue:didChanged:)]) {
                [self.delegate immsgQueue:self didChanged:nil];
            }
        });
    };
    
    if (dispatch_get_specific(_mqueueTag))
        block();
    else
        dispatch_async(_mqueue, block);
}
@end
