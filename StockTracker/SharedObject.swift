//
//  SharedObject.swift
//  StockTracker
//
//  Created by Jain, Madhur on 3/14/17.
//  Copyright © 2017 DPSG. All rights reserved.
//
import Foundation
import AVFoundation


class SharedObject: NSObject {
    
    var user: String!
    var role: String!
    static var selfInstance: SharedObject!
    var chimeSoundEffect: AVAudioPlayer!
    var chordSoundEffect: AVAudioPlayer!

    class func sharedInstance() -> SharedObject {
        if (selfInstance == nil) {
            selfInstance = SharedObject()
        }
        return selfInstance
    }
    
    override init() {
        super.init()
        setUser(user: "Test User")
        setRole(role: "Role")
    }
    
    func setUser(user: String) {
        self.user = user
    }

    func setRole(role: String) {
        self.role = role
    }
    
    func newUUID() -> String {
        return UUID().uuidString;
    }
    
    func showAlert(_ message: String) {
        let topVC: UIViewController = UIApplication.topViewController()!
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        topVC.present(alertController, animated: true) {
        }
    }
    
    func showWarningAlert(_ message: String) {
        let topVC: UIViewController = UIApplication.topViewController()!
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        topVC.present(alertController, animated: true) {
        }
    }
    
    // MARK: - PLAY SOUNDS
    
    func playSendMessage(){
        
        let path = Bundle.main.path(forResource: "chime.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.chimeSoundEffect = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func playReceiveMessage(){
        
        let path = Bundle.main.path(forResource: "chord.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            self.chimeSoundEffect = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    
}

