//
//  UserCustomer.swift
//  StockTracker
//
//  Created by Jain, Madhur on 5/18/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class UserCustomer : NSObject {
    
    var key: String = ""
    var id: String = ""
    var userName: String = ""
    var custName: String = ""
    var isTyping: String = ""
    let ref: FIRDatabaseReference?
    
    init(id: String, userName: String, custName: String, isTyping: String, key: String = "") {
        self.key = key
        self.id = id
        self.userName = userName
        self.custName = custName
        self.isTyping = isTyping
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as! String
        userName = snapshotValue["userName"] as! String
        
        if(snapshotValue["custName"] != nil) {
            custName = snapshotValue["custName"] as! String
        }
        if(snapshotValue["isTyping"] != nil) {
            isTyping = snapshotValue["isTyping"] as! String
        }
        ref = snapshot.ref
    }
    
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "userName": userName,
            "custName": custName,
            "isTyping": isTyping
        ]
    }
    
}
