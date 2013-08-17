//
//  UsedCarInfo.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "UsedCarInfo.h"
#import "NSDictionary+type.h"
@implementation UsedCarInfo

-(id)init
{
    if (self = [super init]) {
        self.usedCarInfoId = @"";
        self.usedCarTid = @"";
        self.title = @"";
        self.addTime = @"";
        self.hits = @"";
        self.orders = @"";
        self.mrank = @"";
        self.mgold = @"";
        self.isshow = @"";
        self.user = @"";
        self.className = @"";
        self.litpic = @"";
        self.description = @"";
        self.msubmit = @"";
        self.molds = @"";
    }
    return self;
}

-(void)dealloc
{
    [_usedCarInfoId release];
    [_usedCarTid release];
    [_title release];
    [_addTime release];
    [_hits release];
    [_orders release];
    [_mrank release];
    [_mgold release];
    [_isshow release];
    [_user release];
    [_className release];
    [_litpic release];
    [_description release];
    [_msubmit release];
    [_molds release];
    [super dealloc];
}

//id:"编号",pinpai :"品牌" ,"yanse :" 颜色" ,"bsx :" 变速箱" ,"xslc :" 行驶里程" ,"spsj :" 上牌时间" ,"xxms :" 详细描述","lxr :" 联系人","lxdh :" 联系电话"
-(void)fromDic:(NSDictionary *)usedCarInfoDic
{   
//    "id":"20","tid":"38","title":"111","style":"","trait":"","gourl":"","addtime":"1375328820","record":"0","hits":"0","litpic":"","orders":"0","price":"1111.00","mrank":"0","mgold":"0.00","isshow":"1","description":"","htmlurl":"","htmlfile":"","user":"admin","zdj":"11.00","pl":"","bsx":"","jszaqqn":null,"fjswaqqn":null,"qpcqn":null,"hpcaqqn":null,"qptbqn":null,"hptbqn":null,"xbqn":null,"tyjczz":null,"ltyjxxs":null,"aqdwjts":null,"etzyjk":null,"etzyjk1":null,"fdjdzfd":null,"cnzks":null,"ykys":null,"wysqdxt":null,"fbs":null,"zdlfp":null,"scfz":null,"qylkz":null,"cswdkz":null,"zdzcspfz":null,"dphj":null,"kbxg":null,"kqxg":null,"kbxzxb":null,"ddgdkt":null,"ddtc":null,"ydwgtj":null,"lhjlg":null,"ddxhm":null,"zpfxp":null,"fxpsxtj":null,"fxpqhtj":null,"fxpddtj":null,"dgnfxp":null,"fxphd":null,"dsxhxt":null,"bcfz":null,"dcspyx":null,"xcdn":null,"ttszxs":null,"zpfpzy":null,"ydzy":null,"zygdtj":null,"jbzctj":null,"qpzyddtj":null,"depkbjdtj":null,"depzyyd":null,"hpzyddtj":null,"ddzyjy":null,"qpzyjr":null,"hpzyjr":null,"zytf":null,"zyamgn":null,"hpzyztfd":null,"hpzyblfd":null,"dspzy":null,"jszybzctj":null,"qzzyfs":null,"hpzyfs":null,"hpbj":null,"bxhbx":null,"dhxt":null,"dwhdfw":null,"zktcsdp":null,"rjjhxt":null,"nzyp":null,"lyczdh":null,"czds":null,"hpyjp":null,"wjyyjk":null,"ddcd":null,"xnddcd":null,"ddcdxt":null,"dddvdxt":null,"dvd":null,"lbysqxt23":null,"lbysqxt45":null,"lbysqxt67":null,"lbysqxt8":null,"xqdd":null,"rjxcd":null,"zdtd":null,"zxtd":null,"qwd":null,"ddqxzz":null,"cnfwd":null,"qddcc":null,"hddcc":null,"ccfjsgn":null,"fzwxgrbl":null,"hsjddtj":null,"hsjjr":null,"hsjzdfxm":null,"hsjddzd":null,"hsjjy":null,"hfdzyl":null,"hpczyl":null,"zybhzj":null,"hysq":null,"yscgq":null,"sdkt":null,"zdkt":null,"hpdlkt":null,"hpcfk":null,"wdfqkz":null,"kqtjhfgl":null,"czbx":null,"zdbcrw":null,"bxfz":null,"zdaqxt":null,"zdzxxt":null,"ysxt":null,"zkyjpxs":null,"zsyxh":null,"qjsxt":null,"qjtc":null,"url":"\/qiche\/product\/201.html"}]
    
    
    self.usedCarInfoId = [usedCarInfoDic objectForKey:@"id"];
    self.usedCarTid = [usedCarInfoDic objectForKey:@"tid"];
    self.title = [usedCarInfoDic objectForKey:@"title"];
    self.addTime = [usedCarInfoDic objectForKey:@"addtime"];
    self.hits = [usedCarInfoDic objectForKey:@"hits"];
    self.orders = [usedCarInfoDic objectForKey:@"orders"];
    self.mrank = [usedCarInfoDic objectForKey:@"mrank"];
    self.mgold = [usedCarInfoDic objectForKey:@"mgold"];
    self.isshow = [usedCarInfoDic objectForKey:@"isshow"];
    self.user = [usedCarInfoDic stringForKey:@"admin"];
    self.className = [usedCarInfoDic stringForKey:@"classname"];
    self.litpic = [NSString stringWithFormat:@"%@%@",ServerAddress ,[usedCarInfoDic stringForKey:@"litpic"]];
    self.description = [usedCarInfoDic stringForKey:@"description"];
    self.msubmit = [usedCarInfoDic stringForKey:@"msubmit"];
    self.molds = [usedCarInfoDic stringForKey:@"molds"];
}

@end
