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

class MessagesViewController: JSQMessagesViewController {
    
    var photo: Photo?
    var messages: [Message]?
    var jMessages: [JMessage]?
    
    var realmMessages: Results<MessageRealm>?
    
    // MARK: - JSQMessages variables
    
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        registerJSMessages()
        
        // commenting for trying realm
//        // download messages
//        guard let photo = photo else {return}
//        getMessagesFromParse(photo)
    }
    
    override func viewWillAppear(animated: Bool) {
        getMessagesFromRealm()
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
    }
    
    // MARK: - Helper methods
    
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
        // commenting for trying realm
//        jMessages = []
        let _ = Message()
        self.sender = PFUser.currentUser()?.username
        
        self.collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    func setTitle() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        guard let photo = photo else {return}
        self.navigationItem.title = formatter.stringFromDate(photo.createdAt!)
    }
    
    func getMessagesFromParse(photo: Photo) {
        ParseHelper.findMessagesForPhoto(photo, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
            let newMessages: [Message] = results as? [Message] ?? []
            for new in newMessages {
                let jNew = JMessage(text: new.messageText, sender: new.fromUser?.username)
                self.jMessages?.append(jNew)
                self.finishReceivingMessage()
            }
            self.messages = newMessages
        })
    }
    
}

// MARK: - JSQMessages Collection view shtuffffff

extension MessagesViewController {
    
    func tempRealmWrite(message: MessageRealm) {
        RealmHelper.saveMessageAlreadyCreated(message)
    }
    
    func tempSendMessage(text: String!, sender: String!) {
//        let newMessage = JMessage(text: text, sender: sender)
//        jMessages?.append(newMessage)
        guard let photo = photo else { return }
        let newMessage = MessageRealm(text: text, sender: sender, photoId: photo.objectId!)
        tempRealmWrite(newMessage)
//        self.realmMessages?.realm?.add(newMessage)
//        RealmHelper.saveMessageAlreadyCreated(newMessage)
//        self.realmMessages = RealmHelper.getMessagesForPhoto(photo)
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
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        sendMessage(text, sender: sender)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Camera pressed!")
    }
    
    ///////////////////////////////
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        guard let realmMessages = realmMessages else { return nil }
        return realmMessages[indexPath.item]
        // commenting for trying realm
//        guard let jMessages = jMessages else { return nil }
//        return jMessages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        guard let realmMessages = realmMessages else {return nil}
        let message = realmMessages[indexPath.item]
        // commenting for trying realm
//        guard let jMessages = jMessages else { return nil }
//        let message = jMessages[indexPath.item]
        
        if message.sender() == sender {
            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
//        guard let jMessages = jMessages else { return nil }
//        let message = jMessages[indexPath.item]
//        if let avatar = avatars[message.sender()] {
//            return UIImageView(image: avatar)
//        } else {
//            setupAvatarImage(message.sender(), imageUrl: message.imageUrl(), incoming: true)
//            return UIImageView(image:avatars[message.sender()])
//        }
        return nil
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let realmMessages = realmMessages else { return 0 }
        return realmMessages.count
        // commeting for trying realm
//        guard let jMessages = jMessages else { return 0 }
//        return jMessages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        guard let realmMessages = realmMessages else {  return cell }
        let message = realmMessages[indexPath.item]
        // commenting for trying realm
//        guard let jMessages = jMessages else { return cell }
//        let message = jMessages[indexPath.item]
        
        if message.sender() == sender {
            cell.textView!.textColor = UIColor.blackColor()
        } else {
            cell.textView!.textColor = UIColor.whiteColor()
        }
        
        let attributes : [String:AnyObject] = [NSForegroundColorAttributeName:cell.textView!.textColor!.description, NSUnderlineStyleAttributeName: 1]
        cell.textView!.linkTextAttributes = attributes
        
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        guard let realmMessages = realmMessages else { return nil }
        let message = realmMessages[indexPath.item]
        // commenting for trying realm
//        guard let jMessages = jMessages else { return nil }
//        let message = jMessages[indexPath.item];
        
        // Sent by me, skip
        if message.sender() == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = realmMessages[indexPath.item - 1]
            // commenting for trying realm
//            let previousMessage = jMessages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.sender())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        guard let realmMessages = realmMessages else { return 0 }
        let message = realmMessages[indexPath.item]
        // commenting for trying realm
//        guard let jMessages = jMessages else { return 0 }
//        let message = jMessages[indexPath.item]
        
        // Sent by me, skip
        if message.sender() == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = realmMessages[indexPath.item - 1]
            // commenting for trying realm
//            let previousMessage = jMessages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
}
