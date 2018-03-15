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


class StockHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblStocks: UITableView!
    @IBOutlet weak var lblStockTitle: UILabel!
    
    var stock : Stock!
    var historyPerStock: [HistoryPerStock] = []
    var stockHistory: [StockHistory] = []
    
    var hpsRef : FIRDatabaseReference? = nil//:AnyObject
    var shRef : FIRDatabaseReference? = nil//:AnyObject
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblStocks.backgroundColor = kTableBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        lblStockTitle.text = stock.name
        
        let shKey = "StockHistoryPerStock/"+stock.key
        self.hpsRef = FIRDatabase.database().reference(withPath: shKey)
        
        self.hpsRef?.observe(.value, with: { snapshot in
            var newItems: [HistoryPerStock] = []
            if (snapshot.value is NSNull) {
                print("Error in Reading Stock table")
            }
            else{
                for item in snapshot.children {
                    let stock = HistoryPerStock(snapshot: item as! FIRDataSnapshot)
                    newItems.append(stock)
                }
                self.historyPerStock = newItems
//                print(self.historyPerStock)
            }
        })
        
        self.shRef = FIRDatabase.database().reference(withPath: "StockHistory")
        
        self.shRef?.queryOrdered(byChild: "id").queryEqual(toValue: stock.key)
            .observe(.value, with: { snapshot in
                var newItems: [StockHistory] = []
                if (snapshot.value is NSNull) {
                    print("Error in Reading Stock History table")
                }
                else
                {
                    for item in snapshot.children {
                        let stock = StockHistory(snapshot: item as! FIRDataSnapshot)
                        newItems.append(stock)
                    }
                    self.stockHistory = newItems
//                    print(self.stockHistory)
                    self.tblStocks.reloadData()
                }
            })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        self.shRef?.removeAllObservers()
        self.hpsRef?.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TABLE VIEW DELEGATE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockHistoryTableCell = self.tblStocks.dequeueReusableCell(withIdentifier: "StockHistoryTableCell") as! StockHistoryTableCell
        
        let stockObj = stockHistory[indexPath.row]
        cell.stockObj = stockObj
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let scenariosVC = scenarioStoryBoard.instantiateViewController(withIdentifier: "ScenariosViewController") as! ScenariosViewController
        //        self.navigationController?.pushViewController(scenariosVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80    }
    
}

