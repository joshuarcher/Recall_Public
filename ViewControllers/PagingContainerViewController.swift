//
//  PagingContainerViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 10/8/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class PagingContainerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var timelineViewController: TimelineViewController!
    var timeCapsuleViewController: TimeCapsuleViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Helper methods
    
    func setUpView() {
        self.timeCapsuleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TimeCapsule") as! TimeCapsuleViewController

        self.addChildViewController(timeCapsuleViewController)
        self.scrollView.addSubview(timeCapsuleViewController.view)
        self.timeCapsuleViewController.didMoveToParentViewController(self)
        var tableFrame = timeCapsuleViewController.tableView.frame
        tableFrame.size.width = 375
        timeCapsuleViewController.tableView.frame = tableFrame
        
        self.timelineViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Timeline") as! TimelineViewController
        
        var timeFrame = timelineViewController.view.frame
        timeFrame.origin.x = self.view.frame.size.width
        self.timelineViewController.view.frame = timeFrame
        
        self.addChildViewController(timelineViewController)
        self.scrollView.addSubview(timelineViewController.view)
        self.timelineViewController.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 66)
        
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
