//
//  StockTableCell.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class StockTableCell : UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var backgroundCardView: UIView!
    
    var stockObj: Stock!{
        didSet{
            self.updateUI();
        }
    }
    
    func updateUI(){
        name.text = stockObj.name
        price.text = "$" + DataFormatter.stringFromDouble(stockObj.price)
        quantity.text = String(stockObj.quantity) + " Shares"
        totalAmount.text = "$"+DataFormatter.intStringFromDouble(stockObj.price * Double(stockObj.quantity))
        
        totalAmount.layer.cornerRadius = 3.0
        totalAmount.layer.masksToBounds = true
        totalAmount.layer.shadowColor = kShadow.cgColor
        totalAmount.layer.shadowOffset = CGSize(width: 0, height: 0)
        totalAmount.layer.shadowOpacity = 0.8
        
        contentView.backgroundColor = kTableBackground
        backgroundCardView.backgroundColor = UIColor.white
        backgroundCardView.layer.cornerRadius = 5.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = kShadow.cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
        
    }
    
}
