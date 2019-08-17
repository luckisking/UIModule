//
//  DXLiveViewController+Gensee.h
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/7.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLiveViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXLiveViewController (Gensee)<GSBroadcastRoomDelegate, GSBroadcastVideoDelegate, GSBroadcastAudioDelegate, GSBroadcastDocumentDelegate, GSDocViewDelegate, GSBroadcastDesktopShareDelegate, GSBroadcastChatDelegate,GSBroadcastInvestigationDelegate>
/*
 *gensee 附加功能---->实现了问卷和聊天 ，网络切换
 */
@end

NS_ASSUME_NONNULL_END
