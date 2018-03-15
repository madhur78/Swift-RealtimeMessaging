//
//  StockTableCell.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class CustomerTableCell : UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var totalOrders: UILabel!
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var totalMessages: UILabel!
    
    @IBOutlet weak var lblMessageCount: UILabel!
    @IBOutlet weak var viewCount: UIView!

    @IBOutlet weak var lblAddress: UILabel! 
    @IBOutlet weak var lblSeqNo: UILabel!
//    @IBOutlet weak var backgroundCardView: UIView!
    
    @IBOutlet weak var btnMessage: UIButton!
    var custObj: Customer!{
        didSet{
            self.updateUI();
        }
    }
    
    func updateUI(){
        name.text = custObj.name + " " + custObj.custId
        lblAddress.text = custObj.address
        totalCases.text = String(custObj.totalCases)
    }
    
    func fadeIn(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            self.lblMessageCount.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            self.lblMessageCount.alpha = 0.0
        })
    }
    
    
    
}
