//
//  Stock.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

struct MessagePerCustomer {
    
    let key: String
    let ref: FIRDatabaseReference?
    let flag: Bool
    
    init(key: String = "") {
        self.key = key
        self.ref = nil
        self.flag = true
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        flag = true
    }
    
    func toAnyObject(key:String) -> Any {
        return [
            key: true
        ]
    }
    
}

