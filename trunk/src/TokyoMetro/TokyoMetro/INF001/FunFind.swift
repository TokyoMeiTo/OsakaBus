//
//  FunFind.swift
//  TokyoMetro
//
//  Created by Xu Jie on 14-9-17.
//  Copyright (c) 2014年 Okasan-Huada. All rights reserved.
//

import Foundation

class FunFind : UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var btnAnimation: UIButton!
    @IBOutlet weak var btnHotSpring: UIButton!
    @IBOutlet weak var btnMobil: UIButton!
    @IBOutlet weak var btnBar: UIButton!
    @IBOutlet weak var btnParty: UIButton!
    @IBOutlet weak var btnCon: UIButton!
    @IBOutlet weak var btnNooldes: UIButton!
    @IBOutlet weak var btnSushi: UIButton!
    @IBOutlet weak var btnPopolar: UIButton!
    
    @IBOutlet weak var btnWeb1: UIButton!
    @IBOutlet weak var btnWeb2: UIButton!
    @IBOutlet weak var btnWeb3: UIButton!
    
    
    
    @IBOutlet var KeyWord: UITextField!
    @IBOutlet var StationName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAnimation.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnHotSpring.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnMobil.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBar.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnParty.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnCon.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnNooldes.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSushi.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnPopolar.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnWeb1.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnWeb2.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btnWeb3.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func selectAction(sender : UIButton) {
        switch sender {
        case btnAnimation :
            KeyWord.text = btnAnimation.titleLabel!.text
        case btnHotSpring :
            KeyWord.text = btnHotSpring.titleLabel!.text
        case btnMobil :
            KeyWord.text = btnMobil.titleLabel!.text
        case btnBar :
            KeyWord.text = btnBar.titleLabel!.text
        case btnParty :
            KeyWord.text = btnParty.titleLabel!.text
        case btnCon :
            KeyWord.text = btnCon.titleLabel!.text
        case btnNooldes :
            KeyWord.text = btnNooldes.titleLabel!.text
        case btnSushi :
            KeyWord.text = btnSushi.titleLabel!.text
        case btnPopolar :
            KeyWord.text = btnPopolar.titleLabel!.text
        default:
            KeyWord.text = ""
        }
    }
       
    
     func textFieldShouldReturn(textField: UITextField!) -> Bool {
       hideKeyBoard()
       return true
    }
    
    func hideKeyBoard () {
        KeyWord.resignFirstResponder()
        StationName.resignFirstResponder()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}