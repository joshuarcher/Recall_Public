//
//  ContactsHelper.swift
//  Reecall
//
//  Created by Joshua Archer on 11/8/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import Foundation
import Contacts

class ContactsHelper {
    
    static let addressBook = APAddressBook()
    
    static let contactStore = CNContactStore()
    
    static func getContactNumbers(completion: (contacts: [APContact]?, error: NSError?) -> Void) {
        addressBook.fieldsMask = APContactField.PhonesOnly
        addressBook.loadContacts { (contacts: [APContact]?, error: NSError?) -> Void in
            if let contacts = contacts {
                completion(contacts: contacts, error: nil)
            }
            else {
                completion(contacts: nil, error: error)
            }
        }
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    static func contactAuthorized() -> Bool {
        let authStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        if authStatus == .Authorized {
            return true
        }
        else {
            return false
        }
    }
    
    static func showMessage(message: String) {
        let alertController = UIAlertController(title: "Recall", message: message, preferredStyle: .Alert)
        
        let dismiss = UIAlertAction(title: "Gotcha!", style: .Default, handler: nil)
        
        alertController.addAction(dismiss)
        
        let pushedViewControllers = (getAppDelegate().window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewcontroller = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewcontroller.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func requestContactAccess(completion: (accessGranted: Bool) -> Void) {
        let authStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authStatus {
        case .Authorized:
            completion(accessGranted: true)
        
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access: Bool, error: NSError?) -> Void in
                if access {
                    completion(accessGranted: true)
                }
                else {
                    if authStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(error!.localizedDescription)\n\nPlease allow Recall to access your contacts through the Settings so we can help you find your friends!"
                            self.showMessage(message)
                        })
                    }
                }
            })
        default:
            completion(accessGranted: false)
        }
    }
    
    static func getContactsForUser(completion: (contacts: [CNContact]?, error: Bool) -> Void) {
        var contacts = [CNContact]()
        let contactKey = CNContactPhoneNumbersKey
        let fetchRequest = CNContactFetchRequest(keysToFetch: [contactKey])
        fetchRequest.unifyResults = true
        fetchRequest.predicate = nil
        do {
            _ = try contactStore.enumerateContactsWithFetchRequest(fetchRequest) { (contact: CNContact, cursor) -> Void in
                let theContact = contact as CNContact
                contacts.append(theContact)
            }
        } catch {
            print("error fetching contacts")
            completion(contacts: nil, error: true)
            return
        }
        
        completion(contacts: contacts, error: false)
    }
    
}