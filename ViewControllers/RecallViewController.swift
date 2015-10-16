//
//  RecallViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/16/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class RecallViewController: UIViewController {
    
    let testLabels = ["shit", "josh", "dani", "jonah", "colby", "solit"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RecallTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "timelineCell")

        // Do any additional setup after loading the view.
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

extension RecallViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testLabels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecallTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("timelineCell") as! RecallTableViewCell
        
        cell.testerLabel.text = testLabels[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
