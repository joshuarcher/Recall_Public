//
//  ContactSearchViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 3/13/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import RealmSwift
import Contacts
import MessageUI

class ContactSearchViewController: UIViewController {
    
    enum ViewType { case Contacts, Friends }
    
    var viewControllerType: ViewType!
    
    @IBOutlet weak var tableView: UITableView!
    
    var realmUserContacts: Results<RealmUser>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var contactStore: CNContactStore?
    
    var userContacts: [CNContact]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewControllerType == .Friends && contactStore == nil {
            contactStore = CNContactStore()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if viewControllerType == .Contacts {
            getContactsFromRealm()
            syncFabricParseWithContacts()
        } else if viewControllerType == .Friends {
            self.title = "invite friends"
            getContactsFromStore()
            // load friends stuff for inviting
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContactsFromRealm() {
        self.realmUserContacts = RealmHelper.getUserContacts()
    }
    
    func syncFabricParseWithContacts() {
        FabricHelper.findFriends { (digitUsers) -> Void in
            if let digitUsers = digitUsers {
                ParseHelper.addressBookFriendsForCurrentUser(digitUsers, completionBlock: { (results: [PFObject]?, error: NSError?) -> Void in
                    let users = results as? [PFUser] ?? []
                    RealmHelper.saveUserContactsFromParse(users)
                    self.getContactsFromRealm()
                })
            }
        }
    }
    
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
        
        messageVC.body = "Hey, I wanted to send you a Recall but I couldn't find you on the app! Dowload Recall now at recall-that.com";
        messageVC.recipients = [recipientNumber]
        messageVC.messageComposeDelegate = self
        
        self.presentViewController(messageVC, animated: true, completion: nil)
    }

}

extension ContactSearchViewController: MFMessageComposeViewControllerDelegate {
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

extension ContactSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewControllerType == .Contacts {
            return realmUserContacts?.count ?? 0
        } else if viewControllerType == .Friends {
            // load friends stuff for inviting
            return userContacts?.count ?? 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell") as! ContactSearchTableViewCell
        
        if viewControllerType == .Contacts {
            guard let realmUserContacts = self.realmUserContacts else {return cell}
            cell.realmContact = realmUserContacts[indexPath.row]
        } else if viewControllerType == .Friends {
            // load friends stuff for inviting
            guard let userContacts = userContacts else { return cell }
            cell.phoneContact = userContacts[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if viewControllerType == .Friends {
            guard let userContacts = self.userContacts else { return }
            if let contactPhone = userContacts[indexPath.row].phoneNumbers[0].value as? CNPhoneNumber {
                sendMessage(contactPhone.stringValue)
            }
        } else if viewControllerType == .Contacts {
            guard let realmUserContacts = self.realmUserContacts else { NSLog("No realmUser in selectdRow"); return}
            let userTapped = realmUserContacts[indexPath.row]
            RealmHelper.updateContactAsFriend(userTapped)
            ParseHelper.addRealmUserFriendRelation(userTapped)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(50)
    }
}
