//
//  MessageHeaderCell.swift
//  StockTracker
//
//  Created by Jain, Madhur on 3/28/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

import Foundation

class MessageHeaderCell : UITableViewCell{

    @IBOutlet weak var date: UILabel!

    var msgDate: String!{
        didSet{
            self.updateUI();
        }
    }
    func updateUI(){
        
        date.text = msgDate
        date.backgroundColor = kDPSSilver
        date.textColor = kDPSGray
        date.translatesAutoresizingMaskIntoConstraints = false
        date.layer.cornerRadius = 8
        date.layer.masksToBounds = true
        
    }
    
    
}
