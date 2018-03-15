//
//  Stock.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

struct Stock {
    
    let key: String
    let id: String
    let name: String
    let price: Double
    let quantity: Int
    let symbol: String
    let ref: FIRDatabaseReference?
    
    init(id: String, name: String, price: Double, quantity: Int, symbol: String, key: String = "") {
        self.key = key
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.symbol = symbol
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as! String
        name = snapshotValue["name"] as! String
        price = snapshotValue["price"] as! Double
        quantity = snapshotValue["quantity"] as! Int
        if(snapshotValue["symbol"] != nil) {
            symbol = snapshotValue["symbol"] as! String
        }
        else{
            symbol = name
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "price": price,
            "quantity": quantity,
            "symbol": symbol
        ]
    }
    
}

