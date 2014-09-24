//
//  LandMarkDetailController.swift
//  TokyoMetro
//
//  Created by zhourr_ on 2014/09/18.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation
import UIKit

class LandMarkDetailController: UIViewController{
    /* 页面跳转UIButton */
    @IBOutlet weak var btnMap: UIButton!
    /* 地标详细信息 UILabel */
    @IBOutlet weak var lblLandMarkInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnMap.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var strInfo = "日本武道馆（にっぽんぶどうかん）是位于东京都千代田区北之丸公园2番3号的屋内竞技设施。目的是在人民群众尤其是青年一代，鼓励传播日本传统武术，通过身体的武术磨练和情绪的健康发展，为国家发展作出贡献，以及更广泛的世界和平作出贡献和福利。由于悠久的历史（1964年建成。而最早的巨蛋东京巨蛋于1988年才建成），武道馆是众多世界顶尖乐团及歌手演出过，并录制下“Live In Budokan”现场专辑的场地，也因此为全世界所知。故此地有着一种“圣地”及“最高殿堂”的象征意义，而不单单只是一个体育馆，能够在此地演出是众多歌手的目标。\n地址：东京都千代田区北の丸公园2番3号  北の丸公园内\n交通：东京地铁东西线、半藏门线、都营新宿线的九段下站下车，2号出口徒步5分钟"
        lblLandMarkInfo.text = strInfo
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * ボタン点击事件
     * @param sender
     */
    func buttonAction(sender: UIButton){
        switch sender{
        case btnMap:
            var landMarkMapController = self.storyboard!.instantiateViewControllerWithIdentifier("landmarkmap") as LandMarkMapController
            self.navigationController!.pushViewController(landMarkMapController, animated:true)
        default:
            println("nothing")
        }
    }
}