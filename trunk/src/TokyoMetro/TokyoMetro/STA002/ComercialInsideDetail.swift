//
//  ComercialInsideDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class ComercialInsideDetail: UIViewController {

    @IBOutlet weak var textTime: UITextView!
    @IBOutlet weak var textLocal: UITextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var image: UIImageView!

    var comeInsiTable: StaT03ComervialInsideTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent()
    }
    
    func setContent() {

        self.title = "设施详细"
        lblName.text = comeInsiTable.item(STAT03_COME_INSI_NAME) as? String
        textTime.text = (comeInsiTable.item(STAT03_COME_INSI_BISI_HOUR) as String).relpaceAll("\\n", target: "\n")
        textLocal.text = comeInsiTable.item(STAT03_COME_INSI_LOCA_CH) as String
        
        var price = comeInsiTable.item(STAT03_COME_INSI_PRICE) as? String
        if (price == nil) {
            lblPriceTitle.hidden = true
            lblPrice.hidden = true
        } else {
            lblPrice.text = price
        }
        
        image.image = UIImage(named: (comeInsiTable.item(STAT03_COME_INSI_IMAGE) as String).getStationInnerComPath())

    }
    
}
