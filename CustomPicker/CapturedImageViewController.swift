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
//        self.dismissViewControllerAnimated(true) { () -> Void in
//            print("dismissed")
//        }
    }

    @IBAction func pickedButtonTapped(sender: AnyObject) {
        
        
        if let imageTaken = imageTaken {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewControllerWithIdentifier("RecallCompose") as! RecallComposeViewController
            // let nextVC = RecallComposeViewController(withImage: imageTaken)
            VC.imageTaken = imageTaken
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }

}
