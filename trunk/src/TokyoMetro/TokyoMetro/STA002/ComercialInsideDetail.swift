//
//  ComercialInsideDetail.swift
//  TokyoMetro
//
//  Created by caowj on 14-10-12.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import UIKit

class ComercialInsideDetail: UIViewController {

    @IBAction weak var textTime: UITextField!
    @IBAction weak var textLocal: UITextField!
    @IBAction weak var lblName: UILabel!
    @IBAction weak var lblPrice: UILabel!
    @IBAction weak var lblPriceTitle: UILabel!

    var comeInsiTable: StaT03ComervialInsideTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent()
    }
    
    func setContent() {

//        lblName.text = comeInsiTable.item
    }
    
}
