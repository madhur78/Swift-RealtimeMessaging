//
//  Stock.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

struct HistoryPerStock {
    
    let key: String
    let ref: FIRDatabaseReference?
    
    init(key: String = "") {
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
        ]
    }
    
}

