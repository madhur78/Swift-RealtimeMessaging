//
//  Stock.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class Customer : NSObject {
    
    var key: String = ""
    var id: String = ""
    var name: String = ""
    var totalAmount: Double = 0
    var totalCases: Int = 0
    var totalOrders: Int = 0
    var custId: String = ""
    var address: String = ""
    let ref: FIRDatabaseReference?
    
    var messagesByDate = [MessagesByDate]()
    
    var isViewed = true
    var totalMessages = 0
    var lastCount = 0
    var messageImage  = UIImage(named: "comm-gray-icon.png")

    init(id: String, name: String, totalAmount: Double, totalCases: Int, totalOrders: Int, key: String = "", address: String, custId: String) {
        self.key = key
        self.id = id
        self.name = name
        self.totalCases = totalCases
        self.totalAmount = totalAmount
        self.totalOrders = totalOrders
        self.custId = custId
        self.address = address
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as! String
        name = snapshotValue["name"] as! String
        if(snapshotValue["totalAmount"] != nil) {
            totalAmount = snapshotValue["totalAmount"] as! Double
        }
        if(snapshotValue["totalCases"] != nil) {
            totalCases = snapshotValue["totalCases"] as! Int
        }
        if(snapshotValue["totalOrders"] != nil) {
            totalOrders = snapshotValue["totalOrders"] as! Int
        }
        address = snapshotValue["address"] as! String
        if(snapshotValue["address"] != nil) {
            address = snapshotValue["address"] as! String
        }
        if(snapshotValue["custId"] != nil) {
            custId = snapshotValue["custId"] as! String
        }
        ref = snapshot.ref
    }

    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "totalAmount": totalAmount,
            "totalCases": totalCases,
            "totalOrders": totalOrders,
            "address": address,
            "custId": custId
            
        ]
    }
    
    /*    func createPermanentMessages(){
     let copiedArray = allMessagesByDate.map{$0.copy()}
     permanentMessagesByDate = getPermanentMessagesByDate(msgArray: copiedArray as! [MessagesByDate])
     
     for msg in permanentMessagesByDate {
     msg.messages = getPermanentMessages(mbdObj: msg)
     }
     }
     
     func getPermanentMessagesByDate(msgArray : [MessagesByDate]) -> [MessagesByDate] {
     let count = msgArray.filter({$0.permanentMsg > 0}).count
     if(count > 0){
     let objs = msgArray.filter({$0.permanentMsg > 0})
     return objs
     }
     
     return [MessagesByDate]()
     }
     
     func getPermanentMessages(mbdObj: MessagesByDate) -> [Message] {
     let count = mbdObj.messages.filter({$0.permanent == "1"}).count
     if(count > 0){
     let objs = mbdObj.messages.filter({$0.permanent == "1"})
     return objs
     }
     
     return [Message]()
     }
     */
    
    
}

