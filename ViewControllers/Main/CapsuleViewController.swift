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
    
    private let cellNibName = "RCCapsuleCell"
    private let cellReuseId = "recallCapsuleCell"
    
    private let rowHeight: CGFloat = 290
    @IBOutlet weak var tableView: UITableView!
    
    enum Notifications {
        static let viewAppeared = "homeControllerAppeared"
    }
    
    var photoObjects: [PFObject]?
    
    private weak var emptyView: UIView?
    
    // MARK: - TimelineComponent properties
    
    var timelineComponent: TimelineComponent<Photo, CapsuleViewController>!
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
        subscribeToNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeToNotifications()
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
    
    // MARK: Empty Data Set
    
    private func showEmptyDataSet() {
        if timelineComponent.content.count > 0 {
            if let _ = emptyView {
                self.emptyView?.removeFromSuperview()
                self.emptyView = nil
            }
        } else if timelineComponent.content.count == 0 {
            addView()
        }
    }
    
    private func addView() {
        let tableViewFrame = self.tableView.frame
        if let emptyView = emptyView {
            emptyView.frame = tableViewFrame
            self.tableView.addSubview(emptyView)
        } else {
            let nibContents = NSBundle.mainBundle().loadNibNamed("CapsulesEmptyDataSetView", owner: nil, options: nil)
            emptyView = nibContents.last as? UIView
            if let emptyView = emptyView {
                emptyView.frame = tableViewFrame
                self.tableView.addSubview(emptyView)
            }
        }
        
    }
    
    
    // MARK: - TimelineComponent Methods
    
    private func registerTimelineComponent() {
        self.timelineComponent = TimelineComponent(target: self)
    }
    
    func loadInRange(range: Range<Int>, completionBlock: ([Photo]?) -> Void) {
        ParseHelper.timeCapsuleRequestForCurrentUser(range) { (results: [PFObject]?, error: NSError?) -> Void in
            let photos = results as? [Photo] ?? []
            self.showEmptyDataSet()
            completionBlock(photos)
        }
    }
    
    // MARK: - Notification Methods
    
    func subscribeToNotifications() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "reloadTableView", name: Notifications.viewAppeared, object: nil)
    }
    
    func unsubscribeToNotifications() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.removeObserver(self)
    }
    
    func reloadTableView() {
        timelineComponent.refresh(self)
    }
    
}

// MARK: - TableView Methods

extension CapsuleViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: RCCapsuleCell = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! RCCapsuleCell
        let photo = timelineComponent.content[indexPath.row]
        photo.downloadImage()
        cell.photo = photo
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.rowHeight + 4
        }
        return self.rowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 4
//    }
//    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else {
//            return
//        }
//        header.contentView.backgroundColor = UIColor.recallOffWhite()
//    }
}

extension CapsuleViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}
