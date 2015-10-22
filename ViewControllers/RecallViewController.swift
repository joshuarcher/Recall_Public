//
//  RecallViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/16/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit
import Parse

class RecallViewController: UIViewController, TimelineComponentTarget {
    
    let testLabels = ["shit", "josh", "dani", "jonah", "colby", "solit"]

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - TimelineComponent properties
    
    var timelineComponent: TimelineComponent<Photo, RecallViewController>!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timelineComponent = TimelineComponent(target: self)
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "timelineCell")

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
        ParseHelper.timelineRequestForCurrentUser(range) { (results: [PFObject]?, error: NSError?) -> Void in
            let photos = results as? [Photo] ?? []
            completionBlock(photos)
        }
    }

}

// MARK: - TableView Methods

extension RecallViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TimelineTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("timelineCell") as! TimelineTableViewCell
        
        let photo = timelineComponent.content[indexPath.row]
        photo.downloadImage()
        cell.photo = photo
        
        return cell
    }
    
}

extension RecallViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}
