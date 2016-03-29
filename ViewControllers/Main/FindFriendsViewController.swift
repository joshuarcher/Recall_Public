//
//  FindFriendsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 3/19/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

//findFriendsCell

class FindFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactStore: CNContactStore?
    
    var userContacts: [CNContact]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if contactStore == nil {
            contactStore = CNContactStore()
        }
        getContactsFromStore()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonTapped(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Message Fetching
    
    func getContactsFromStore() {
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                self.findContactsOnBackgroundThread({ (contacts: [CNContact]?) -> () in
                    if let contacts = contacts {
                        self.userContacts = contacts
                    } else {
                        print("no contacts found for some reason")
                    }
                })
            }
        }
    }
    
    func findContactsOnBackgroundThread ( completionHandler:(contacts:[CNContact]?)->()) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey] //CNContactIdentifierKey
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)
            var contacts = [CNContact]()
            CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
            
            fetchRequest.mutableObjects = false
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .GivenName
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            print("\(contactStoreID)")
            
            
            do {
                
                try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        contacts.append(contact)
                    }
                    
                }
            } catch let error as NSError {
                NSLog("error enumerating contacts in findContactsOnBackground: %@", error)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(contacts: contacts)
                
            })
        })
    }
    
    func sendMessage(recipientNumber: String) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Hey, I couldn't find you on Recall! Dowload Recall now at recall-that.com";
        messageVC.recipients = [recipientNumber]
        messageVC.messageComposeDelegate = self
        
        self.presentViewController(messageVC, animated: true, completion: nil)
    }

}

// MARK: Message Sending

extension FindFriendsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
}

extension FindFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userContacts?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("findFriendsCell") as! FindFriendsTableViewCell
        
        guard let userContacts = userContacts else { return cell }
        cell.phoneContact = userContacts[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let userContacts = self.userContacts else { return }
        if let contactPhone = userContacts[indexPath.row].phoneNumbers[0].value as? CNPhoneNumber {
            sendMessage(contactPhone.stringValue)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(50)
    }
}
