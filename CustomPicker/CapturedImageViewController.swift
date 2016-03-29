//
//  CapturedImageViewController.swift
//  RecallPhotoTaker2
//
//  Created by Joshua Archer on 1/14/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit

class CapturedImageViewController: UIViewController {

    @IBOutlet weak var capturedImageView: UIImageView!
    
    var imageTaken: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.imageTaken {
            self.capturedImageView.image = image
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        // self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func pickedButtonTapped(sender: AnyObject) {
        
        if let imageTaken = imageTaken {
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let VC = storyboard.instantiateViewControllerWithIdentifier("RecallCompose") as! RecallComposeViewController
//            VC.imageTaken = imageTaken
//            self.navigationController?.pushViewController(VC, animated: true)
            // changed for new date picker
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVc = storyboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
            nextVc.capturedImage = imageTaken
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
    }

}
