//
//  CIntroduceViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CIntroduceViewController.h"

@interface CIntroduceViewController ()

@end

@implementation CIntroduceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.editable = NO;
    self.textView.text = @"1.公司介绍\n山西君和汽车销售服务有限公司成立于二零一零年三月十八日，是一汽——大众奥迪品牌在太原市批准的第三家奥迪特许经销商，已投资上亿元，按照奥迪国际通用标准建成太原市规模最大，功能最全，标准最高的奥迪城市展厅旗舰店，是山西地区奥迪品牌唯一的世界级体验中心。\n    豪华规模：\n        公司占地面积13334平方米，建筑面积10267平方米，其中绿化建设达1293平方米，交通便利、环境优美。\n        城市展厅经专业人士精心设计、装修，豪华程度达五星级酒店标准，尽显奥迪品牌尊贵典范。展厅内部硬件环境超越期待，18车位超大空间，58个工位的一流车间，拥有充足的备件及专业的进口工具设备。\n    尊享体验：\n        公司依托奥迪强大的品牌影响力，为高端客户提供尊贵完美的汽车生活体验，和无以伦比的个性化服务。\n        公司拥有上下两层共300多平方米的VIP客户休息区，内设有大型游戏机、影院、网吧、茶艺等尊贵享受。并提供24小时全天候紧急救援服务，真正使您用车无忧。    \n    专业品牌服务：\n        公司始终以“诚实、正直、专业、负责、超越客户期望、感恩回馈社会”为经营理念，以“为客户提供尊享完美的汽车生活体验”为使命，以“为员工创造健康丰盛的人生”为愿景。全体员工秉承“奥迪卓、悦服务”的服务理念，每时每刻为客户创造激情、难忘的尊贵体验。以客户服务感受为导向为您提供最尊贵、专业的奥迪品牌服务。\n    精英团队：\n        公司拥有一支团结高效的精英团队。\n        目光敏锐，经验丰富的核心管理层，均来自业内知名企业。\n        团结高效的市场推广队伍，专业、敬业的销售队伍，技术一流、专家云集的售后服务队伍，高素质的客服队伍，均参加过行业内及奥迪的专业高端培训，共同为您提供最完美的汽车生活体验。\n    美好前景：\n        公司奥迪城市展厅的建成，将使汽车品牌云集的万柏林区进一步提升品牌形象，增添经济活力，每年将有超50000人次前来赏车、修车，尤其吸引山西省各地级市高端车消费者的眼光，进一步提升本区域的知名度，并带动其他行业的消费，将推动万柏林区乃至整个太原市的汽车产业的发展，提升城市形象。\n    “日出江花红似火，春来江水绿如蓝”，山西君和必将秉承百年奥迪品牌真谛，享誉龙城。\n    欢迎各界有识之士前来莅临品鉴！\n\n2.公司全称：山西君和汽车销售服务有限公司\n3.地址：太原市万柏林区迎泽西大街170\n4.电话（客服，400）：400-631-0351\n5.总经理信箱:sa14008@part.faw-vw.com";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_textView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
