//
//  MessagesViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/30/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.

/*
1) removee UIViewController and replace with JSQMessagesViewController
2) set variables for bubbles image views
3)
*/


import UIKit
import Parse
import RealmSwift
import JSQMessagesViewController

class MessagesViewController: JSQMessagesViewController {
    
    private let taggedFriendsImage = "TaggedButton"
    
    var photo: Photo?
    
    var realmMessages: Results<MessageRealm>?
    
    var taggedMessages: TaggedMessagesViewController?
    
    var taggedUsers: [PFUser]?
    
    var fromUser: PFUser?
    
    // MARK: - JSQMessages variables
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage?
    var incomingBubbleImageView: JSQMessagesBubbleImage?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        registerJSMessages()
        initializeBubbles()
        findUsernames()
    }
    
    func findUsernames() {
        var usersTagged: [PFUser] = []
        if let fromUser = fromUser {
            usersTagged.append(fromUser)
        }
        if let photo = photo, tagged = photo.taggedUsers {
            ParseHelper.taggedUsersMessages(forRelation: tagged, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
                if let resultUsers = results as? [PFUser] {
                    for user in resultUsers {
                        usersTagged.append(user)
                        self.taggedUsers = usersTagged
                    }
                }
                if let error = error {
                    NSLog("error getting taggedUsers: %@", error)
                }
            })
        } else {
            NSLog("Something wrong with photo in findUsersnames()")
        }
        self.taggedUsers = usersTagged
    }
    
    override func viewWillAppear(animated: Bool) {
        getMessagesFromRealm()
        savePictureMessage()
        syncParseWithMessages(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        // purge temporary messages, sync new from parse
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        syncParseWithMessages(true)
        RealmHelper.purgeNonParseMessages()
        deletePictureFile()
    }
    
    // MARK: - Helper methods
    
    func initializeBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        self.outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.recallRedLight())
        self.incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    func savePictureMessage() {
        if let photo = photo {
            let photoMessage = MessageRealm(photoObject: photo)
            if let image = photo.imageSent {
                image.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    if let data = data, objId = photo.objectId {
                        FileManager.saveImageData(toPath: objId, data: data)
                        photoMessage.setImagePathForObject(objId)
                        RealmHelper.saveMessageAlreadyCreated(photoMessage)
                    }
                })
            }
        }
    }
    
    func deletePictureFile() {
        if let photo = photo, objId = photo.objectId {
            FileManager.deleteImageData(atPath: objId)
        }
    }
    
    func getMessagesFromRealm() {
        guard let photo = photo else {
            NSLog("Photo is nil when getting messages from Realm")
            return
        }
        self.realmMessages = RealmHelper.getMessagesForPhoto(photo)
    }
    
    func syncParseWithMessages(isDisappear: Bool) {
        guard let photo = photo else {
            NSLog("Photo is nil when syncing parse messages")
            return
        }
        ParseHelper.findMessagesForPhoto(photo) { (results: [PFObject]?, error: NSError?) -> Void in
            if let results = results {
                let messages: [Message] = results as? [Message] ?? []
                RealmHelper.saveMessagesFromParse(messages)
            }
            if !isDisappear {
                self.finishReceivingMessage()
            }
        }
    }
    
    func registerJSMessages() {
        
        let _ = Message()
        let currentUser = PFUser.currentUser()?.username
        self.senderId = currentUser
        self.senderDisplayName = currentUser
        
        self.collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    func setTitle() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        guard let photo = photo else {return}
        self.navigationItem.title = formatter.stringFromDate(photo.createdAt!)
        setNavButton()
    }
    
    func setNavButton() {
        guard let navC = self.navigationController, topView = navC.topViewController else {return}
        let buttonImage = UIImage(named: taggedFriendsImage)
        let button = UIBarButtonItem(image: buttonImage, style: .Plain, target: self, action: "handleButtonPress")
        
        topView.navigationItem.rightBarButtonItem = button
    }
    
    func handleButtonPress() {
        print("nav button pressed")
        toggleTaggedView()
    }
    
    func toggleTaggedView() {
        
        if taggedMessages == nil {
            guard let taggedUsers = taggedUsers else {print("no taggedUsers in toggleTaggedView"); return }
            print(taggedUsers.count)
            let frame = CGRectMake(0, 44, self.view.frame.width, 220)
            taggedMessages = TaggedMessagesViewController(withFrame: frame, andUsers: taggedUsers)
            guard let taggedMessages = taggedMessages else {print("not instantiated");return}
            self.view.addSubview(taggedMessages.view)
        } else {
            guard let taggedMessages = taggedMessages else {print("not there"); return }
            taggedMessages.toggleTable()
            //taggedMessages.toggleHeight()
            //taggedMessages.view.hidden = !taggedMessages.view.hidden
        }
    }
    
}

// MARK: - JSQMessages Collection view shtuffffff

extension MessagesViewController {
    
    func tempRealmWrite(message: MessageRealm) {
        RealmHelper.saveMessageAlreadyCreated(message)
    }
    
    func tempSendMessage(text: String!, sender: String!) {
        guard let photo = photo else { return }
        let newMessage = MessageRealm(text: text, sender: sender, photoId: photo.objectId!)
        tempRealmWrite(newMessage)
    }
    
    func sendMessage(text: String!, sender: String!) {
        tempSendMessage(text, sender: sender)
        let newMessageAgain = Message()
        newMessageAgain.mText.value = text
        guard let photo = photo else { return }
        newMessageAgain.sendMessageForPhoto(photo)
    }
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
//    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
//        JSQSystemSoundPlayer.jsq_playMessageSentSound()
//        
//        sendMessage(text, sender: sender)
//        
//        finishSendingMessage()
//    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
        
        sendMessage(text, sender: senderDisplayName)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Camera pressed!")
    }
    
    ///////////////////////////////
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        guard let realmMessages = realmMessages else { return nil }
        return realmMessages[indexPath.item]
    }
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
//        guard let realmMessages = realmMessages else {return nil}
//        let message = realmMessages[indexPath.item]
//        
//        if message.sender() == senderDisplayName {
//            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
//        }
//        
//        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
//    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        guard let realmMessages = realmMessages else {return nil}
        let message = realmMessages[indexPath.item]
        
        if message.senderDisplayName() == senderDisplayName {
            return outgoingBubbleImageView
        }
        
        return incomingBubbleImageView
    }
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
////        guard let jMessages = jMessages else { return nil }
////        let message = jMessages[indexPath.item]
////        if let avatar = avatars[message.sender()] {
////            return UIImageView(image: avatar)
////        } else {
////            setupAvatarImage(message.sender(), imageUrl: message.imageUrl(), incoming: true)
////            return UIImageView(image:avatars[message.sender()])
////        }
//        return nil
//    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let realmMessages = realmMessages else { return 0 }
        return realmMessages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        guard let realmMessages = realmMessages, textView = cell.textView else {  return cell }
        let message = realmMessages[indexPath.item]
        
        if message.senderDisplayName() == senderDisplayName {
            textView.textColor = UIColor.blackColor()
        } else {
            textView.textColor = UIColor.blackColor()
        }
        
        let attributes : [String:AnyObject] = [NSForegroundColorAttributeName:textView.textColor!.description, NSUnderlineStyleAttributeName: 1]
        textView.linkTextAttributes = attributes
        
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        guard let realmMessages = realmMessages else { return nil }
        let message = realmMessages[indexPath.item]
        
        // Sent by current user, skip
        if message.senderDisplayName() == senderDisplayName {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = realmMessages[indexPath.item - 1]
            
            if previousMessage.senderDisplayName() == message.senderDisplayName() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        guard let realmMessages = realmMessages else { return CGFloat(0.0) }
        let message = realmMessages[indexPath.item]
        
        // Sent by current user, skip
        if message.senderDisplayName() == senderDisplayName {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = realmMessages[indexPath.item - 1]
            
            if previousMessage.senderDisplayName() == message.senderDisplayName() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
}

