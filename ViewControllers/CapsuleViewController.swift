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
    
    private let rowHeight: CGFloat = 290
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - TimelineComponent properties
    
    var timelineComponent: TimelineComponent<Photo, CapsuleViewController>!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timelineComponent = TimelineComponent(target: self)

//        let nib = UINib(nibName: "TimeCapsuleTableViewCell", bundle: nil)
//        tableView.registerNib(nib, forCellReuseIdentifier: "capsuleCell")
        let nib = UINib(nibName: "RCCapsuleCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "recallCapsuleCell")

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
//        let cell: TimeCapsuleTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("capsuleCell") as! TimeCapsuleTableViewCell
//        
//        let photo = timelineComponent.content[indexPath.row]
//        photo.downloadImage()
//        cell.photo = photo
        
        let cell: RCCapsuleCell = tableView.dequeueReusableCellWithIdentifier("recallCapsuleCell") as! RCCapsuleCell
        let photo = timelineComponent.content[indexPath.row]
        photo.downloadImage()
        cell.photo = photo
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
}

extension CapsuleViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}
