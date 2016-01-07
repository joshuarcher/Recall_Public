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
    
    private let cellNibName = "RCTimelineCell"
    private let cellReuseId = "timelineCell"
    private let messagesViewNibName = "MessagesViewController"

    private let rowHeight: CGFloat = 290
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - TimelineComponent properties
    
    var timelineComponent: TimelineComponent<Photo, RecallViewController>!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTimelineComponent()
        registerCellForTable()
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
    
    private func registerCellForTable() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseId)
        tableView.backgroundColor = UIColor.recallOffWhite()
    }
    
    // MARK: - TimelineComponent Methods
    
    private func registerTimelineComponent() {
        self.timelineComponent = TimelineComponent(target: self)
    }
    
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
        let cell: RCTimelineCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! RCTimelineCell
        
        let photo = timelineComponent.content[indexPath.row]
        photo.downloadImage()
        cell.photo = photo
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.rowHeight
    }
    
}

extension RecallViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get messages view controller, pass photo, push view
        let photo = timelineComponent.content[indexPath.row]
        let nextVc: MessagesViewController = MessagesViewController(nibName: messagesViewNibName, bundle: nil)
        nextVc.photo = photo
        self.navigationController?.pushViewController(nextVc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
}
