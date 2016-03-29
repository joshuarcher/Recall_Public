//
//  TaggedMessagesViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 1/9/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class TaggedMessagesViewController: UIViewController {
    
    private let cellNibName = "TaggedMessagesTableViewCell"
    private let cellReuseId = "defaultTaggedCell"
    private let reuseIdFromNib = "taggedMessagesCell"

    @IBOutlet weak var tableView: UITableView!
    
    private var viewOpen: Bool = true
    
    var taggedUsers: [PFUser]? = []
    
    convenience init(withFrame viewFrame: CGRect, andUsers users: [PFUser]?) {
        self.init()
        var newFrame = viewFrame
        if let users = users {
            self.taggedUsers = users
            let count = users.count
            newFrame.size.height = (CGFloat(count) * 44)
        } else {
            newFrame.size.height = 44
        }
        self.view.frame = newFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForTable()
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }
    
    private func registerCellForTable() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseId)
        tableView.backgroundColor = UIColor.recallOffWhite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        animateTable()
        
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for each in cells {
            if let cell = each as? TaggedMessagesTableViewCell {
                cell.transform = CGAffineTransformMakeTranslation(0, -tableHeight)
            }
        }
        
        for (index, each) in cells.enumerate() {
            if let cell = each as? TaggedMessagesTableViewCell {
                UIView.animateWithDuration(0.5, delay: 0.01 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                    cell.transform = CGAffineTransformMakeTranslation(0, 0)
                    }, completion: { (returned: Bool) -> Void in
                        // NSLog("success: %@\n%@", returned, self.view)
                })
            }
        }
        
    }
    
    func toggleTable() {
        // guard let taggedUsers = taggedUsers else {print("no tagged users in toggleTable()"); return}
        if viewOpen {
            let cells = tableView.visibleCells
            let tableHeight: CGFloat = tableView.bounds.size.height
            
            for (index, each) in cells.enumerate() {
                if let cell = each as? TaggedMessagesTableViewCell {
                    UIView.animateWithDuration(0.5, delay: 0.00 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                        cell.transform = CGAffineTransformMakeTranslation(0, -tableHeight)
                        }, completion: { (returned: Bool) -> Void in
                            // NSLog("success: %@\n%@", returned, self.view)
                    })
                }
            }
            
        } else {
            let cells = tableView.visibleCells
//            let tableHeight: CGFloat = tableView.bounds.size.height
            
//            for each in cells {
//                if let cell = each as? TaggedMessagesTableViewCell {
//                    cell.transform = CGAffineTransformMakeTranslation(0, -tableHeight)
//                }
//            }
            
            for (index, each) in cells.enumerate() {
                if let cell = each as? TaggedMessagesTableViewCell {
                    UIView.animateWithDuration(0.5, delay: 0.01 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                        cell.transform = CGAffineTransformMakeTranslation(0, 0);
                        }, completion: { (returned: Bool) -> Void in
                            // NSLog("success: %@\n%@", returned, self.view)
                    })
                }
            }
        }
        viewOpen = !viewOpen
    }
    
    
    
    /*
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells()
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    */
    
    func toggleHeight() {
        var newwFrame = self.view.frame
        
        var newwHeight: CGFloat = 0
        if newwFrame.size.height == 0 {
            let numberrRow: CGFloat = 5
            let rowwHeight: CGFloat = 44
            newwHeight = numberrRow * rowwHeight
        } else {
            newwHeight = 0
        }
        
        newwFrame.size.height = newwHeight
        
        
        let numberRow: CGFloat = 5
        let rowHeight: CGFloat = 44
        let newHeight = numberRow * rowHeight
        
        var newFrame = self.view.frame
        newFrame.size.height = newHeight
        
//        UIView.animateWithDuration(5) { () -> Void in
//            self.view.frame = newwFrame
//        }
        
        UIView.animateWithDuration(5, animations: { () -> Void in
            self.view.frame = newwFrame
            }) { (returned: Bool) -> Void in
                NSLog("success: %@\n%@", returned, self.view)
        }
    }
    
    func animateOpen() {
        var newFrame = self.view.frame
        
        let numberRow: CGFloat = 5
        let rowHeight: CGFloat = 44
        let newHeight = numberRow * rowHeight
        
        newFrame.size.height = newHeight
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.view.frame = newFrame
            }) { (returned: Bool) -> Void in
                NSLog("success: %@\n%@", returned, self.view)
        }
    }
    
    func animateClose() {
        var newFrame = self.view.frame
        newFrame.size.height = 0
        
        UIView.animateWithDuration(0) { () -> Void in
            self.view.frame = newFrame
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TaggedMessagesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taggedUsers = taggedUsers else { return 1 }
        return taggedUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TaggedMessagesTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! TaggedMessagesTableViewCell
        
        guard let taggedUsers = taggedUsers else {
            cell.usernameLabel.text = "error fetching tagged users"
            return cell
        }
        if let username = taggedUsers[indexPath.row].username {
            if let currentUser = PFUser.currentUser() {
                if username == currentUser.username {
                    cell.usernameLabel.text = "you"
                } else {
                    cell.usernameLabel.text = username
                }
            }
            
        } else {
            cell.usernameLabel.text = "troll"
        }
        
        return cell
    }
    
}

extension TaggedMessagesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // line from edge to edge
        
        // remove inset
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // don't inherit margin settings
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // explicityl set layout margins
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
    }
    
}
