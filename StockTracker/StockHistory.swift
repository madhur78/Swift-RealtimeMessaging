//
//  Stock.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

struct StockHistory {
    
    let key: String
    let id: String
    let addDate: String
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    let ref: FIRDatabaseReference?
    
    init(id: String, addDate: String, open: Double, close: Double, high: Double, low: Double, key: String = "") {
        self.key = key
        self.id = id
        self.addDate = addDate
        self.open = open
        self.close = close
        self.high = high
        self.low = low
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as! String
        addDate = snapshotValue["addDate"] as! String
        open = snapshotValue["open"] as! Double
        close = snapshotValue["close"] as! Double
        high = snapshotValue["high"] as! Double
        low = snapshotValue["low"] as! Double
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "addDate": addDate,
            "open": open,
            "close": close,
            "high": high,
            "low": low
        ]
    }
    
}

