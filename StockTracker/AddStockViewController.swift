//
//  AddStockViewController.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/27/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class AddStockViewController : UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    
    var stockRef : FIRDatabaseReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addPressed(_ sender: Any) {
        
        self.stockRef = FIRDatabase.database().reference(withPath: "Stocks")

        let post1Ref = stockRef?.childByAutoId()
        let stock = Stock(id: (post1Ref?.key)!, name: txtName.text!, price: ((txtPrice.text)?.doubleValue())!, quantity: Int(txtQuantity.text!)!, symbol: txtName.text!, key: (post1Ref?.key)!);
        let data = stock.toAnyObject()
        
        post1Ref?.setValue(data)
        
        self.navigationController?.popViewController(animated: true)
        
//        let groceryItemRef = self.stockRef?.child(txtName.text!.lowercased())
//        let stock = Stock(id: txtName.text!.lowercased(), name: txtName.text!, price: ((txtPrice.text)?.doubleValue())!, quantity: Int(txtQuantity.text!)!, symbol: txtName.text!, key: "");
//        let data = stock.toAnyObject()
//        
//        groceryItemRef?.setValue(data)
    
    
    }
    
    
    func getJSONData() -> String{
        
        let json:String = "{\"id\": 24, \"name\": \"Bob Jefferson\", \"friends\": [{\"id\": 29, \"name\": \"Jen Jackson\"}]}"
        
        
        
        return json
    }

}
