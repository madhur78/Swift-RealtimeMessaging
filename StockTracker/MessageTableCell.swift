//
//  StockTableCell.swift
//  StockTracker
//
//  Created by Jain, Madhur on 2/24/17.
//  Copyright © 2017 DPSG. All rights reserved.
//

import Foundation

class MessageTableCell : UITableViewCell{
    
    var value:String!
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    
    var messageViewController : MessageViewController?
    
    let textViewDescription: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
//        tv.font = .systemFont(ofSize: 14)
        tv.font = UIFont (name: "Avenir-Light", size: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.isEditable = false
        tv.isSelectable = false
        
        return tv
    }()

    let roleImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "myday-68x68")
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()

    let userLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Madhur Jain (Account Manager)"
//        tv.font = .boldSystemFont(ofSize: 14)
        tv.font = UIFont (name: "Avenir-Medium", size: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = kMessageGreen
        return tv
    }()

    let dateLabel: UILabel = {
        let tv = UILabel()
        tv.text = "24 Mar, 04:30 PM"
        tv.font = UIFont (name: "Avenir-Medium", size: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = kMessageGreen
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = kMessage
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let favoriteImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "conv-fav-icon-s2")
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        addSubview(bubbleView)
        addSubview(textViewDescription)
        bubbleView.addSubview(messageImageView)

        addSubview(roleImageView)
        addSubview(userLabel)
        addSubview(dateLabel)
        addSubview(favoriteImageView)

        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("tapped:")))
        //textViewDescription.addGestureRecognizer(tapGestureRecognizer)
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(sender:)) )
//        textViewDescription.addGestureRecognizer(longPressRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleZoomTap(sender:)) )
        messageImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //self.backgroundColor = UIColor.lightGray
        
        // Constraint anchors: x, y, width, height
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
//        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant : -bubbleSpacing).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant : -bubbleSpacing).isActive = true

        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true

        // Constraint anchors: x, y, width, height
        textViewDescription.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 6).isActive = true
        textViewDescription.topAnchor.constraint(equalTo: roleImageView.bottomAnchor, constant:0).isActive = true
        textViewDescription.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant:0).isActive = true
        textViewDescription.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Constraint anchors: x, y, width, height
        favoriteImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 7).isActive = true
        favoriteImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 2).isActive = true
        favoriteImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteImageView.isHidden = true
        
        // Constraint anchors: x, y, width, height
        roleImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        roleImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 3).isActive = true
        roleImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        roleImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Constraint anchors: x, y, width, height
        userLabel.leftAnchor.constraint(equalTo: roleImageView.rightAnchor, constant: 5).isActive = true
        userLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 3).isActive = true
        userLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -2).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Constraint anchors: x, y, width, height
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-2).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant:-8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
 
        
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var messageObj: Message!{
        didSet{
            self.updateUI();
        }
    }
    func updateUI(){
        
        textViewDescription.text = messageObj.desc
        userLabel.text = messageObj.user + " (" + messageObj.role + ")";
        
        if(messageObj.role == "Account Manager"){
            roleImageView.image = UIImage(named: "myday-68x68")
        }
        else if(messageObj.role == "Driver"){
            roleImageView.image = UIImage(named: "driver-68x68")
        }
        else if(messageObj.role == "Merchandiser"){
            roleImageView.image = UIImage(named: "merch-68x68")
        }
        else if(messageObj.role == "Branch Manager"){
            roleImageView.image = UIImage(named: "profile-68x68")
        }
        
        let split = messageObj.date.split(" ", limit: 6)
        if(split.count >= 6){
//            dateLabel.text = split[1] + " " + split[2] + " " + split[4] + " " + split[5]
            dateLabel.text = split[4] + " " + split[5]
        }
        
        if(messageObj.permanent == "1"){
            favoriteImageView.isHidden = false
        }
        else{
            favoriteImageView.isHidden = true
        }
        
        if(messageObj.user == SharedObject.sharedInstance().user && messageObj.role == SharedObject.sharedInstance().role){
            bubbleView.backgroundColor = kMessageBubble
            textViewDescription.textColor = .white
            userLabel.textColor = kMessage
            dateLabel.textColor = kMessage
            
            bubbleRightAnchor?.isActive = true
            bubbleLeftAnchor?.isActive = false
        }
        else{
            bubbleView.backgroundColor = kMessage
            textViewDescription.textColor = .black
            userLabel.textColor = kMessageGreen
            dateLabel.textColor = kMessageGreen
            
            bubbleRightAnchor?.isActive = false
            bubbleLeftAnchor?.isActive = true
        }

        if let messageImageUrl = messageObj?.imageURL {
            if(messageImageUrl.characters.count > 0){
                messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
                messageImageView.isHidden = false
                bubbleView.backgroundColor = UIColor.clear
            }
        } else {
            messageImageView.isHidden = true
        }
        
    }

    func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: textViewDescription.font!], context: nil)
    }
    
/*    func tapped(sender: UITapGestureRecognizer)
    {
        print("tapped")
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        someFunc()
    }
    
    
    func someFunc() {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        let deleteItem = UIMenuItem(title: "Delete me", action: #selector(self.deleteLine))
        menu.menuItems = [deleteItem]
        menu.setTargetRect(CGRect(x: 100, y: 80, width: 50, height: 50), in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
    func deleteLine() {
        //Do something here
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        // You need to only return true for the actions you want, otherwise you get the whole range of
        //  iOS actions. You can see this by just removing the if statement here.
        if action == #selector(self.deleteLine) {
            return true
        }
        return false
    }
*/
//    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
    func handleZoomTap(sender: UITapGestureRecognizer) {
//        print("Image Clicked")
        if let imageView = sender.view as? UIImageView {
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            self.messageViewController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
}


