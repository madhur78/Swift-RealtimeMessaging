//
//  ViewController.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class CustomerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblCustomer: UITableView!
    @IBOutlet weak var lblCustomerTitle: UILabel!

    var customers: [Customer] = []
    var customerRef : FIRDatabaseReference? = nil
    var messageRef : FIRDatabaseReference? = nil
    var messages: [Message] = []
//    var messageDict = [String: MessageView]()
    var isFirstLaunch = true
    var userCustomerRef : FIRDatabaseReference? = nil

    @IBAction func stockPressed(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let stockViewController = mainStoryBoard.instantiateViewController(withIdentifier: "StockViewController") as! StockViewController
        self.navigationController?.pushViewController(stockViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationItem.rightBarButtonItem = nil
        
        self.customerRef = FIRDatabase.database().reference(withPath: "Customers")
        self.messageRef = FIRDatabase.database().reference(withPath: "Messages")
        
        
//        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.getCustomerMessages()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.getAllCustomers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.getCustomerMessages()
    }
    
    func getAllCustomers(){
        self.customerRef?.observe(.value, with: { snapshot in
            var newItems: [Customer] = []
            if (snapshot.value is NSNull) {
                self.customers = []
                self.reloadTable()
            }
            else{
                for item in snapshot.children {
                    let cust = Customer(snapshot: item as! FIRDataSnapshot)
                    newItems.append(cust)
                    self.getMessageByCustomer(customer: cust)
                }
                self.customers = newItems
                self.lblCustomerTitle.text = "201 AUSTIN BULK DELIVERY" //"My Customers (\(self.customers.count)) ";
                self.reloadTable()
            }
        })
    }
    
    func getMessageByCustomer(customer : Customer)  {
        var indexCount = 0
        
        self.messageRef?.queryOrdered(byChild: "id").queryEqual(toValue: customer.key)
        .observe(.value, with: { snapshot in
            let count = Int(snapshot.childrenCount)
            
            customer.totalMessages = count
            self.setMessageImage(custObj: customer)
            customer.lastCount = count
            
            indexCount += 1
            
//            if(indexCount >= self.customers.count){
//                self.reloadTable()
//                self.isFirstLaunch = false
//            }
        })
    }
    
    
    func getCustomerMessages()  {
        var indexCount = 0
        
        for customer in self.customers {
            self.messageRef?.queryOrdered(byChild: "id").queryEqual(toValue: customer.key)
                .observe(.value, with: { snapshot in
                    let count = Int(snapshot.childrenCount)
                    
                    customer.totalMessages = count
                    self.setMessageImage(custObj: customer)
                    customer.lastCount = count
                    
                    indexCount += 1
                    
                    if(indexCount >= self.customers.count){
                        self.reloadTable()
                        self.isFirstLaunch = false
                    }
            })
        }
    }
    
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.tblCustomer.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.customerRef?.removeAllObservers()
        self.messageRef?.removeAllObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TABLE VIEW DELEGATE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomerTableCell = self.tblCustomer.dequeueReusableCell(withIdentifier: "CustomerTableCell") as! CustomerTableCell
        cell.custObj = customers[indexPath.row]
        cell.lblSeqNo.text = String(indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let custObj = self.customers[indexPath.row]
        custObj.isViewed = true

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let messageViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageViewController.customer = customers[indexPath.row]
        self.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        newMessage(cell: cell as! CustomerTableCell)
    }

    func setUserCustomer(){
//        self.userCustomerRef = FIRDatabase.database().reference(withPath: "UserCustomer")
//        
//        let userCustomer = UserCustomer()
//        userCustomer.userN = SharedObject.sharedInstance().user
//        message.role = SharedObject.sharedInstance().role
//        message.date = AppDateFormatter.todayStringForApp()
//        
//        let messageData = message.toAnyObject()
//        
//        postMessageRef?.setValue(messageData)
            
    }
    
    func setMessageImage(custObj : Customer) {
        
        custObj.messageImage = UIImage(named: "comm-gray-icon.png")
        
        if(!isFirstLaunch){
            if(custObj.totalMessages > custObj.lastCount){
                custObj.messageImage = UIImage(named: "comm-grn-icon.png")
                SharedObject.sharedInstance().playReceiveMessage()
            }
            else if(custObj.totalMessages < custObj.lastCount){
                custObj.messageImage = UIImage(named: "comm-red-icon.png")
                SharedObject.sharedInstance().playReceiveMessage()
            }
        }
        
        if(custObj.isViewed){
            custObj.messageImage = UIImage(named: "comm-gray-icon.png")
            custObj.isViewed = false
        }
    }
    
    func newMessage(cell: CustomerTableCell){

        let custObj = cell.custObj
        if((custObj?.totalMessages)! > 0){
            cell.btnMessage.setImage(custObj?.messageImage, for: .normal)
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                    cell.btnMessage.alpha = 1
                })
        }
        else{
            cell.btnMessage.alpha = 0
        }
    
        //Slide Animations
//        let rotateTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0)
//        cell.btnMessage.layer.transform = rotateTransform
//        
//        UIView.animate(withDuration: 1.0, animations: { () -> Void in
//            cell.btnMessage.layer.transform = CATransform3DIdentity
//        })
        
        //Bounce Animations
        
//        let bounds = cell.btnMessage.bounds
//        
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
//            cell.btnMessage.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 260, height: bounds.size.height)
//        }) { (success:Bool) in
//            if success {
//                UIView.animate(withDuration: 0.5, animations: {
//                    cell.btnMessage.bounds = bounds
//                })
//            }
//        }
    }
    
}

