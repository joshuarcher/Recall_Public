//
//  TagFriendsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/21/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse
import RealmSwift

class TagFriendsViewController: UIViewController {
    
    private let tagFriendCellReuseId = "tagFriendCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagFriendsButton: UIButton!
    @IBOutlet weak var taggedUsersLabel: UILabel!
    
    var realmUserFriends: Results<RealmUser>?
    
    var taggedFriends: [String]!
    var cellsToSelect: [NSIndexPath]!
    
    // variables for image sending
    var dateTuple: (Int, Int)?
    var capturedImage: UIImage?
    
    // search bar
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                getFriendsFromRealm()
            case .SearchMode:
                return
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taggedFriends == nil {
            taggedFriends = []
        }
        if cellsToSelect == nil {
            cellsToSelect = []
        }
        // show button if there are tagged users
        updateTagButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.state = .DefaultMode
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        getFriendsFromRealm()
        parseRequestFriends()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateSelectedCells()
//        print("hey: \(taggedFriends)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController() {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    // MARK: - Helper Functions
    
    func getFriendsFromRealm() {
        self.realmUserFriends = RealmHelper.getUserFriends()
    }
    
    // get friends from parse, then save them in Realm, reload view (Replace with synchronizer?)
    func parseRequestFriends() {
        
        ParseHelper.findFriendsRequestForCurrentUser { (results: [PFObject]?, error: NSError?) -> Void in
            if let relations = results {
                var users: [PFUser] = []
                
                for relation in relations {
                    // to user could be nil, so check for that
                    if let friendUser = relation.objectForKey(ParseHelper.ParseFriendTouser) as? PFUser {
                        users.append(friendUser)
                    }
                }
                
                RealmHelper.saveUserFriendsFromParse(users)
                self.tableView.reloadData()
            }
        }
    }
    
    func updateTagButton() {
        guard let taggedFriends = taggedFriends else {return}
        if taggedFriends.count == 0 {
            taggedUsersLabel.text = "personal"
        } else {
            taggedUsersLabel.text = "\(taggedFriends.count) others"
        }
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        sendRecall()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func sendRecall() {
        guard let capturedImage = self.capturedImage, dateTuple = self.dateTuple else { return }
        let photo = Photo()
        photo.image.value = capturedImage
        photo.taggedFriends.value = taggedFriends
        photo.dateDisplay.value = GenHelper.getDateToSend(dateTuple)
        photo.uploadPost()
    }
    

}

// MARK: - Tableview Methods

extension TagFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let realmUserFriends = realmUserFriends else {return 0}
        return realmUserFriends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TagFriendTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(tagFriendCellReuseId) as! TagFriendTableViewCell
        if let realmUserFriends = realmUserFriends {
            cell.usernameLabel.text = realmUserFriends[indexPath.row].parseUsername
            
            // select cell on load if already tagged
            if let taggedFriends = taggedFriends, objId = realmUserFriends[indexPath.row].parseObjectId {
                if taggedFriends.contains(objId) {
//                    cellsToSelect.append(indexPath)
                    tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
}

extension TagFriendsViewController: UITableViewDelegate {
    // add objectID to list of tagged users
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let realmUserFriends = realmUserFriends {
            guard let taggedObjectId = realmUserFriends[indexPath.row].parseObjectId else {
                print("No object Id for realmFriends in didSelectRowAtIndexPath")
                return
            }
            addToTagged(taggedObjectId)
            updateTagButton()
        }
    }
    
    // remove objectID form list of tagged users
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let realmUserFriends = realmUserFriends {
            guard let taggedObjectId = realmUserFriends[indexPath.row].parseObjectId else {
                print("No object Id for realmFriends in didDeselectRowAtIndexPath")
                return
            }
            taggedFriends.removeObject(taggedObjectId)
            updateTagButton()
        }
    }
    
    func addToTagged(objectId: String) {
        if !taggedFriends.contains(objectId) {
            taggedFriends.append(objectId)
        }
    }
    
    func updateSelectedCells() {
        
        for cell in cellsToSelect {
            tableView.selectRowAtIndexPath(cell, animated: false, scrollPosition: .None)
        }
    }
    
}
