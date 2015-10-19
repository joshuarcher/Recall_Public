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
        
        let nib = UINib(nibName: "RecallTableViewCell", bundle: nil)
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
        ParseHelper.timeCapsuleRequestForCurrentUser(range) { (results: [PFObject]?, error: NSError?) -> Void in
            let photos = results as? [Photo] ?? []
            completionBlock(photos)
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

// MARK: - TableView Methods

extension RecallViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecallTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("timelineCell") as! RecallTableViewCell
        
        let photo = timelineComponent.content[indexPath.row]
        photo.downloadImage()
        cell.photo = photo
        cell.senderLabel.text = "josh"
        
        return cell
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
    
}

extension RecallViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}
