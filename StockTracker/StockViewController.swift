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


class StockViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblStocks: UITableView!
    var stocks: [Stock] = []
    var stockRef : FIRDatabaseReference? = nil
    var historyPerStock: [HistoryPerStock] = []
    var stockHistory: [StockHistory] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblStocks.backgroundColor = kTableBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.stockRef = FIRDatabase.database().reference(withPath: "Stocks")
//               print(stockRef?.key)
        //        ref.observe(.value, with: { snapshot in
        //            print(snapshot.value)
        //        })
        
        self.stockRef?.observe(.value, with: { snapshot in
            var newItems: [Stock] = []
            print(snapshot.key)
            if (snapshot.value is NSNull) {
                print("Error in Reading Stock table")
                self.stocks = []
                self.tblStocks.reloadData()
            }
            else{
                for item in snapshot.children {
                    let stock = Stock(snapshot: item as! FIRDataSnapshot)
                    newItems.append(stock)
                }
                self.stocks = newItems
//                print(self.stocks)
                self.lblTitle.text = "My Stocks (\(self.stocks.count)) ";
                self.tblStocks.reloadData()
            }
        })
        
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        self.stockRef?.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - TABLE VIEW DELEGATE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockTableCell = self.tblStocks.dequeueReusableCell(withIdentifier: "StockTableCell") as! StockTableCell
        
        cell.stockObj = stocks[indexPath.row]

//        let stockObj = stocks[indexPath.row]
//        cell.name.text = stockObj.name
//        cell.price.text = DataFormatter.stringFromDouble(stockObj.price) 
//        cell.quantity.text = String(stockObj.quantity)
//        
//        cell.totalAmount.text = "$"+DataFormatter.intStringFromDouble(stockObj.price * Double(stockObj.quantity))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let stockHistoryViewController = mainStoryBoard.instantiateViewController(withIdentifier: "StockHistoryViewController") as! StockHistoryViewController
        stockHistoryViewController.stock = stocks[indexPath.row]
//        self.present(stockHistoryViewController, animated: false, completion: nil)
        
        self.navigationController?.pushViewController(stockHistoryViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteStock(stock: stocks[indexPath.row])
        }
    }
    
    func deleteStock(stock:Stock){
        
        let shKey = "StockHistoryPerStock/"+stock.key
        let hpsRef = FIRDatabase.database().reference(withPath: shKey)
        
        let shRef = FIRDatabase.database().reference(withPath: "StockHistory")
        
        shRef.queryOrdered(byChild: "id").queryEqual(toValue: stock.key)
        .observe(.value, with: { snapshot in
            if (snapshot.value is NSNull) {
                print("Error in Reading Stock History table")
            }
            else
            {
                for item in snapshot.children {
                    let sHistory = StockHistory(snapshot: item as! FIRDataSnapshot)
                    sHistory.ref?.removeValue()
                }
            }
        })
        
        hpsRef.removeValue()
        stock.ref?.removeValue()

    }
    
    @IBAction func addStockPressed(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let addStockViewController = mainStoryBoard.instantiateViewController(withIdentifier: "AddStockViewController") as! AddStockViewController
        self.navigationController?.pushViewController(addStockViewController, animated: true)
    }
    
}

