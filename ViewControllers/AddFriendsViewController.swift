//
//  AddFriendsViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/21/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class AddFriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var usersToAdd: [PFUser]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseHelper.addFriendsRequestForCurrentUser { (results: [PFObject]?, error: NSError?) -> Void in
            let users = results as? [PFUser] ?? []
            self.usersToAdd = users
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AddFriendsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let usersToAdd = usersToAdd else {return 0}
        return usersToAdd.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AddFriendTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("addFriendCell") as! AddFriendTableViewCell
        
        //let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("testCell")!
        if let usersToAdd = usersToAdd {
            cell.cellUser = usersToAdd[indexPath.row] as PFUser
        }
        
        return cell
    }
}
