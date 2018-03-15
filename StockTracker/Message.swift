//
//  Stock.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class Message  : NSObject {
    
    var key: String = ""
    var id: String = ""
    var desc: String = ""
    var user: String = ""
    var role: String = ""
    var date: String = ""
    var permanent:String = ""
    var combineCustPermanent:String = ""
    var imageURL:String = ""
    var imageWidth:NSNumber = 0
    var imageHeight:NSNumber = 0
    var ref: FIRDatabaseReference? = nil
    
    override init(){
    }
    
    init(id: String, desc: String, user: String, role: String, date: String, permanent:String = "", key: String = "", combineCustPermanent : String = "", imageURL: String = "", imageWidth: NSNumber, imageHeight: NSNumber) {
        self.key = key
        self.id = id
        self.desc = desc
        self.user = user
        self.role = role
        self.date = date
        self.permanent = permanent
        self.combineCustPermanent = combineCustPermanent
        self.imageURL = imageURL
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        id = snapshotValue["id"] as! String
        if(snapshotValue["description"] != nil){
            desc = snapshotValue["description"] as! String
        }
        else{
            desc = ""
        }
        if(snapshotValue["permanent"] != nil){
            permanent = snapshotValue["permanent"] as! String
        }
        else{
            permanent = ""
        }
        if(snapshotValue["combineCustPermanent"] != nil){
            combineCustPermanent = snapshotValue["combineCustPermanent"] as! String
        }
        else{
            combineCustPermanent = ""
        }
        if(snapshotValue["imageURL"] != nil){
            imageURL = snapshotValue["imageURL"] as! String
        }
        else{
            imageURL = ""
        }
        if(snapshotValue["imageWidth"] != nil){
            imageWidth = snapshotValue["imageWidth"] as! NSNumber
        }
        else{
            imageWidth = 0.0
        }
        if(snapshotValue["imageHeight"] != nil){
            imageHeight = snapshotValue["imageHeight"] as! NSNumber
        }
        else{
            imageHeight = 0.0
        }
        
        user = snapshotValue["user"] as! String
        role = snapshotValue["role"] as! String
        date = snapshotValue["date"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "description": desc,
            "user": user,
            "role": role,
            "date": date,
            "permanent": permanent,
            "imageURL": imageURL,
            "imageWidth": imageWidth,
            "imageHeight": imageHeight
        ]
    }
    
}

