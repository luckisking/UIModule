//
//  DXLiveNetworkView.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/9.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveNetworkViewDelegate <NSObject>

- (void)didSelectNetworkButtonTag:(NSInteger)tag index:(NSInteger)index;

@end

@interface DXLiveNetworkView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id <LiveNetworkViewDelegate> delegate;

@end
