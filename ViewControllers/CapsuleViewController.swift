//
//  CapsuleViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/16/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class CapsuleViewController: UIViewController, TimelineComponentTarget {

    let testLabels = ["shit", "josh", "dani", "jonah", "colby", "solit"]
    
    @IBOutlet weak var tableView: UITableView!
    
    var timelineComponent: TimelineComponent<Photo, CapsuleViewController>!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CapsuleTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "capsuleCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timelineComponent.loadInitialIfRequired
    }
    
    func loadInRange(range: Range<Int>, completionBlock: ([Photo]?) -> Void) {
        
        ParseHelper.timeCapsuleRequestForCurrentUser(range) { (result: [AnyObject]?, error: NSError?) -> Void in
            let photos = result as? [Photo] ?? []
            completionBlock(photos)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension CapsuleViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testLabels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell: TimeCapsuleTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("capsuleCell") as! TimeCapsuleTableViewCell
        let cell: CapsuleTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("capsuleCell") as! CapsuleTableViewCell
        
        cell.testerLabel.text = testLabels[indexPath.row]
        
        return cell
    }
    
}

extension CapsuleViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}
