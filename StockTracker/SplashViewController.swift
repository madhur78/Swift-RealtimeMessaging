//
//  SplashViewController.swift
//  StockTracker
//
//  Created by Jain, Madhur on 3/14/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class SplashViewController: UIViewController{
    
    
    @IBOutlet weak var messageImageTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .overCurrentContext
//        self.present(loginViewController, animated: false, completion: {
//        })

        
        let transition:CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(loginViewController, animated: true)
//        self.navigationController?.present(loginViewController, animated: true, completion: {
//        })
        
        
    }
    
}
