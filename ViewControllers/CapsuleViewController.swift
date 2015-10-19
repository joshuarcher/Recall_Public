//
//  CapsuleViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/16/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class CapsuleViewController: UIViewController, TimelineComponentTarget {
    
    let testLabels = ["shit", "josh", "dani", "jonah", "colby", "solit"]
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - TimelineComponent properties
    
    var timelineComponent: TimelineComponent<Photo, CapsuleViewController>!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timelineComponent = TimelineComponent(target: self)

        let nib = UINib(nibName: "CapsuleTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "capsuleCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timelineComponent.loadInitialIfRequired()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TimelineComponent Methods
    
    func loadInRange(range: Range<Int>, completionBlock: ([Photo]?) -> Void) {
        ParseHelper.timeCapsuleRequestForCurrentUser(range) { (results: [PFObject]?, error: NSError?) -> Void in
            let photos = results as? [Photo] ?? []
            completionBlock(photos)
        }
    }

}

// MARK: - TableView Methods

extension CapsuleViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CapsuleTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("capsuleCell") as! CapsuleTableViewCell
        
        let photo = timelineComponent.content[indexPath.row]
        photo.downloadImage()
        cell.photo = photo
        cell.senderLabel.text = "josh"
        cell.timeLabel.text = "28 days"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell: CapsuleTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! CapsuleTableViewCell
        UIView.animateWithDuration(3.0, animations: { () -> Void in
            cell.timeLabel.alpha = 1
            cell.timeLabel.alpha = 0
            }) { (finished: Bool) -> Void in
//                if finished {
//                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
//                }
        }
        
    }
    
}

extension CapsuleViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}
