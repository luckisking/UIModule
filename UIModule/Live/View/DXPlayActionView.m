//
//  DXPlayActionView.m
//  Doxuewang
//
//  Created by MBAChina-IOS on 16/10/13.
//  Copyright © 2016年 都学网. All rights reserved.
//

#import "DXPlayActionView.h"

@interface DXPlayActionView ()

@property (weak, nonatomic) IBOutlet UIImageView *statueIMG;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (assign,nonatomic) NSInteger wholeTime;

@end

@implementation DXPlayActionView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds= YES;
    
    self.timeLbl.layer.cornerRadius = 2.f;
    self.timeLbl.layer.masksToBounds= YES;
    
    self.backgroundColor = RGBAColor(76, 76, 76, 0.8f);
    //self.timeLbl.backgroundColor = RGBAColor(76, 76, 76, 0.8f);
}

- (void)setItemDuration:(NSInteger)duration{
    self.wholeTime = duration;
}


- (void)setActionStatue:(ActionState)action andSeekTime:(NSInteger)seekTime{
    
    switch (action) {
            
        case ActionStateBack:{
            self.statueIMG.image = IMG(@"SKBAction");
            self.timeLbl.text = [self playInfo:seekTime];
        }break;
        
        case ActionStateForward:{
            self.statueIMG.image = IMG(@"SKFAction");
            self.timeLbl.text = [self playInfo:seekTime];
        }break;
            
        case ActionStateCancle:{
            self.statueIMG.image = IMG(@"SKCAction");
            self.timeLbl.text = @"松手取消";
            self.timeLbl.backgroundColor = [UIColor redColor];
        }break;
        
        default:
            break;
    }
}

- (NSString *)playInfo:(NSInteger)seekTime{
    
    int allHours = (int)(self.wholeTime/3600);
    if (allHours) {
        
        int nowHours = (int)seekTime/3600;
        int nowMin = 0;
        int nowSec = 0;
        if (nowHours) {
            nowMin = (int)(seekTime%3600)/60;
            nowSec = (seekTime%3600)%60;
        }else{
            nowMin = (int)seekTime/60;
            nowSec = seekTime%60;
        }
        
        
        int allMin = (int)(self.wholeTime%3600)/60;
        int allSec = (self.wholeTime%3600)%60;
        
        return [NSString stringWithFormat:@"%02d:%02d:%02d/%02d:%02d:%02d",nowHours,nowMin,nowSec,allHours,allMin,allSec];
        
    }else{
        
        int nowMin = (int)seekTime/60;
        int nowSec = seekTime%60;
        
        int allMin = (int)self.wholeTime/60;
        int allSec = self.wholeTime%60;
        
        return [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",nowMin,nowSec,allMin,allSec];
    }
   
    
   
}

@end
