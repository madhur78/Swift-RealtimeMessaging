//
//  StockTableCell.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class StockHistoryTableCell : UITableViewCell{
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    var stockObj: StockHistory!{
        didSet{
            self.updateUI();
        }
    }
    
    func updateUI(){
        date.text = stockObj.addDate
        open.text = DataFormatter.stringFromDouble(stockObj.open)
        close.text = DataFormatter.stringFromDouble(stockObj.close)
        high.text = DataFormatter.stringFromDouble(stockObj.high)
        low.text = DataFormatter.stringFromDouble(stockObj.low)
        
        contentView.backgroundColor = kTableBackground
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = kShadow.cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
    }
}
