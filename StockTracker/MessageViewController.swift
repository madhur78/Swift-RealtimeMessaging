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
import FirebaseStorage
import MediaPlayer
import MobileCoreServices

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var lblMessageTitle: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var lblNotification: UILabel!
    
    @IBOutlet weak var barItemMessage: UIBarButtonItem!
    @IBOutlet weak var viewFooter: UIView!
    var customer : Customer!
    var messageRef : FIRDatabaseReference? = nil
    var messagePerCustomerRef : FIRDatabaseReference? = nil
    
    var lastMessageCount = 0
    var sendPressed = false
    var isShowAll = true
    
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtMsgBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent

        registerForKeyboardNotifications()
        
        tblMessage?.register(MessageTableCell.self, forCellReuseIdentifier: "MessageTableCell")
        
        self.txtMessage.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAnywhere(sender:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.fadeOut()
        
    }
    
    func tapAnywhere(sender: UITapGestureRecognizer){
        txtMessage.resignFirstResponder()
//        if(self.navigationController?.isNavigationBarHidden)!{
//            self.navigationController?.isNavigationBarHidden = false
//        }
//        else {
//            self.navigationController?.isNavigationBarHidden = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        lblMessageTitle.text = customer.name + " (" + customer.custId + ")"
        if(isShowAll){
            getAllMessages()
        }
        else {
            getAllPermanentMessages()
        }
    }
    
    func getAllMessages()
    {
        self.messageRef = FIRDatabase.database().reference(withPath: "Messages")
        self.messageRef?.queryOrdered(byChild: "id").queryEqual(toValue: customer.key)
            .observe(.value, with: { snapshot in
                if(self.isShowAll){
                    self.setMessageData(snapshot: snapshot)
                }
        })
    }
    
    
    func getAllPermanentMessages(){
        self.messageRef = FIRDatabase.database().reference(withPath: "Messages")
        
        self.messageRef?.queryOrdered(byChild: "combineCustPermanent").queryEqual(toValue: customer.name+"_1")
            .observe(.value, with: { snapshot in
                if(!self.isShowAll){
                    self.setMessageData(snapshot: snapshot)
                }
        })
    }

    func setMessageData(snapshot : FIRDataSnapshot){
        let count = Int(snapshot.childrenCount)
        self.customer.messagesByDate = []
        
        if (snapshot.value is NSNull) {
//            self.lastMessageCount = 0
            self.tblMessage.reloadData()
            self.displayNotification(count: count)
        }
        else
        {
            var isFound = false
            for item in snapshot.children {
                
                let mObj = Message(snapshot: item as! FIRDataSnapshot)
                
                let split = mObj.date.split(" ", limit: 6)
                var date=""
                if(split.count >= 6){
                    date = split[0] + " " + split[1] + " " + String(split[2].characters.dropLast())
                }
                
                isFound  = false
                for msg in self.customer.messagesByDate {
                    if(msg.date == date)
                    {
                        msg.messages.append(mObj)
                        isFound = true
                        break;
                    }
                }
                
                if(!isFound){
                    let msgByDateObj = MessagesByDate()
                    msgByDateObj.date = date
                    msgByDateObj.messages.append((mObj))
                    self.customer.messagesByDate.append(msgByDateObj)
                }
            }
            self.sortMessages()
            self.tblMessage.reloadData()
            self.displayNotification(count: count)
        }
    }
    
    func displayNotification(count : Int){
        if(self.lastMessageCount == 0){
            self.lastMessageCount = count
            DispatchQueue.main.async {
                self.scrollToBottom(animated:true)
            }
        }
        else if(self.sendPressed){
            self.lastMessageCount = count
            DispatchQueue.main.async {
                self.scrollToBottom(animated:true)
            }
        }
        else if(!self.sendPressed){
            if(count > self.lastMessageCount){
                SharedObject.sharedInstance().playReceiveMessage()
                self.lblNotification.text = "New Message Received"
                self.lblNotification.backgroundColor = kStatusGreenColor
                self.fadeIn()
                self.lastMessageCount = count
            }
            else if(count < self.lastMessageCount){
                SharedObject.sharedInstance().playReceiveMessage()
                self.lblNotification.text = "Message Deleted"
                self.lblNotification.backgroundColor = kStatusRedColor
                self.fadeIn()
                self.lastMessageCount = count
            }
            
            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.fadeOut()
            }
        }
        self.sendPressed = false
        
    }
    
    func sortMessages(){
        self.customer.messagesByDate.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        for msg in self.customer.messagesByDate {
            msg.messages.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        self.messageRef?.removeAllObservers()
        self.messagePerCustomerRef?.removeAllObservers()
        deregisterFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TABLE VIEW DELEGATE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.customer.messagesByDate.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: MessageHeaderCell = self.tblMessage.dequeueReusableCell(withIdentifier: "MessageHeaderCell") as! MessageHeaderCell
        cell.msgDate = self.customer.messagesByDate[section].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customer.messagesByDate[section].messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageTableCell = self.tblMessage.dequeueReusableCell(withIdentifier: "MessageTableCell") as! MessageTableCell
        
        cell.messageObj = self.customer.messagesByDate[indexPath.section].messages[indexPath.row]
        
        cell.messageViewController = self

        if (cell.messageObj?.desc) != ""  {
            cell.textViewDescription.isHidden = false
            cell.messageImageView.isHidden = true
            let width = cell.estimatedFrameForText(text: (cell.messageObj?.desc)!).width + 32
            if(width < 110){
                cell.bubbleWidthAnchor?.constant = 110
            }
            else {
                cell.bubbleWidthAnchor?.constant = width
            }
        } else if cell.messageObj?.imageURL != nil {
            cell.textViewDescription.isHidden = true
            cell.messageImageView.isHidden = false
            cell.bubbleWidthAnchor?.constant = CGFloat(messageWithImageWidth)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell: MessageTableCell = self.tblMessage.dequeueReusableCell(withIdentifier: "MessageTableCell") as! MessageTableCell
        let mObj : Message!
        
        mObj = self.customer.messagesByDate[indexPath.section].messages[indexPath.row]
        cell.value = mObj.desc
        
        var height: CGFloat = 80
        
        if (mObj?.desc) != "" {
            height = cell.estimatedFrameForText(text: mObj.desc).height + 60
        } else if let imageWidth = mObj?.imageWidth.floatValue, let imageHeight = mObj?.imageHeight.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            height = CGFloat(imageHeight / imageWidth * messageWithImageWidth.floatValue)

        }
        
        //let height = cell.estimatedFrameForText(text: mObj.desc).height + 60
        if(height < 0){
            height = 0
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? // supercedes -
    {
        let permanent = UITableViewRowAction(style: .normal, title: "Permanent") { action, index in
            let mObj = self.customer.messagesByDate[indexPath.section].messages[indexPath.row]
            self.markPermanentMessage(message: mObj)
        }
        permanent.backgroundColor = UIColor.orange
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let mObj = self.customer.messagesByDate[indexPath.section].messages[indexPath.row]
            self.deleteMessage(message: mObj)
        }
        delete.backgroundColor = UIColor.red
        
        if(SharedObject.sharedInstance().role == "Account Manager"){
            return [delete, permanent]
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let mObj = self.customer.messagesByDate[indexPath.section].messages[indexPath.row]
//            deleteMessage(message: mObj)
//        }
    }
    
    func scrollToBottom(animated:Bool) {
        if(self.customer.messagesByDate.count > 0){
            
            let rowCount =  self.customer.messagesByDate[self.customer.messagesByDate.count - 1].messages.count
            let indexPath = IndexPath(row: (rowCount - 1), section: (self.customer.messagesByDate.count - 1) )
            self.tblMessage.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    // MARK: - SEND and DELETE MESSAGES
    
    func deleteMessage(message:Message){
        let shKey = "MessagesPerCustomer/"+message.id+"/"+message.key
        let hpsRef = FIRDatabase.database().reference(withPath: shKey)
        
        let shRef = FIRDatabase.database().reference(withPath: "Messages")
        
        shRef.queryOrdered(byChild: "id").queryEqual(toValue: message.key)
            .observe(.value, with: { snapshot in
                if (snapshot.value is NSNull) {
                    print("Error in Reading Message per Customer table")
                }
                else
                {
                    for item in snapshot.children {
                        let sHistory = MessagePerCustomer(snapshot: item as! FIRDataSnapshot)
                        sHistory.ref?.removeValue()
                    }
                }
            })
        
        hpsRef.removeValue()
        message.ref?.removeValue()
    }
    
    func markPermanentMessage(message:Message){
        let shKey = "Messages/"+message.key
        let ref = FIRDatabase.database().reference().child(shKey)
        let value = message.permanent == "1" ? "0" : "1"
        ref.updateChildValues([
            "permanent": value,
            "combineCustPermanent": self.customer.name + "_" + value
        ])
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        handleSend(isMessage : true)
    }
    
    func handleSend(isMessage : Bool){
        txtMessage.resignFirstResponder()
        self.sendPressed = true
        sendMessage(isMessage : isMessage)
        
        self.txtMessage.text = ""
        DispatchQueue.main.async {
            SharedObject.sharedInstance().playSendMessage()
            self.scrollToBottom(animated:true)
        }
    }
    
    func sendMessage(isMessage : Bool) {
        
        self.messagePerCustomerRef = FIRDatabase.database().reference(withPath: "MessagesPerCustomer")
        
        let post1Ref = messagePerCustomerRef?.childByAutoId()
        let str = customer.key + "/" + (post1Ref?.key)!
        
        let postRef = messagePerCustomerRef?.child(str)
        let mpc = MessagePerCustomer();
        let data = mpc.toAnyObject(key: (post1Ref?.key)!)
        postRef?.setValue(data)

        self.messageRef = FIRDatabase.database().reference(withPath: "Messages")
        let postMessageRef = messageRef?.child((post1Ref?.key)!)
        
        let message = createMessageObject()
        message.id = customer.key
        message.desc = txtMessage.text!
        
        let messageData = message.toAnyObject()
        postMessageRef?.setValue(messageData)
        
        self.sendPressed = true
    }
    
    func fadeIn(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            self.lblNotification.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            self.lblNotification.alpha = 0.0
        })
    }
    
    // MARK: - KEYBOARD FUNCTIONS
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        self.txtMsgBottomConstraint.constant = (keyboardSize?.height)!
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        self.txtMsgBottomConstraint.constant = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend(isMessage : true)
        return true
    }
    
    // MARK: - MENU - LONG PRESS

    func showMenu(cell : MessageTableCell) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        let deleteItem = UIMenuItem(title: "Delete me", action: #selector(self.deleteLine))
        menu.menuItems = [deleteItem]
//        menu.setTargetRect(CGRect(x: 100, y: 80, width: 50, height: 50), in: self.view)
        menu.setTargetRect(CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y - 20, width: 50, height: 50), in: self.view)
        menu.setMenuVisible(true, animated: true)
    }
    
    func deleteLine() {
        //Do something here
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(self.deleteLine) {
            return true
        }
        return false
    }
    
    // MARK: - SWITCH BETWEEN FAVORITE AND ALL MESSAGES

    @IBAction func itemMessagePressed(_ sender: Any) {
        
        if(self.barItemMessage.tag == 0){
            self.barItemMessage.image =  UIImage(named: "message-all.png")
            self.barItemMessage.tag = 1
            lastMessageCount = 0
            isShowAll = false
            self.tableBottomConstraint.constant -= viewFooter.frame.size.height
            self.viewFooter.isHidden = true
            txtMessage.resignFirstResponder()
            getAllPermanentMessages()
        }
        else{
            self.barItemMessage.image =  UIImage(named: "conv-fav-icon-s2.png")
            self.barItemMessage.tag = 0
            lastMessageCount = 0
            isShowAll = true
            self.tableBottomConstraint.constant += viewFooter.frame.size.height
            self.viewFooter.isHidden = false
            getAllMessages()
        }
        self.tblMessage.reloadData()
    }

    // MARK: - IMAGE UPLOAD

    @IBAction func galleryPressed(_ sender: Any) {
        self.openActionSheet()
    }

    func openActionSheet(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            self.openGallery()
        })
        let camera = UIAlertAction(title: "Take Picture", style: .default, handler: { (action) -> Void in
            self.openCamera()
        })
//        let video = UIAlertAction(title: "Record Video", style: .default, handler: { (action) -> Void in
//            self.openVideo()
//        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        alertController.addAction(photo)
        alertController.addAction(camera)
//        alertController.addAction(video)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openGallery() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }

    func openCamera() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func openVideo() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            handleVideoSelectedForUrl(videoUrl)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info as [String : AnyObject])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        let filename = UUID().uuidString + ".mov"
        let uploadTask = FIRStorage.storage().reference().child("message_movies").child(filename).putFile(url, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed upload of video:", error!)
                return
            }
            
            if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
                self.uploadToFirebaseStorageUsingImage(image: thumbnailImage)
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = ""
        }
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error ?? "Error Occurred")
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.handleSendWithImage(imageUrl: imageUrl, image: image)
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSendWithImage(imageUrl: String, image: UIImage){
        txtMessage.resignFirstResponder()
        self.sendPressed = true
        sendMessageWithImage(imageUrl: imageUrl, image: image)
        
        self.txtMessage.text = ""
        DispatchQueue.main.async {
            SharedObject.sharedInstance().playSendMessage()
            self.scrollToBottom(animated:true)
        }
    }
    
    func sendMessageWithImage(imageUrl: String, image: UIImage) {
        
        self.messagePerCustomerRef = FIRDatabase.database().reference(withPath: "MessagesPerCustomer")
        
        let post1Ref = messagePerCustomerRef?.childByAutoId()
        let str = customer.key + "/" + (post1Ref?.key)!
        
        let postRef = messagePerCustomerRef?.child(str)
        let mpc = MessagePerCustomer();
        let data = mpc.toAnyObject(key: (post1Ref?.key)!)
        postRef?.setValue(data)
        
        self.messageRef = FIRDatabase.database().reference(withPath: "Messages")
        let postMessageRef = messageRef?.child((post1Ref?.key)!)
        
        let message = createMessageObject()
        message.id = customer.key
        message.imageURL = imageUrl
        message.imageWidth = NSNumber(value : Float(image.size.width))
        message.imageHeight = NSNumber(value : Float(image.size.height))
        
        let messageData = message.toAnyObject()

        postMessageRef?.setValue(messageData)
        
        self.sendPressed = true
    }
    
    func createMessageObject() -> Message{
        let message = Message()
        message.user = SharedObject.sharedInstance().user
        message.role = SharedObject.sharedInstance().role
        message.date = AppDateFormatter.todayStringForApp()
        return message
    }
    
    
    // MARK: - IMAGE ZOOMING
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    //my custom zooming logic
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
//        print("performZoomInForStartingImageView")
        
        txtMessage.resignFirstResponder()
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.viewFooter.alpha = 0
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                //                    do nothing
            })
            
        }
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.viewFooter.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
}

