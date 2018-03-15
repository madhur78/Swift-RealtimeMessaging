//
//  LoginViewController.swift
//  StockTracker
//
//  Created by Jain, Madhur on 3/14/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var imvBackground: UIImageView!
    @IBOutlet weak var imvMessage: UIImageView!
    @IBOutlet weak var viewLogin: UIView!
    
    @IBOutlet weak var chkBM: UIImageView!
    @IBOutlet weak var chkMerch: UIImageView!
    @IBOutlet weak var chkDriver: UIImageView!
    @IBOutlet weak var chkAM: UIImageView!
    
    @IBOutlet weak var txtUser: UITextField!
    
    @IBOutlet weak var lblAM: UILabel!
    @IBOutlet weak var lblDriver: UILabel!
    @IBOutlet weak var lblMerch: UILabel!
    @IBOutlet weak var lblBM: UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    var roleSelected:String = "Default";
    
    var originalY : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.originalY = self.imvMessage.frame.origin.y

        self.btnLogin.alpha = 0
        self.viewLogin.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        showAnimatedViewsOnLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }

    func showAnimatedViewsOnLoad(){
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .transitionFlipFromBottom, animations:{
            self.btnLogin.alpha = 0
        }, completion : {(true) in
            self.showMessageImageView()
        })
    }

    func showAnimatedViewsOnLogin(){
        self.btnLogin.alpha = 0
        self.showMessageImageView()
    }
    
    func showMessageImageView(){
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .transitionFlipFromBottom, animations:{
            var frame = self.imvMessage.frame
            frame.origin.y = 80
            self.imvMessage.frame = frame
            self.showLoginView()
          
        }, completion : {(true) in
//            self.showLoginView()
        })
    }
    
    func showLoginView(){
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .transitionFlipFromBottom, animations:
            {
                self.viewLogin.alpha = 1
        })
    }
    
    func showAnimatedViewsOnCancel(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .transitionFlipFromBottom, animations:{
            self.viewLogin.alpha = 0
            self.showMessageImageViewOnCancel()
        }, completion : {(true) in
        })
    }
    
    func showMessageImageViewOnCancel(){
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .transitionFlipFromBottom, animations:{
            //            self.imvMessage.alpha = 0.6
            var frame = self.imvMessage.frame
            frame.origin.y = self.originalY
            self.imvMessage.frame = frame
            self.showLoginButtonOnCancel()
            
        }, completion : {(true) in
        })
    }
    
    func showLoginButtonOnCancel(){
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .transitionFlipFromBottom, animations:
            {
                self.btnLogin.alpha = 1
        })
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        SharedObject.sharedInstance().user = self.txtUser.text
        SharedObject.sharedInstance().role = roleSelected
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let customerViewController = mainStoryBoard.instantiateViewController(withIdentifier: "CustomerViewController") as! CustomerViewController
        self.navigationController?.pushViewController(customerViewController, animated: true)

    }
    
    @IBAction func closePressed(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.showAnimatedViewsOnCancel()
    }
    
    @IBAction func displayLoginOnPress(_ sender: Any) {
        self.showAnimatedViewsOnLogin()
    }
    
    @IBAction func amPressed(_ sender: Any) {
        
        resetSelection()
        chkAM.image = UIImage(named: "checkBox")
        roleSelected = lblAM.text!
    }
    
    @IBAction func driverPressed(_ sender: Any) {
        resetSelection()
        chkDriver.image = UIImage(named: "checkBox")
        roleSelected = lblDriver.text!
    }
    
    @IBAction func merchPressed(_ sender: Any) {
        resetSelection()
        chkMerch.image = UIImage(named: "checkBox")
        roleSelected = lblMerch.text!
    }

    @IBAction func bmPressed(_ sender: Any) {
        resetSelection()
        chkBM.image = UIImage(named: "checkBox")
        roleSelected = lblBM.text!
    }
    
    func resetSelection(){
        for view in self.view.subviews as [UIView] {
            if(view.tag == 2)
            {
                for view in view.subviews as [UIView] {
                    if let img = view as? UIImageView {
                        img.image = UIImage(named: "emptyBox")
                    }
                }
            }
        }
    }
    
    
}
