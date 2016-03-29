//
//  UsernameSearchViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 3/13/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class UsernameSearchViewController: UIViewController {
    
    @IBOutlet weak var usernameSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    // stores all the users that match the current search query
    var users: [PFUser]?
    
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    
    // this view can be in two different states
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    // whenever the state changes, perform one of the two queries and update the list
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
//            case .DefaultMode:
//                query = ParseHelper.allUsers(updateList)
                
            case .SearchMode:
                let searchText = usernameSearchBar?.text ?? ""
                query = ParseHelper.searchUsers(searchText, completionBlock: updateList)
            default:
                return
            }
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        state = .DefaultMode
    }
    
    // Update user list
    
    func updateList(results: [PFObject]?, error: NSError?) {
        self.users = results as? [PFUser] ?? []
        self.searchTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Search Bar Delegate

extension UsernameSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ParseHelper.searchUsers(searchText, completionBlock:updateList)
    }
    
}

// MARK: - TableView DataSource & Delegate

extension UsernameSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addUsernameCell") as! UsernameSearchTableViewCell
        
        guard let users = self.users else { return cell }
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    // MARK: Cell Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let users = self.users else {return}
        ParseHelper.addFriendsWithRelationForCurrentUser(users[indexPath.row])
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        guard let users = self.users else {return}
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
}
